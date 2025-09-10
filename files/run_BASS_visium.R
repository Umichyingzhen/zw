library(BASS)
library(Seurat)
suppressMessages(library(stringr))
library(optparse)
library(mclust)
library(ggplot2)
library(dplyr)
library(patchwork)
library(VennDiagram)
library(dplyr)
library(pROC)
library(gridExtra)
library(SeuratObject)
library(Matrix)
library(progress)
library(Seurat)
library(sctransform)
library(tibble)


adata_wt <- readRDS('/nfs/turbo/umms-congma1/datasets/spatial_transcriptomics/Spotiphy_data/Visium_WT_1.rds')
adata_ad <- readRDS('/nfs/turbo/umms-congma1/datasets/spatial_transcriptomics/Spotiphy_data/Visium_FAD_1.rds')

smps <- c('WT', 'AD') # "WT" for Normal

# make a named list of the count matrix (two dgCMatrixs)
cnts <- list(WT = GetAssayData(adata_wt, layer = 'counts'), AD = GetAssayData(adata_ad, layer = 'counts'))

# make a named list of the Coordinates Information data.frames
info_mult <- list(WT = GetTissueCoordinates(adata_wt), AD = GetTissueCoordinates(adata_ad))

# Normalize coordinates to start at (0, 0) by substract each by min()
xys <- lapply(info_mult[smps], function(info.i){
        info.i$imagerow <- info.i$imagerow - min(info.i$imagerow) 
        info.i$imagecol <- info.i$imagecol - min(info.i$imagecol)
        as.matrix(info.i[, c("imagerow", "imagecol")])
    })

# Mis-specified number of spatial domains and increased rare cell types do not have much influence on performance of cell type clustering
# Only under-specified number of cell type clusters reduced the performance of spatial domain detection, because the algorithm merged multiple true cell types into the same cluster, which led to worse cell type classification
# Increasing rare cell types do not have much influence on performance of spatial domains detection, and the performance improved when rare cell types exhibit domain-specific distribution patterns
# Rare cell types refer to cluster with relatively small number of spots, may be ignored in clustering without strong spatial separation
# Domain-specific distribution patterns are strongly enriched in a specific region compared to other regions


# Refer to the above conclusions from the paper, I prefer to start with large number of clusters and number of spatial domains
# First determine optimal number of spatial domains (with > 3% of cells per domain): Total 3,541 + 3,476 = 7,017 spots, and then 7017 * 0.03 ≈ 211 minimum spots per domain, finally the maximum number of domains is 7017/211 ≈ 33
# To ensure that the heterogeneity in gene expression can be fully accounted and avoid noise from small domains, we determine the range of R = (5, 33) and the number of cell types to 20
# 5, 6, 7, 8 are all have > 3% of cells, and we prefer larger number of domains, so 8 is optimal


# number of clusters
C <- 20
# number of spatial domains
R <- 8
set.seed(970316)

# Set up BASS object
# The hierarchical modelling structure with an intermediate layer used to explicitly model distinct gene expression of different cell types, avoiding the problem of insufficient ability of using same distribution to capture the gene expression heterogeneity across cell types
# The Swendsen-Wang algorithm is known to have a much better mixing rate than the Gibbs sampling algorithm using by BayesSpace, hence BASS achieve greater accuracy
BASS <- createBASSObject(cnts, xys, C = C, R = R, beta_method = "SW", init_method = "mclust",  nsample = 10000)

# Data pre-processing:
BASS <- BASS.preprocess(BASS, doLogNormalize = TRUE, geneSelect = "sparkx", nSE = 3200, doPCA = TRUE, scaleFeature = FALSE, nPC = 20)

# Run BASS algorithm
BASS <- BASS.run(BASS)

BASS <- BASS.postprocess(BASS)
clabels <- BASS@results$c # cell type clusters
zlabels <- BASS@results$z # spatial domain labels
pi_est <- BASS@results$pi # cell type composition matrix

# save results
df <- list(WT=data.frame(barcodes=colnames(cnts$WT), cell_type=clabels[[1]], domain_label=zlabels[[1]], sample='WT'), 
           AD=data.frame(barcodes=colnames(cnts$AD), cell_type=clabels[[2]], domain_label=zlabels[[2]], sample='AD'))
df <- do.call(rbind, df)
write.csv(df, '/home/yingzhen/R/Cluster_vs_SPADE/results.csv', quote=F, row.names=T, col.names=T)


# Visualization

Spatial_Domains <- read.csv("/home/yingzhen/R/Cluster_vs_SPADE/results.csv")

coords_df <- bind_rows(
  data.frame(xys$WT, sample = "WT", barcode = rownames(xys$WT)),
  data.frame(xys$AD, sample = "AD", barcode = rownames(xys$AD))
)

plot_df <- Spatial_Domains %>%
  rename(barcode = barcodes, domain = domain_label) %>%
  left_join(coords_df, by = c("barcode", "sample")) # Merges the domain info and spatial coordinates based on matching barcode and sample

plot_df$domain <- as.factor(plot_df$domain)

n_domains <- length(unique(plot_df$domain))
cols <- scales::hue_pal()(n_domains)

Domains <- ggplot(plot_df, aes(x = imagecol, y = imagerow, color = domain)) +
  geom_point(size = 0.2) +
  scale_color_manual(values = cols, name = "Domain") +
  facet_wrap(~sample) +
  scale_y_reverse() +
  coord_fixed() +
  theme_void() +
  theme(
    legend.position = "bottom",
    strip.text = element_text(size = 12)
  )

ggsave("/home/yingzhen/R/Cluster_vs_SPADE/Spatial_Domain_Facet.png",
       plot = Domains, width = 8, height = 4, dpi = 300, bg = "white")



# DE Test for domain-specific genes

res_df <- read.csv("/home/yingzhen/R/Cluster_vs_SPADE/results.csv")
res_df$barcode <- paste0(res_df$sample, "_", res_df$barcodes)  # match Seurat colnames

adata_wt$sample <- "WT"
adata_ad$sample <- "AD"
adata <- merge(adata_wt, y = adata_ad, add.cell.ids = c("WT", "AD"))

domains <- res_df$domain_label
names(domains) <- res_df$barcode # Map domain label to each formatted barcode
adata$domain <- domains[colnames(adata)] # Assign domain label to Seurat metadata

Idents(adata) <- "domain"
avg_expr <- AverageExpression(adata, assays = "Spatial", slot = "counts", return.seurat = FALSE) # Aggregate by domain
avg_expr_mat <- avg_expr$Spatial # Extract gene x domain average count matrix

gene2domain <- apply(avg_expr_mat, 1, function(x) as.character(which.max(x)))

res_list <- list()

for (g in names(gene2domain)) {
  dom <- gene2domain[[g]]
  cells_in_dom <- colnames(adata)[adata$domain == dom]

  if (length(cells_in_dom) < 10) next 

  subadata <- subset(adata, cells = cells_in_dom)
  Idents(subadata) <- "sample"

  if (length(unique(Idents(subadata))) == 2) {
    de <- tryCatch({
      FindMarkers(subadata, ident.1 = "AD", ident.2 = "WT",
                  features = g, logfc.threshold = 0, min.pct = 0, test.use = "wilcox")
    }, error = function(e) NULL)

    if (!is.null(de) && nrow(de) > 0) {
      de$gene <- g
      de$domain <- dom
      res_list[[g]] <- de
    }
  }
}

de_table <- bind_rows(res_list, .id = "gene_id")
write.csv(de_table, "/home/yingzhen/R/Cluster_vs_SPADE/Domain_Specific_DE.csv", row.names = FALSE)





# Compare with SAPDE

SPADE_Result <- read.csv("/home/yingzhen/R/min_cell_test/LRT_results.csv")
Domain_Result <- read.csv("/home/yingzhen/R/Cluster_vs_SPADE/DE_by_Domain.csv")

# Count total genes in each dataset
total_genes_domain <- length(unique(Domain_Result$gene))
total_genes_lrt <- length(unique(SPADE_Result$geneid))

# Count significant genes (adjusted p-value < 0.05)
sig_genes_domain <- length(unique(Domain_Result$gene[Domain_Result$p_val_adj < 0.05]))
sig_genes_lrt <- length(unique(SPADE_Result$geneid[SPADE_Result$Adjust.Pvalue < 0.05]))

# Calculate percentages
perc_domain <- round(100 * sig_genes_domain / total_genes_domain, 2)
perc_lrt <- round(100 * sig_genes_lrt / total_genes_lrt, 2)

summary_df <- data.frame(
  Method = c("DE_by_Domain", "LRT_results"),
  Total_Genes = c(total_genes_domain, total_genes_lrt),
  Significant_Genes = c(sig_genes_domain, sig_genes_lrt),
  Percent_Significant = c(perc_domain, perc_lrt)
)


print(summary_df)

write.csv(summary_df, "/home/yingzhen/R/Cluster_vs_SPADE/DE_Summary_Comparison.csv", row.names = FALSE)
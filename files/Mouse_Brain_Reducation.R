library(SPADE)
library(ggplot2)
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

# Normal Data Preprocessing
Normal_Expression_Counts <- readRDS("/nfs/turbo/umms-congma1/datasets/spatial_transcriptomics/Spotiphy_data/Visium_WT_1.rds")
Normal_Expression_Sparse <- Normal_Expression_Counts@assays$Spatial@counts # Extract the sparse expression count matrix from the object
normal_count_per_gene <- Matrix::rowSums(Normal_Expression_Sparse)
normal_gene_nonzero_counts <- Matrix::rowSums(Normal_Expression_Sparse > 0) # If the counts in a cell > 0, will be 1, otherwise, 0 
normal_sorted_genes <- names(sort(normal_count_per_gene, decreasing = TRUE))
normal_expression_all_sorted <- Normal_Expression_Sparse[normal_sorted_genes, ]
dim(normal_expression_all_sorted) # 32285*3541

Normal_Info <- Normal_Expression_Counts@images$tissue_hires_image.png@coordinates # Extract spatial coordinates
Normal_Info <- Normal_Info[, c("imagerow", "imagecol")] # Keep only coordinates for the columns (spots) present in the top 100 matrix
colnames(Normal_Info)<- c("x", "y")

# AD Data Preprocessing
AD_Expression_Counts <- readRDS("/nfs/turbo/umms-congma1/datasets/spatial_transcriptomics/Spotiphy_data/Visium_FAD_1.rds")
AD_Expression_Sparse <- AD_Expression_Counts@assays$Spatial@counts
AD_count_per_gene <- Matrix::rowSums(AD_Expression_Sparse)
AD_sorted_genes <- names(sort(AD_count_per_gene, decreasing = TRUE))
AD_expression_all_sorted <- AD_Expression_Sparse[AD_sorted_genes, ]
dim(AD_expression_all_sorted) # 32285*3476

AD_Info <- AD_Expression_Counts@images$tissue_hires_image.png@coordinates
AD_Info <- AD_Info[, c("imagerow", "imagecol")]
colnames(AD_Info) <- c("x", "y")

target_counts <- c(5, 10, 15, 20, 25, 30, 35, 40, 45)
random_genes <- sapply(target_counts, function(k) {
  names(normal_gene_nonzero_counts[normal_gene_nonzero_counts == k])[1]
})

random_genes

## Plot of slelecting min.cell based on normal dataset

plot_list <- list()
for (gene in random_genes) {
  expr_normal <- as.numeric(Normal_Expression_Sparse[gene, ])
  expr_normal_scaled <- (expr_normal - min(expr_normal)) / (max(expr_normal) - min(expr_normal))

  df_normal <- data.frame(
    x = Normal_Info$y,
    y = Normal_Info$x,
    expression = expr_normal_scaled
  )

  p_test_normal <- ggplot(df_normal, aes(x = x, y = y, color = expression)) +
    geom_point(size = 1.5) +
    scale_color_gradient(low = "gray", high = "red") +
    scale_y_reverse() +
    labs(title = gene, x = NULL, y = NULL, color = "RE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
    coord_fixed()

  plot_list[[gene]] <- p_test_normal
}

combined_plot_test_normal <- wrap_plots(plot_list, nrow = 3, ncol = 3)
ggsave("/home/yingzhen/R/min_cell_test/Random6Gene_SpatialPlots_Normal.png", plot = combined_plot_test_normal, width = 12, height = 6, dpi = 300, bg = "white")


## Plot of slelecting min.cell based on AD dataset

plot_list <- list()
for (gene in random_genes) {
  expr_AD <- as.numeric(AD_Expression_Sparse[gene, ])
  expr_AD_scaled <- (expr_AD - min(expr_AD)) / (max(expr_AD) - min(expr_AD))

  df_AD <- data.frame(
    x = AD_Info$y,
    y = AD_Info$x,
    expression = expr_AD_scaled
  )

p_test_AD <- ggplot(df_AD, aes(x = x, y = y, color = expression)) +
  geom_point(size = 1.5) +
  scale_color_gradient(low = "gray", high = "red") +
  scale_y_reverse() +
  labs(title = gene, x = NULL, y = NULL, color = "RE") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  coord_fixed()

  plot_list[[gene]] <- p_test_AD
}

combined_plot_test_AD <- wrap_plots(plot_list, nrow = 3, ncol = 3)
ggsave("/home/yingzhen/R/min_cell_test/Random6Gene_SpatialPlots_AD.png", plot = combined_plot_test_AD, width = 12, height = 6, dpi = 300, bg = "white")


## After comparing two plots, when cell counts >= 20, almost all gene expression are significant differenct between normal and AD
## Next, we further test which one is better of the range (10 - 20)
## Based on the two plots, genes expressed in more than 11 spots are significant differenct between normal and AD

target_counts <- c(10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
random_genes <- sapply(target_counts, function(k) {
  names(normal_gene_nonzero_counts[normal_gene_nonzero_counts == k])[1]
})

random_genes

## Plot of slelecting min.cell based on normal dataset next

plot_list <- list()
for (gene in random_genes) {
  expr_normal <- as.numeric(Normal_Expression_Sparse[gene, ])
  expr_normal_scaled <- (expr_normal - min(expr_normal)) / (max(expr_normal) - min(expr_normal))

  df_normal <- data.frame(
    x = Normal_Info$y,
    y = Normal_Info$x,
    expression = expr_normal_scaled
  )

  p_test_normal <- ggplot(df_normal, aes(x = x, y = y, color = expression)) +
    geom_point(size = 1.5) +
    scale_color_gradient(low = "gray", high = "red") +
    scale_y_reverse() +
    labs(
      title = gene,
      x = NULL, y = NULL, color = "RE"
    ) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
    coord_fixed()

  plot_list[[gene]] <- p_test_normal
}

combined_plot_test_normal_10_20 <- wrap_plots(plot_list, nrow = 3, ncol = 4)
ggsave("/home/yingzhen/R/min_cell_test/Random6Gene_SpatialPlots_Normal_10_20.png", plot = combined_plot_test_normal_10_20, width = 12, height = 6, dpi = 300, bg = "white")


## Plot of slelecting min.cell based on AD dataset next

plot_list <- list()
for (gene in random_genes) {
  expr_AD <- as.numeric(AD_Expression_Sparse[gene, ])
  expr_AD_scaled <- (expr_AD - min(expr_AD)) / (max(expr_AD) - min(expr_AD))

  df_AD <- data.frame(
    x = AD_Info$y,
    y = AD_Info$x,
    expression = expr_AD_scaled
  )

  p_test_AD <- ggplot(df_AD, aes(x = x, y = y, color = expression)) +
    geom_point(size = 1.5) +
    scale_color_gradient(low = "gray", high = "red") +
    scale_y_reverse() +
    labs(
      title = gene,
      x = NULL, y = NULL, color = "RE"
    ) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
    coord_fixed()

  plot_list[[gene]] <- p_test_AD
}

combined_plot_test_AD_10_20 <- wrap_plots(plot_list, nrow = 3, ncol = 4)
ggsave("/home/yingzhen/R/min_cell_test/Random6Gene_SpatialPlots_AD_10_20.png", plot = combined_plot_test_AD_10_20, width = 12, height = 6, dpi = 300, bg = "white")



## Initialize the Seurat object with non-normalized normal data
normal_expression <- CreateSeuratObject(counts = Normal_Expression_Sparse, min.cells = 11, names.delim = "-", , project = "MouseBrain_Normal")
normal_expression # 16279 unique features

## Violin plot normal

normal_expression[["percent.mt"]] <- PercentageFeatureSet(normal_expression, pattern = "^mt-") # The column sum of the matrix present in the counts slot for features belonging to the set 
                                                                                               # divided by the column sum for all features times 100.

vln_normal <- VlnPlot(normal_expression,
               features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
               ncol = 3)
ggsave("/home/yingzhen/R/min_cell_test/VlnPlot_Normal.png", plot = vln_normal, width = 10, height = 4, dpi = 300, bg = "white")

## Scatter plots normal

Scatter_normal_1 <- FeatureScatter(normal_expression, feature1 = "nCount_RNA", feature2 = "percent.mt")
Scatter_normal_2 <- FeatureScatter(normal_expression, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
combined_scatter_normal <- Scatter_normal_1 + Scatter_normal_2
ggsave("/home/yingzhen/R/min_cell_test/Combined_Scatter_Normal.png", plot = combined_scatter_normal, width = 12, height = 5, dpi = 300, bg = "white")

## Normalized normal data and feature selection
summary(normal_count_per_gene) # median = 12 and mean = 1463, use median = 12 as scale.factor due to robust to outliers
normal_expression <- NormalizeData(normal_expression, normalization.method = "LogNormalize", scale.factor = 12)
normal_expression <- FindVariableFeatures(normal_expression, selection.method = "vst", nfeatures = 1630) # First, fits a line to the relationship of log(variance) and log(mean) using local polynomial regression (loess) 
                                                                                                         # Then standardizes the feature values using the observed mean and expected variance 
                                                                                                         # Feature variance is then calculated on the standardized values after clipping to a maximum (default is 'auto' which sets this value to the square root of the number of cells)
                                                                                                         # since there are total 16279 features, we select 1630 unique genes per dataset (nfeatures = 1630)

top10_normal <- head(VariableFeatures(normal_expression), 10) # Based on the feature plot, there are approximately 50 genes with significant variable counts
Feature_normal_1 <- VariableFeaturePlot(normal_expression) + scale_x_log10() + coord_cartesian(clip = "off") # Red points are top 1800 highly variable genes (HVGs)
Feature_normal_2 <- LabelPoints(plot = Feature_normal_1, points = top10_normal, repel = TRUE, max.overlaps = Inf)  # Select 10 the most HVGs form 1800 HVGs, just for display                                                                                                             
combined_feature_normal <- Feature_normal_1 + Feature_normal_2
ggsave("/home/yingzhen/R/min_cell_test/Combined_feature_Normal.png", plot = combined_feature_normal,
       width = 12, height = 5, dpi = 300, bg = "white")


## Final reduction (Steps that convert the result from above to the original count matrix and coordinates Info)

### Based on the VlnPlot, I plan to filter cells that have unique genes detected over 6500 or less than 1000 
### filter cells that have total number of UMIs (read counts) detected over 32000 or less than 1000
### filter cells that have >40% mitochondrial counts

genes_to_keep_normal <- rownames(normal_expression)

nCount_RNA_normal <- Matrix::colSums(Normal_Expression_Sparse)
nFeature_RNA_normal <- Matrix::colSums(Normal_Expression_Sparse > 0)
mt_genes_normal <- grep("^mt-", rownames(Normal_Expression_Sparse), value = TRUE)
mt_counts_normal <- Matrix::colSums(Normal_Expression_Sparse[mt_genes_normal, , drop = FALSE])
percent.mt.normal <- (mt_counts_normal / nCount_RNA_normal) * 100

cells_to_keep_normal <- which(
  nFeature_RNA_normal > 1000 & nFeature_RNA_normal < 6500 &
  nCount_RNA_normal > 1000 & nCount_RNA_normal < 32000 &
  percent.mt.normal < 40
)

Filtered_Normal_Expression_Sparse <- Normal_Expression_Sparse[genes_to_keep_normal, cells_to_keep_normal] # Filter Matrix
filtered_cells_normal <- colnames(Filtered_Normal_Expression_Sparse)
Filtered_Normal_Info <- Normal_Info[filtered_cells_normal, ] # Filter Info
dim(Filtered_Normal_Info) # 3455 * 2, 86 spots are removed
dim(Filtered_Normal_Expression_Sparse)# 16279 * 3455

## Apply binning algorithm to the filtered normal dataset

bin_size <- 250
Filtered_Normal_Info$normal_bin_id <- with(Filtered_Normal_Info, paste0(floor(x/bin_size), "_", floor(y/bin_size)))

normal_spot_ids <- rownames(Filtered_Normal_Info)
normal_bin_ids  <- Filtered_Normal_Info$normal_bin_id
normal_bin_factor <- factor(normal_bin_ids)
normal_n_bins <- nlevels(normal_bin_factor)

normal_design <- sparseMatrix(i = seq_along(normal_spot_ids),  
                              j = as.integer(normal_bin_factor), 
                              x = 1,  
                              dims = c(length(normal_spot_ids), normal_n_bins),  
                              dimnames = list(normal_spot_ids, levels(normal_bin_factor))) 

normal_expr_matrix <- Filtered_Normal_Expression_Sparse 
normal_binned_expr_matrix <- normal_expr_matrix %*% normal_design 

normal_spots_per_bin <- Matrix::colSums(normal_design)
normal_binned_expr_matrix <- normal_binned_expr_matrix / rep(normal_spots_per_bin, each = nrow(normal_binned_expr_matrix)) 

normal_binned_coords <- Filtered_Normal_Info %>%
  group_by(normal_bin_id) %>% 
  summarise(x = mean(x), y = mean(y), .groups = "drop") %>%  
  tibble::column_to_rownames("normal_bin_id")  

dim(normal_binned_expr_matrix)
dim(normal_binned_coords)        

write.csv(normal_binned_coords,
          file = "/home/yingzhen/R/min_cell_test/normal_binned_coords.csv",
          row.names = TRUE)
write.csv(normal_binned_expr_matrix,
          file = "/home/yingzhen/R/min_cell_test/normal_binned_expr_matrix.csv",
          row.names = TRUE)


## Initialize the Seurat object with non-normalized AD data
AD_expression <- CreateSeuratObject(counts = AD_Expression_Sparse, min.cells = 11, names.delim = "-", , project = "MouseBrain_AD")
AD_expression # 17116 unique features

## Violin plot AD

AD_expression[["percent.mt"]] <- PercentageFeatureSet(AD_expression, pattern = "^mt-")

vln_AD <- VlnPlot(AD_expression,
               features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
               ncol = 3)
ggsave("/home/yingzhen/R/min_cell_test/VlnPlot_AD.png", plot = vln_AD, width = 10, height = 4, dpi = 300, bg = "white")

## Scatter plots AD

Scatter_AD_1 <- FeatureScatter(AD_expression, feature1 = "nCount_RNA", feature2 = "percent.mt")
Scatter_AD_2 <- FeatureScatter(AD_expression, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
combined_scatter_AD <- Scatter_AD_1 + Scatter_AD_2
ggsave("/home/yingzhen/R/min_cell_test/Combined_Scatter_AD.png", plot = combined_scatter_AD, width = 12, height = 5, dpi = 300, bg = "white")

## Normalized AD data and feature selection
summary(AD_count_per_gene) # median = 20 and mean = 1928
AD_expression <- NormalizeData(AD_expression, normalization.method = "LogNormalize", scale.factor = 20)
AD_expression <- FindVariableFeatures(AD_expression, selection.method = "vst", nfeatures = 1710)
top10_AD <- head(VariableFeatures(AD_expression), 10)

Feature_AD_1 <- VariableFeaturePlot(AD_expression) + scale_x_log10() + coord_cartesian(clip = "off")

Feature_AD_2 <- LabelPoints(plot = Feature_AD_1, points = top10_AD, repel = TRUE, max.overlaps = Inf)

combined_feature_AD <- Feature_AD_1 + Feature_AD_2
ggsave("/home/yingzhen/R/min_cell_test/Combined_feature_AD.png", plot = combined_feature_AD,
       width = 12, height = 5, dpi = 300, bg = "white")

## Final reduction

### Based on the VlnPlot, I plan to filter cells that have unique genes detected over 8000 or less than 500 
### filter cells that have total number of UMIs (read counts) detected over 42000 or less than 1000
### filter cells that have >35% mitochondrial counts

genes_to_keep_AD <- rownames(AD_expression)
nCount_RNA_AD <- Matrix::colSums(AD_Expression_Sparse)
nFeature_RNA_AD <- Matrix::colSums(AD_Expression_Sparse > 0)
mt_genes_AD <- grep("^mt-", rownames(AD_Expression_Sparse), value = TRUE)
mt_counts_AD <- Matrix::colSums(AD_Expression_Sparse[mt_genes_AD, , drop = FALSE])
percent.mt.AD <- (mt_counts_AD / nCount_RNA_AD) * 100

cells_to_keep_AD <- which(
  nFeature_RNA_AD > 500 & nFeature_RNA_AD < 8000 &
  nCount_RNA_AD > 1000 & nCount_RNA_AD < 42000 &
  percent.mt.AD < 35
)

Filtered_AD_Expression_Sparse <- AD_Expression_Sparse[genes_to_keep_AD, cells_to_keep_AD] # Filter Matrix
filtered_cells_AD <- colnames(Filtered_AD_Expression_Sparse)
Filtered_AD_Info <- AD_Info[filtered_cells_AD, ] # Filter Info
dim(Filtered_AD_Info) # 3441*2, 35 spots are removed
dim(Filtered_AD_Expression_Sparse)


## Apply the binning algorithm to AD dataset

Filtered_AD_Info$ad_bin_id <- with(Filtered_AD_Info, paste0(floor(x / bin_size), "_", floor(y / bin_size)))
ad_spot_ids <- rownames(Filtered_AD_Info)
ad_bin_ids <- Filtered_AD_Info$ad_bin_id
ad_bin_factor <- factor(ad_bin_ids)
ad_n_bins <- nlevels(ad_bin_factor)

ad_design <- sparseMatrix(
  i = seq_along(ad_spot_ids),
  j = as.integer(ad_bin_factor),
  x = 1,
  dims = c(length(ad_spot_ids), ad_n_bins),
  dimnames = list(ad_spot_ids, levels(ad_bin_factor))
)

ad_expr_matrix <- Filtered_AD_Expression_Sparse

ad_binned_expr_matrix <- ad_expr_matrix %*% ad_design
ad_spots_per_bin <- Matrix::colSums(ad_design)
ad_binned_expr_matrix <- ad_binned_expr_matrix / rep(ad_spots_per_bin, each = nrow(ad_binned_expr_matrix))

ad_binned_coords <- Filtered_AD_Info %>%
  group_by(ad_bin_id) %>%
  summarise(x = mean(x), y = mean(y), .groups = "drop") %>%
  tibble::column_to_rownames("ad_bin_id")

dim(ad_binned_expr_matrix)
dim(ad_binned_coords)

write.csv(ad_binned_coords,
          file = "/home/yingzhen/R/min_cell_test/ad_binned_coords.csv",
          row.names = TRUE)
write.csv(ad_binned_expr_matrix,
          file = "/home/yingzhen/R/min_cell_test/ad_binned_expr_matrix.csv",
          row.names = TRUE)


# Normalization and Test

Normal_Normalized <- SPADE_norm(readcounts = as.matrix(normal_binned_expr_matrix), info = normal_binned_coords)
AD_Normalized <- SPADE_norm(readcounts = as.matrix(ad_binned_expr_matrix), info = ad_binned_coords) 

LRT <- SPADE_DE(Normal_Normalized, AD_Normalized, normal_binned_coords, ad_binned_coords)

write.csv(LRT, file = "/home/yingzhen/R/min_cell_test/LRT_results.csv", row.names = TRUE)



# Between Group evaluation

LRT$delta_theta <- abs(LRT$theta_Gau1 - LRT$theta_Gau2)
LRT$log10P <- -log10(LRT$Adjust.Pvalue)
LRT_sig <- subset(LRT, Adjust.Pvalue < 0.05)

p_Nor_AD <- ggplot(LRT, aes(x = log10P, y = delta_theta)) +
  geom_point(alpha = 0.5, color = "purple", size = 1) +
  geom_point(data = LRT_sig, aes(x = log10P, y = delta_theta), color = "blue", size = 2) +
  geom_text(data = LRT_sig, aes(label = geneid), vjust = -0.8, size = 3, fontface = "italic", color = "black") +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "red", linewidth = 0.4) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "red", linewidth = 0.4) +
  labs(
    x = expression(-log[10]("Adjusted P-value")),
    y = expression("|" * theta[1] - theta[2] * "|" ~ "(Spatial Difference)"),
    title = "SPADE: Spatial Fold-Change vs Adjusted P-value"
  ) +
  theme_minimal(base_size = 12)

ggsave("/home/yingzhen/R/min_cell_test/Between_Group_Evaluation.png", plot = p_Nor_AD, width = 10, height = 10, dpi = 300, bg = "white")


# Representative SV genes identified by SPADE with P-values from SPADE

top_2_genes <- LRT$geneid[order(LRT$Adjust.Pvalue)][1:2]
gene1 <- top_2_genes[1]
gene2 <- top_2_genes[2]

SV_gene_detection <- function(gene_id, Normal_Normalized, AD_Normalized, normal_binned_coords, ad_binned_coords, test) {
  RE_Normal <- Normal_Normalized[gene_id, ]
  RE_AD <- AD_Normalized[gene_id, ]

  RE_Normal <- (RE_Normal - min(RE_Normal)) / (max(RE_Normal) - min(RE_Normal)) # Relative expression that has [0, 1] scale within normal group
  RE_AD <- (RE_AD - min(RE_AD)) / (max(RE_AD) - min(RE_AD)) # Relative expression that has [0, 1] scale within AD group

  df_N <- data.frame(x = normal_binned_coords$y, y = normal_binned_coords$x, RE = RE_Normal, Group = "Normal")
  df_A <- data.frame(x = ad_binned_coords$y, y = ad_binned_coords$x, RE = RE_AD, Group = "AD")
  df <- rbind(df_N, df_A)

  ADJ_p_value <- signif(test$Adjust.Pvalue[test$geneid == gene_id], 2) # Rounds the extracted adjusted p-value to 2 significant digits
  title <- bquote(italic(.(gene_id)) ~ "(Adjusted P = " ~ .(ADJ_p_value) ~ ")")

Representative_SV_gene <- ggplot(df, aes(x = x, y = y, color = RE)) +
  geom_point(size = 1) +
  scale_color_gradient(low = "gray", high = "yellow", limits = c(0, 1)) +
  scale_y_reverse() +
  theme_void() +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5)
  ) +
  ggtitle(title)

  return(Representative_SV_gene)
}

Representative_SV_gene1 <- SV_gene_detection(gene1, Normal_Normalized, AD_Normalized, normal_binned_coords, ad_binned_coords, LRT)
Representative_SV_gene2 <- SV_gene_detection(gene2, Normal_Normalized, AD_Normalized, normal_binned_coords, ad_binned_coords, LRT)

combined <- Representative_SV_gene1 + Representative_SV_gene2 + plot_layout(ncol = 2, guides = "collect") &
  theme(legend.position = "right")

ggsave("/home/yingzhen/R/min_cell_test/Representative_SV_gene.png", plot = combined, width = 10, height = 4, dpi = 300, bg = "white")



# Spatial patterns for real-data based simulation of two groups

top_genes <- LRT$geneid[order(LRT$Adjust.Pvalue)][1:3]

plot_RE <- function(gene_id, expression_matrix, info_df, group_label) {
  RE <- as.numeric(expression_matrix[gene_id, ])
  RE <- (RE - min(RE)) / (max(RE) - min(RE))
  RE_color <- ifelse(RE < 0.5, 0, RE)

  df <- data.frame(
    x = info_df$y,
    y = info_df$x,
    RE = RE_color,
    Gene = gene_id,
    Group = group_label
  )

  ggplot(df, aes(x = x, y = y, color = RE)) +
    geom_point(size = 1.2) +
    scale_color_gradientn(colors = c("gray", "blue"), limits = c(0, 1), name = "RE") +
    scale_y_reverse() +
    theme_void() +
    coord_fixed() +
    facet_wrap(~ Group, nrow = 1) +
    theme(
      strip.text = element_text(face = "bold", size = 10),
      legend.position = "right"
    ) +
    ggtitle(gene_id)
}

plot_list <- list()
for (gene in top_genes) {
  p_normal <- plot_RE(gene, Normal_Normalized, normal_binned_coords, "Normal Group")
  p_ad     <- plot_RE(gene, AD_Normalized, ad_binned_coords, "AD Group")
  plot_list[[gene]] <- p_normal / p_ad
}

combined_sim_two <- plot_list[[1]] | plot_list[[2]] | plot_list[[3]] +
  plot_layout(guides = "collect") &
  theme(legend.position = "right")

ggsave("/home/yingzhen/R/min_cell_test/Spatial patterns for simulation data of two groups.png", plot = combined_sim_two, width = 8, height = 6, dpi = 300, bg = "white")



# Spatial patterns for real data of two groups for a gene

target_gene <- LRT$geneid[order(LRT$Adjust.Pvalue)][1] #can be anyone of interest, Ttr is of interest
target_Nor <- Normal_Normalized[target_gene, ]
target_AD <- AD_Normalized[target_gene, ]

Normal_hotspot <- data.frame(x = normal_binned_coords$y, y = normal_binned_coords$x,
                              RE_raw = target_Nor,
                              Group = "Normal", Pattern = "Hotspot")
Normal_streak <- Normal_hotspot; Normal_streak$Pattern <- "Streak"

AD_hotspot <- data.frame(x = ad_binned_coords$y, y = ad_binned_coords$x,
                         RE_raw = target_AD,
                         Group = "AD", Pattern = "Hotspot")
AD_streak <- AD_hotspot; AD_streak$Pattern <- "Streak"

plot_df <- bind_rows(Normal_hotspot, Normal_streak, AD_hotspot, AD_streak)

plot_df <- plot_df %>%
  group_by(Group, Pattern) %>%
  mutate(RE = (RE_raw - min(RE_raw)) / (max(RE_raw) - min(RE_raw))) %>%
  ungroup()

plot_df$Group <- factor(plot_df$Group, levels = c("Normal", "AD"))
plot_df$Pattern <- factor(plot_df$Pattern, levels = c("Hotspot", "Streak"))

Spatial_patterns <- ggplot(plot_df, aes(x = x, y = y, color = RE)) +
  geom_point(size = 1.5) +
  scale_color_gradient(low = "grey", high = "blue", name = "RE") +
  scale_y_reverse() +
  coord_fixed() +
  facet_grid(Group ~ Pattern, labeller = label_both) +
  theme_void() +
  theme(
    strip.text = element_text(size = 12, face = "bold"),
    legend.position = "right"
  )

ggsave("/home/yingzhen/R/min_cell_test/Spatial_patterns_two_groups_one_gene.png", plot = Spatial_patterns, width = 7, height = 6, dpi = 300, bg = "white")

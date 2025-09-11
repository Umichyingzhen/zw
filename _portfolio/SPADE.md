---
title: "Research on gene expression in the mouse brain using SPADE for Alzheimer’s disease"
excerpt: " Investigated differential gene expression in Alzheimer’s disease mouse brains using spatial transcriptomics. By applying SPADE and Seurat, we identify spatially variable genes, compare detection sensitivity, and reveal complementary insights into disease-associated spatial expression patterns."
collection: portfolio
date: 2025-07-05
---

This study applies spatial transcriptomics to analyze gene expression in Alzheimer’s disease mouse brains. SPADE and Seurat are used to identify spatially variable genes and to evaluate their relative sensitivity. The analysis highlights both overlapping and method-specific detections, showing that the two approaches provide complementary perspectives on spatial gene expression relevant to Alzheimer’s pathology.

---

### 🧠 Project Summary

- **Dataset**: The dataset contains spatial transcriptomics profiles from Alzheimer’s disease and normal mouse brain sections, with 3541 spatial spots and 32285 gene expression counts measured.
- **Key Methods**: SPADE for normalization and spatially variable gene detection; Seurat for preprocessing, clustering, and differential expression; BASS for multi-sample spatial domain alignment; visualization of spatial gene expression patterns using ggplot2; Capping algorithm for reducing computational burden.  
- **Main Finding**: SPADE showed higher sensitivity for detecting localized spatial expression differences, while the Seurat+BASS framework captured broader domain-specific gene expression. About 37% of significant genes differed between methods, reflecting their complementary strengths and methodological differences.

---

### 🧾 Dataset Results Overview

[`Binned Alzheimer’s disease coordinate information`](/files/ad_binned_coords.csv)

[`Binned normal brain tissue coordinate information`](/files/normal_binned_coords.csv)

[`Alzheimer’s disease and normal brain tissue gene expression information`](/files/binned_expr_matrix.zip)

[`Spatial variance (SV) genes detection results (Likelihood Ratio Tests)`](/files/LRT_results.csv)

[`Significant SV genes only detected by SPADE (Likelihood Ratio Tests)`](/files/Sort_Genes_SPADE.csv)

[`Significant SV genes only detected by Clustered Differential Expression (DE)`](/files/Sort_Genes_Domian.csv)

---

### 📈 Data Visualization Results

<img src="/files/Spatial_Domain_Facet.png" alt="Comparison of Spatial Domain Distributions in AD versus Normal mouse brain" style="width:100%;"/>
  
> - Domain 4 and Domain 7 expanded in AD compared to WT (p < 0.05)  
> - Domain 3 and Domain 8 showed shrinkage or relocation (p < 0.05)  
> - Spatial reorganization indicates potential degeneration in AD pathology

<img src="/files/Lhfp.png" alt="Conflict gene expression Lhfp" style="width:100%;"/>
  
> - Domain 7 shows the lowest adjusted p-value in the DE analysis, highlighting significant differential expression  
> - Cluster-based methods detect *Lhfp* as significant, consistent with higher relative expression intensity in Domain 7  
> - Despite DE significance, *Lhfp* is not classified as an SV gene by SAPDE, likely due to similar relative expression intensity across multiple regions

<img src="/files/Tuba1c.png" alt="Conflict gene expression Tuba1c" style="width:100%;"/>
  
> - Tuba1c shows generally low expression across both normal and AD tissues  
> - A localized region in domain 3 of AD exhibits higher relative expression, detected as significant by SPADE  
> - Cluster-based analysis did not classify Tuba1c as significant due to overall low and uniform expression  

<img src="/files/Domain_Size_vs_R.png" alt="Minimum domain size versus R that showing the threshold of 3% rule for spatial domain detection" style="width:100%;" />

> - The maximum number of spatial domains is approximately 33, based on the minimum 3% cells per domain threshold  
> - R values between 5 and 33 were evaluated, ensuring heterogeneity in gene expression is retained while avoiding noise from small domains  
> - Domain size of 8 is the largest one that satisfies the baseline requirement with greater than 3 percent of cells per domain  

### 📋 Table Results

| Method           | Total Genes | Significant Genes | Percent (%) |
|------------------|-------------|-------------------|-------------|
| Seurat           | 32282       | 11812             | 36.59       |
| SPADE (Capping)  | 16279       | 13085             | 80.38       |

> - SPADE identified a higher number and proportion of significant genes compared to Seurat, despite processing fewer total input genes  
> - The increased detection rate from SPADE suggests greater sensitivity to spatially varying signals in raw gene expression data  
> - Combining Seurat (for pre-filtering) and SPADE (for sensitivity) is preferred for robust evaluation of spatial data significance

| Overlapping | Conflict | Only in Seurat | Only in SPADE |
|-------------|----------|----------------|---------------|
| 9639        | 5619     | 2173           | 3446          |

> - 9,639 genes were identified as significant by both Seurat and SPADE  
> - 5,619 genes show disagreement, with 2,173 detected only by Seurat and 3,446 only by SPADE  
> - Nearly 37% of significant genes fall into the conflict category, highlighting methodological differences between Seurat and SPADE

---

### 📎 Full Report

👉 [Download Full Report (PDF)](/files/Application of SPADE and Seurat to Between Group Expression.pdf)

---
 

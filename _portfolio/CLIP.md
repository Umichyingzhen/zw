---
title: "Research on Pneumonia Patient Condition Classification Using Diffusion Models and CLIP"
excerpt: " Explored large model techniques for classifying pediatric chest X-ray images into normal, bacterial pneumonia, and viral pneumonia categories. Using 5,856 radiographs and synthetic images generated via LoRA fine-tuning of a Stable Diffusion model, we addressed class imbalance and improved training accuracy. A fine-tuned CLIP model further demonstrated the potential of multimodal approaches for radiologic diagnosis of pneumonia."
collection: portfolio
date: 2024-12-17
---

---

### 🧠 Project Summary

- **Dataset**:  
  - 5,856 pediatric chest X-ray images covering normal, bacterial pneumonia, and viral pneumonia  
  - Synthetic images generated via LoRA fine-tuning of Stable Diffusion to address class imbalance  

- **Key Methods**:  
  - Applied large language model–based multimodal classification using CLIP 
  - LoRA fine-tuning of Stable Diffusion for synthetic data augmentation
  - Fine-tuned CLIP model to evaluate classification across three pneumonia categories

- **Main Achievements**:  
  - Improved training accuracy from **48.94% → 50.51%** with synthetic data augmentation  
  - Demonstrated feasibility of combining diffusion models and CLIP for radiologic diagnosis  
  - Identified limitations in generalization with test accuracy at **37.50%**, suggesting need for further optimization

---

### 🧾 Model Implementation

- **Diffusion Model**:  
  - Based on non-equilibrium thermodynamics, using forward and reverse diffusion to transform noisy data into realistic samples  
  - Implemented with Stable Diffusion v2 using 865M U-Net as generator and OpenCLIP ViT-H/14 as encoder for 768×768px outputs  
  - Fine-tuned with LoRA (LoRA_A and LoRA_B), reducing trainable parameters to ~1% and generating 1,000 synthetic images to address class imbalance

- **Contrastive Language-Image Pre-training(CLIP)**:  
  - Pre-trained by OpenAI in 2021 on large-scale image-text pairs, enabling models to match images with natural language descriptions  
  - Used ViT-L/14 Transformer as image encoder and masked self-attention Transformer as text encoder, fine-tuned with LoRA for medical X-ray data  
  - Fine-tuned model classified chest X-rays into three categories (normal, bacterial pneumonia, viral pneumonia) using prompt-based text inputs

### 🧾 Results

<img src="/files/CLIP_Results.png" style="width:100%;"/>


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
| Clustered DE     | 32282       | 11812             | 36.59       |
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

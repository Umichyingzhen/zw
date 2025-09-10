---
title: "Research on gene expression in the mouse brain using SPADE for Alzheimer’s disease"
excerpt: " Investigated differential gene expression in Alzheimer’s disease mouse brains using spatial transcriptomics. By applying SPADE and Seurat, we identify spatially variable genes, compare detection sensitivity, and reveal complementary insights into disease-associated spatial expression patterns."
collection: portfolio
date: 2025-07-05
---

This study applies spatial transcriptomics to analyze gene expression in Alzheimer’s disease mouse brains. SPADE and Seurat are used to identify spatially variable genes and to evaluate their relative sensitivity. The analysis highlights both overlapping and method-specific detections, showing that the two approaches provide complementary perspectives on spatial gene expression relevant to Alzheimer’s pathology.

---

### 🧠 Project Summary

- **Team Members**: Sara Elfring, Jingyi Chen, Shuoyuan Gao, Alexandra Schmalzel, Haowen Wu  
- **Dataset**: NHANES (2009–2012)  
- **Key Methods**: Linear regression, log transformation, interaction terms, model diagnostics  
- **Main Finding**: Higher alcohol consumption is significantly associated with elevated systolic blood pressure, especially among younger adults.

---

### 📊 Final Model Output

<img src="/images/hypertension-final.jpg" alt="Final Model Output and Residual Histogram" style="width:100%;"/>

> **Adjusted R²**: 0.185  
> **Notable Results**:
> - 12+ drinks per year → +0.060 log-units in SBP (p = 0.001)
> - Each drink per day → +0.003 log-units (p < 0.001)
> - Negative interaction with age

---

### 🔁 Baseline Model Comparison

<img src="/images/hypertension-baseline.jpg" alt="Baseline Model and Residuals" style="width:100%;"/>

> **Adjusted R²**: 0.1857  
> - No log transformation used  
> - 12+ drinks per year was not statistically significant (p = 0.864)

---

### 📎 Full Report

👉 [Download Full Report (PDF)](/files/Application of SPADE and Seurat to Between Group Expression.pdf)

---
 

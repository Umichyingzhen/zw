---
title: "利用 SPADE 分析阿尔茨海默症小鼠脑基因表达的研究"
excerpt: "利用空间转录组学方法研究阿尔茨海默症小鼠脑中的差异基因表达。通过应用 SPADE 和 Seurat，我们识别了空间可变基因，比较了检测灵敏度，并揭示了疾病相关空间表达模式的互补性见解。"
collection: portfolio
date: 2025-07-05
---

这是我与 Cong Ma 教授合作开展的研究项目。她的联系方式是 congma@umich.edu，任职于密歇根大学医学院计算医学与生物信息学系。

---

### 🧠 项目总结

- **数据集**: 数据集包含来自阿尔茨海默症和正常小鼠脑切片的空间转录组学数据，共 3541 个空间点，测量了 32285 个基因表达计数。  
- **关键方法**: 使用 SPADE 进行归一化和空间可变基因检测；Seurat 用于预处理、聚类和差异表达分析；BASS 用于多样本空间域对齐；利用 ggplot2 可视化空间基因表达模式；使用 Capping 算法减少计算负担。  
- **主要发现**: SPADE 在检测局部空间表达差异方面表现出更高的灵敏度，而 Seurat+BASS 框架捕捉了更广泛的领域特异性基因表达。两种方法的显著基因有约 37% 不一致，反映了它们互补的优势和方法学差异。

---

### 🧾 数据集结果概览

[`阿尔茨海默症分箱坐标信息`](/files/ad_binned_coords.csv)

[`正常脑组织分箱坐标信息`](/files/normal_binned_coords.csv)

[`阿尔茨海默症与正常脑组织基因表达信息`](/files/binned_expr_matrix.zip)

[`空间方差 (SV) 基因检测结果（似然比检验）》`](/files/LRT_results.csv)

[`仅由 SPADE 检测到的显著 SV 基因（似然比检验）》`](/files/Sort_Genes_SPADE.csv)

[`仅由聚类差异表达 (DE) 检测到的显著 SV 基因`](/files/Sort_Genes_Domian.csv)

---

### 📈 数据可视化结果

<img src="/files/Spatial_Domain_Facet.png" alt="Comparison of Spatial Domain Distributions in AD versus Normal mouse brain" style="width:100%;"/>
  
> - 与 WT 相比，AD 中的第 4 和第 7 域扩张（p < 0.05）  
> - 第 3 和第 8 域出现缩小或重新定位（p < 0.05）  
> - 空间重组表明 AD 病理中可能存在退化过程  

<img src="/files/Lhfp.png" alt="Conflict gene expression Lhfp" style="width:100%;"/>
  
> - 在差异表达分析中，第 7 域表现出最低的校正 p 值，突出了显著的差异表达  
> - 基于聚类的方法检测到 *Lhfp* 为显著基因，与其在第 7 域较高的相对表达强度一致  
> - 尽管差异表达显著，*Lhfp* 并未被 SPADE 分类为空间可变基因，可能是由于其在多个区域间具有相似的相对表达强度  

<img src="/files/Tuba1c.png" alt="Conflict gene expression Tuba1c" style="width:100%;"/>
  
> - Tuba1c 在正常与 AD 组织中的整体表达均较低  
> - 在 AD 的第 3 域有一个局部区域表现出较高的相对表达，被 SPADE 检测为显著  
> - 由于整体表达水平低且均一，基于聚类的分析未将 Tuba1c 分类为显著基因  

<img src="/files/Domain_Size_vs_R.png" alt="Minimum domain size versus R that showing the threshold of 3% rule for spatial domain detection" style="width:100%;" />

> - 基于每个领域至少占 3% 细胞的阈值，空间域的最大数目约为 33  
> - 评估了 R 值在 5 到 33 之间的情况，以确保保留基因表达的异质性，同时避免小领域带来的噪声  
> - 域大小为 8 时是满足基本要求的最大值，超过 3% 的细胞归入该域  

### 📋 表格结果

| Method           | Total Genes | Significant Genes | Percent (%) |
|------------------|-------------|-------------------|-------------|
| Clustered DE     | 32282       | 11812             | 36.59       |
| SPADE (Capping)  | 16279       | 13085             | 80.38       |

> - 与 Seurat 相比，SPADE 在处理较少输入基因的情况下，识别了更多且比例更高的显著基因  
> - SPADE 检测率的提升表明其对原始基因表达数据中空间变异信号更为敏感  
> - 将 Seurat（用于预过滤）与 SPADE（用于灵敏检测）结合，是稳健评估空间数据显著性的优选方法  

| Overlapping | Conflict | Only in Seurat | Only in SPADE |
|-------------|----------|----------------|---------------|
| 9639        | 5619     | 2173           | 3446          |

> - Seurat 和 SPADE 同时识别出的显著基因为 9639 个  
> - 有 5619 个基因结果不一致，其中 2173 仅被 Seurat 检测到，3446 仅被 SPADE 检测到  
> - 约 37% 的显著基因属于冲突类别，凸显了 Seurat 与 SPADE 方法学上的差异  

### 📎 Full Report

👉 [下载研究报告 (PDF)](/files/Application of SPADE and Seurat to Between Group Expression.pdf)

---
 

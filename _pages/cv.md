---
layout: archive
title:
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

Education
======
**University of Michigan – Ann Arbor**  
*Master of Science in Biostatistics | GPA: 3.860/4.0*

**Colorado State University - Fort Collins**  
*Master of Applied Statistics in Statistical Science | GPA: 3.904/4.0*

**Yanbian University**  
*Bachelor of Science in Statistics | AVG: 81.39/100*

Relevant Coursework
======
* Algebra & Geometry
* Probability & Distribution Theory
* Ordinary Differential Equation
* Stochastic Process
* Multivariate Statistical Analysis
* Machine Learning
* Data Visualization Methods
* Applied Bayesian Statistics
* Quantitative Reasoning
* Computing with Big Data
* Analysis of Categorical Data
* Biostatistics Inference
* Clinical Trials
* Theory and Application of Longitudinal Analysis

Technical Skills
======
**Languages:** English (Advanced), Mandarin (Native)

**Software:** Excel (Advanced), Python (Advanced), R (Advanced), SQL (Intermediate), C++ (Intermediate), Linux (Intermediate), Matlab (Intermediate)

Publications
======
  <ul>{% for post in site.publications reversed %}
    {% include archive-single-cv.html %}
  {% endfor %}</ul>
  
Work Expreience
======

**Graduate Research Assistant**  
_Department of Computational Medicine & Bioinformatics at University of Michigan_ — Ann Arbor, MI (May 2025 - July 2025)
- Conducted spatial transcriptomics analysis on normal vs. Alzheimer’s mouse brains using SPADE, identifying over 13,000 spatially variable genes with high sensitivity to local expression heterogeneity
- Performed clustering and domain detection with the BASS package and integrated Seurat-based differential expression analysis to compare spatial domain-specific vs. localized gene expression  
- Demonstrated that SPADE is good at detecting fine-scale localized differences, while Seurat capturing domain-level transcriptional changes, providing complementary insights into Alzheimer’s-related gene dysregulation
- Built reproducible workflows on Great Lakes HPC with R&Python environments, executing Slurm jobs for the 3000*30000 expression matrix through VS Code

**Graduate Research Assistant**  
_Department of Biostatistics at University of Michigan_ — Ann Arbor, MI (May 2025 - Present)
- Designed and implemented elliptical slice sampling algorithms in R for Bayesian parameter estimation, improving efficiency in posterior inference
- Developed and validated a Multivariate Bayesian Shrinkage Prior (Mt-MBSP) model supporting mixed-type outcomes (continuous, binary, count) with Gibbs sampling  
- Conducted extensive simulation studies comparing Bayesian CRD, Bayesian CRD with imputation, and OLS, evaluating predictive accuracy and convergence via Gelman-Rubin diagnostics
- Applied Bayesian modeling frameworks to real and simulated datasets, generating reproducible analyses and visualizations that supported model validation and interpretation

**Manager Assistant**  
_China Everbright Bank, Changchun Branch_ — Changchun, China (September 2019 - November 2019)
- Gathered and processed the monthly economic data of Jilin Province and the whole country since 2019 to understand the GDP drivers from the perspectives of fiscal policy and monetary policy
- Learned the business models and daily operations of commercial banks; recommended appropriate wealth management products to potential clients based on their risk tolerance and investment needs  
- Employed R to fit generalized and linear regression models for customer satisfaction and deposit analysis
  
Research Experience
======

**Research on Pneumonia Patient Condition Classification Using Diffusion Models and CLIP**  
_Department of Biostatistics at University of Michigan_ — Ann Arbor, MI (Nov 2024 - Dec 2024)
- Deployed the stable Diffusion model and utilized LoRA to fine-tune the model to make the model generate customized chest X-ray images
- Utilized the fine-tuned contrastive language-image pre-training (CLIP) model to achieve modest improvements in training accuracy and classify the test dataset  
- Publish the whole research on GitHub https://github.com/xxm12345666/biostat625-group2-project.git

**Research on Predictive Algorithms for Cardiovascular Disease**  
_Summer Research Seminar, Supervisor: R. Todd Ogden, Columbia University_ — Remote (May 2023 - July 2023)
- Utilized Principal Component Analysis (PCA) to identify relevant predictors and reduce dimensionality in complex datasets, implemented backward stepwise elimination to refine model features and prevent overfitting
- Developed random forest and logistic regression models to assess CHD risk factors and aid in early detection  
- Evaluated model performances based on confusion matrix and AUC-ROC curve values
- Validated that the random forest model outperformed other models in categorizing high-dimensional data

**Familial Influences on Radiation Effects in Mice**  
_NASA Human Research Program, Weil Lab, Colorado State University_ — Fort Collins, CO (May 2022 – August 2022)
- Designed and fitted a generalized linear mixed model for the analysis of the relationship among Modified Merriam-Focht classification and radiation groups
- Detected the difference in radiation effects between γ-rays and HZE nuclei using emmeans command  
- Achieved regression analysis for the odds of being vision impairing caused by gamma rays using R

**Application of Nonlinear Programming to Heat Conduction Model**  
_College of Science at Yanbian University_ — Yanji, China (August 2017 - October 2018)
- Established a nonlinear programming model to determine optimal thickness of the second layer of the high temperature working clothes given predictors like work hours and environmental temperature
- Obtained the function of temperature and material thickness based on Fourier heat law  
- Introduced the simulated annealing algorithm to enhance optimization accuracy, considering convection and radiation factors

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
  
Teaching
======
  <ul>{% for post in site.teaching reversed %}
    {% include archive-single-cv.html %}
  {% endfor %}</ul>
  
Service and leadership
======
* Currently signed in to 43 different slack teams

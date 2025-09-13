---
title: "Research on Bayesian Parameterization"
excerpt: "This ongoing study explores Bayesian CRD methods with elliptical slice sampling for mixed-type responses. Preliminary simulations suggest stable inference and promising predictive performance compared to OLS, with extensions to external information and shrinkage priors under development."
collection: portfolio
---
This is a research I am still conducting with Professor Nicholas Henderson. His contact information is nchender@umich.edu, Department of Biostatistics, School of Public Health, University of Michigan.
---

### 📊 Project Summary

- **Dataset**:  
  - Simulated datasets with continuous, binary, and count responses  
  - External covariates generated from Weibull models for integration studies  
  - Sample sizes considered: n = 50 and n = 100 across multiple settings  

- **Key Methods**:  
  - Developed Bayesian CRD framework with elliptical slice sampling for mixed-type responses  
  - Incorporated external information through rank-based discrepancy measures (Spearman, Kendall)  
  - Extended simulations with Bayesian Lasso and Ridge regression for comparison  

- **Progress & Preliminary Achievements**:

  - Demonstrated stable posterior inference and convergence diagnostics  
    ```
    ## Step 2: Gelman-Rubin PSRF (p = 2)
    ## beta1   1.248638   1.903013
    ## beta2   1.039516   1.096078
    ```
  
  - Achieved competitive mean-squared errors compared to OLS across multiple scenarios  
    ```
    Simulation 1 Results
    n    Method         Discrepancy   Mean-Squared Error
    50   Bayesian CRD   spearman      1.1516
    50   Least Squares  -             1.1584
    100  Bayesian CRD   spearman      1.1210
    100  Least Squares  -             1.1216
    ```

  - Showed flexibility in handling external information and shrinkage priors  
    ```
    Simulation 2 Results
    100  Bayesian CRD (impute)  kendall  1.6417
    50   Bayesian CRD (impute)  spearman 1.8688
    
    Simulation 3 (Bayesian Lasso) MSE:
    [1] 0.0021 0.1375 0.1523
    ```

  - Identified limitations in generalization under certain coefficient structures, suggesting further refinement  
    ```
    Simulation 5 Results
    50 bext_first_only   MSE = 1.1121
    100 bext_first_only  MSE = 1.0766
    50 bext_mixed        MSE = 1.1235
    100 bext_mixed       MSE = 1.0469
    ```
---

### 🧩 Model Implementation and Design

- **Bayesian CRD for Mixed-Type Responses**  
  - Multivariate regression with responses {continuous, binary, count}; covariates split into internal `Z` and external-driven features via predictive draws  
  - Latent Gaussian random effects `U` capture residual correlation; outcome-specific working weights handle different likelihoods  
  - Shrinkage prior on coefficients via local–global parameters `(zeta, nu, tau)`

- **Mt_MBSP (Gibbs) Sampler**  
  - **Binary**: Pólya–Gamma augmentation; update `W`, latent `Y*`, then coefficients `B`  
  - **Continuous**: Gaussian working model with `W=1`  
  - **Count**: Negative-binomial via Pólya–Gamma; updates dispersion `r_disp`  
  - Cycle updates: `U | ...` (Gaussian), `Σ | ...` (Inverse-Wishart), local scales `zeta` (GIG) and `nu` (Gamma)  
  - Generate predictive draws `Bpred_samples` (stored as `Y_t`) for downstream CRD

- **Elliptical Slice Sampler (CRD-impute)**  
  - **Parameter block**: `theta = [beta_Z, beta_B, log(sigma^2), log(kappa), log(lambda)]`  
  - Gaussian prior with diagonal covariance; bracketed angle sampling without step sizes  
  - Uses rolling `Bdraws` from `fit$Bpred_samples` (or imputed draws) to couple CRD with Mt_MBSP predictions

- **Discrepancy Measures**  
  - **Spearman**: rank-based `W` from normalized ranks  
  - **Kendall**: pairwise concordance/discordance construction in `ComputeWmatrix(...)` 

- **Baselines & Shrinkage Variants**  
  - **OLS** baseline for MSE comparison  
  - **Bayesian Lasso**: per-coordinate local scales `lambda_j^2`, Gibbs updates, posterior means for `beta`  
  - **Bayesian Ridge**: conjugate updates with closed-form posterior `(mu_n, V_n)` and Inverse-Gamma for `sigma^2`

- **Evaluation Protocols**  
  - **Prediction**: MSE on new data; binary tasks use ROC/AUC and PR/AUPRC  
  - **Convergence**: trace plots, ACF, cumulative means; Gelman–Rubin PSRF from split chains  
  - **Visualization**: posterior densities, beta-correlation heatmaps, error boxplots

- **Simulation Designs**  
  - **Sim 1**: Linear truth with `n = {50,100}`; CRD (with/without imputation) vs OLS  
  - **Sim 1b**: Sparse beta (only first coefficient nonzero) stress-tests shrinkage  
  - **Sim 2**: External Weibull model estimates `beta_E`; integrates ranks into CRD; analyzes `Dbar_i` regression on `Z`  
  - **Sim 3**: Bayesian Lasso comparison  
  - **Sim 4**: Bayesian Ridge (conjugate) comparison  
  - **Sim 5**: External beta scenarios (`bext_1`, `bext_2`, `bext_3x10`, `first_only`, `mixed`) to probe generalization

- **Default Settings & Libraries**  
  - Seeds (e.g., 970316) for reproducibility  
  - `Mt_MBSP`: `niter=500`, `burn=100`; **CRD-ESS**: `T=1000`; typical `kappa=1`, `sigma0_sq=3`, `sigma_kappa_sq=3`, `sigma_l_sq=1`; small \( \nu \) (e.g., 0.1); scenario-specific \( \eta \)  
  - R packages: `MASS`, `mvtnorm`, `GIGrvg`, `MCMCpack`, `BayesLogit`, `pROC`, `PRROC`, `caret`, `ggplot2`, `pheatmap`, `loo`


### 📑 Results

<img src="/files/p=3.png" style="width:100%;"/>

> - The fitted comparison for CRD-impute at p = 3 shows that posterior mean estimates (red) align more closely with the 45° diagonal than in other settings, indicating improved predictive accuracy.  
> - Linear regression (blue) captures broader variation but with higher scatter around the diagonal, suggesting larger variance and less stability compared to CRD.  
> - Overall, CRD provides more consistent predictions around the true values, highlighting its robustness in moderate dimensions.  

<img src="/files/densities of Beta.png" style="width:100%;"/>

> - The posterior density plots for p = 5 illustrate distinct shrinkage behavior across coefficients beta1–beta5.  
> - Beta1 and Beta2 remain centered near their true signals, while Beta3–Beta5 concentrate closer to zero, demonstrating effective shrinkage under the prior.  
> - The spread of densities indicates uncertainty remains for weaker coefficients, but the framework still manages to separate strong from weak effects, validating the role of shrinkage priors.  

**Simulation 1**

| n   | Method                | Discrepancy Type | Mean-Squared Error | Mean Gelman-Rubin |
|-----|-----------------------|------------------|--------------------|-------------------|
| 50  | Bayesian CRD          | spearman         | 1.1516             | 1.0692            |
| 100 | Bayesian CRD          | spearman         | 1.1210             | 1.0906            |
| 50  | Least Squares         | -                | 1.1584             | NaN               |
| 100 | Least Squares         | -                | 1.1216             | NaN               |
| 50  | Bayesian CRD (impute) | spearman         | 1.1867             | 1.0747            |
| 100 | Bayesian CRD (impute) | spearman         | 1.1294             | 1.0747            |
| 50  | Bayesian CRD (impute) | kendall          | 1.2045             | 1.0752            |
| 100 | Bayesian CRD (impute) | kendall          | 1.0776             | 1.0768            |

--- 
> - At n = 50, Bayesian CRD with Spearman discrepancy achieved MSE = 1.1516, slightly better than Least Squares (MSE = 1.1584), while maintaining PSRF ≈ 1.07 for convergence stability.  
> - At n = 100, Bayesian CRD (Spearman) reached MSE = 1.1210, nearly identical to OLS (1.1216), but with reliable convergence diagnostics (PSRF ≈ 1.09), unlike OLS.  
> - Bayesian CRD with imputation showed mixed performance: Spearman discrepancy increased error (MSE ≈ 1.18 at n=50), but Kendall discrepancy at n=100 gave the **lowest** error (MSE = 1.0776) across all methods, highlighting its adaptability.   
> - Overall, while OLS matched Bayesian CRD at larger n, the Bayesian framework provided convergence assurance and superior performance with Kendall discrepancy at higher sample sizes.
---

---
title: "Research on Bayesian Parameterization"
excerpt: "This ongoing study explores Bayesian CRD methods with elliptical slice sampling for mixed-type responses. Preliminary simulations suggest stable inference and promising predictive performance compared to OLS, with extensions to external information and shrinkage priors under development."
collection: portfolio
---

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


### 🧾 Results

<img src="/files/CLIP_Results.png" style="width:100%;"/>

> - Training accuracy increased steadily across epochs, rising from 0.4894 at Epoch 1 to 0.5047 at Epoch 3, showing the model’s progressive learning of training features  
> - Training recall improved from 0.4865 to 0.5056 across epochs, indicating better sensitivity to correctly identifying positive cases  
> - The F1 score grew from 0.4725 at Epoch 1 to 0.4891 at Epoch 3, reflecting more balanced performance between precision and recall  
> - Despite improvements during training, the final test accuracy reached only 0.375 with recall of 0.5, suggesting limited generalization on unseen data  
> - The multimodal LLMs approach demonstrated promising classification outcomes, leveraging feature representations beyond traditional CNNs and improving interpretability
> - However, limitations remain due to high computational cost of diffusion models, motivating future exploration of faster consistency models and reinforcement learning–based fine-tuning

---

### 📋 Tools and Setup
 
- NVIDIA RTX 3090 GPU with 24GB memory was used to handle the computational requirements  
- CUDA 12.2 Toolkit and PyTorch 2.5.1 provided the software environment for training  
- Training was optimized with AdamW (batch size = 4, learning rate between 1e-4 and 5e-5)  
- LoRA fine-tuning was applied for parameter efficiency (alpha = 16–32, dropout = 0.1)  
- Experiments were run for 1–3 epochs, balancing fine-tuning performance and resource usage
 
### ✨ Contribution

- **Xiaomeng Xu**  
  Code editing; Abstract; Introduction  

- **Wenfei Mao**  
  Code editing; Diffusion Model; CLIP; Conclusion  

- **Yingzhen Wang**  
  Code editing; Results; Diffusion Model  

- **Shuoyuan Gao**  
  Code editing; Experiment Setup; Conclusion  

- **Github Link**: [Full Repo](https://github.com/xxm12345666/biostat625-group2-project)



---

### 📎 Documents

👉 [Download Full Report (PDF)](/files/FINAL PROJECT.pdf)
👉 [Download Full Slides (PDF)](/files/625 Presentation Slides.pdf)

---

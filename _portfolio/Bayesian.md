---
title: "贝叶斯参数化研究"
excerpt: "这项正在进行的研究探索了针对混合型反应的贝叶斯 CRD 方法与椭圆切片采样。初步模拟表明，与 OLS 相比，该方法在推断上更稳定，并在预测性能上表现出良好潜力，目前正在开发与外部信息和收缩先验相关的扩展。"
collection: portfolio
---

这是我目前正在与 Nicholas Henderson 教授合作开展的研究。他的联系方式是 nchender@umich.edu，任职于密歇根大学公共卫生学院生物统计学系。

---

### 📊 项目总结

- **数据集**:  
  - 含有连续型、二元型和计数型反应的模拟数据集  
  - 外部协变量由 Weibull 模型生成，用于整合性研究  
  - 考虑的样本量：n = 50 和 n = 100，涵盖多种设定  

- **关键方法**:  
  - 开发了适用于混合型反应的贝叶斯 CRD 框架，并结合椭圆切片采样  
  - 通过基于秩的差异度量（Spearman、Kendall）整合外部信息  
  - 扩展模拟以比较贝叶斯 Lasso 和岭回归  

- **进展与初步成果**:

  - 展示了稳定的后验推断与收敛诊断  
    ```
    ## Step 2: Gelman-Rubin PSRF (p = 2)
    ## beta1   1.248638   1.903013
    ## beta2   1.039516   1.096078
    ```
  
  - 在多种场景下实现了与 OLS 相当的均方误差  
    ```
    Simulation 1 Results
    n    Method         Discrepancy   Mean-Squared Error
    50   Bayesian CRD   spearman      1.1516
    50   Least Squares  -             1.1584
    100  Bayesian CRD   spearman      1.1210
    100  Least Squares  -             1.1216
    ```

  - 展示了在处理外部信息和收缩先验上的灵活性  
    ```
    Simulation 2 Results
    100  Bayesian CRD (impute)  kendall  1.6417
    50   Bayesian CRD (impute)  spearman 1.8688
    
    Simulation 3 (Bayesian Lasso) MSE:
    [1] 0.0021 0.1375 0.1523
    ```

  - 识别出在特定系数结构下泛化能力的局限性，提示需要进一步改进  
    ```
    Simulation 5 Results
    50 bext_first_only   MSE = 1.1121
    100 bext_first_only  MSE = 1.0766
    50 bext_mixed        MSE = 1.1235
    100 bext_mixed       MSE = 1.0469
    ```
---

### 🧩 模型实现与设计

- **适用于混合型反应的贝叶斯 CRD**  
  - 多元回归，反应包括 {连续型、二元型、计数型}；协变量分为内部 `Z` 与通过预测抽样获得的外部特征  
  - 潜在高斯随机效应 `U` 捕捉残差相关性；结果特异性的工作权重处理不同的似然  
  - 系数施加局部–全局参数 `(zeta, nu, tau)` 的收缩先验  

- **Mt_MBSP (Gibbs) 采样器**  
  - **二元型**: Pólya–Gamma 增广；更新 `W`、潜在 `Y*`，然后更新系数 `B`  
  - **连续型**: 高斯工作模型，`W=1`  
  - **计数型**: 通过 Pólya–Gamma 的负二项模型；更新离散参数 `r_disp`  
  - 更新循环: `U | ...` (高斯)、`Σ | ...` (逆 Wishart)、局部尺度 `zeta` (GIG) 与 `nu` (Gamma)  
  - 生成预测抽样 `Bpred_samples`（存为 `Y_t`），用于后续 CRD  

- **椭圆切片采样器 (CRD-impute)**  
  - **参数块**: `theta = [beta_Z, beta_B, log(sigma^2), log(kappa), log(lambda)]`  
  - 对角协方差的高斯先验；区间角度采样，无需步长  
  - 使用来自 `fit$Bpred_samples`（或插补抽样）的滚动 `Bdraws` 将 CRD 与 Mt_MBSP 预测相结合  

- **差异度量**  
  - **Spearman**: 基于归一化秩的 `W`  
  - **Kendall**: 通过 `ComputeWmatrix(...)` 中的成对一致/不一致构造  

- **基线与收缩变体**  
  - **OLS** 作为 MSE 比较基准  
  - **贝叶斯 Lasso**: 每个坐标局部尺度 `lambda_j^2`，Gibbs 更新，后验均值估计 `beta`  
  - **贝叶斯 Ridge**: 共轭更新，闭式后验 `(mu_n, V_n)`，并结合逆 Gamma 更新 `sigma^2`  

- **评估方案**  
  - **预测**: 新数据上的 MSE；二元任务使用 ROC/AUC 与 PR/AUPRC  
  - **收敛性**: 跟踪图、ACF、累积均值；拆分链的 Gelman–Rubin PSRF  
  - **可视化**: 后验密度、系数相关性热图、误差箱线图  

- **模拟设计**  
  - **Sim 1**: 线性真实模型，`n = {50,100}`；比较 CRD（有/无插补）与 OLS  
  - **Sim 1b**: 稀疏 beta（仅首个系数非零）以检验收缩效果  
  - **Sim 2**: 外部 Weibull 模型估计 `beta_E`；将秩整合进 CRD；分析 `Dbar_i` 对 `Z` 的回归  
  - **Sim 3**: 贝叶斯 Lasso 比较  
  - **Sim 4**: 贝叶斯 Ridge（共轭）比较  
  - **Sim 5**: 外部 beta 场景（`bext_1`, `bext_2`, `bext_3x10`, `first_only`, `mixed`）以测试泛化能力  

- **默认设置与依赖库**  
  - 设置随机种子（如 970316）确保可复现性  
  - `Mt_MBSP`: `niter=500`, `burn=100`; **CRD-ESS**: `T=1000`; 常用参数 `kappa=1`, `sigma0_sq=3`, `sigma_kappa_sq=3`, `sigma_l_sq=1`; 小 \( \nu \)（如 0.1）；场景特定的 \( \eta \)  
  - R 包: `MASS`, `mvtnorm`, `GIGrvg`, `MCMCpack`, `BayesLogit`, `pROC`, `PRROC`, `caret`, `ggplot2`, `pheatmap`, `loo`


### 📑 结果

<img src="/files/p=3.png" style="width:100%;"/>

> - 在 p = 3 的 CRD-impute 对比中，后验均值估计（红色）比其他设定更贴近 45° 对角线，表明预测精度有所提高。  
> - 线性回归（蓝色）虽然捕捉了更广泛的变化，但在对角线周围的散点更大，说明方差更高且稳定性较差。  
> - 总体而言，CRD 在真实值附近提供了更一致的预测，凸显其在中等维度下的稳健性。  

<img src="/files/densities of Beta.png" style="width:100%;"/>

> - 在 p = 5 的后验密度图显示，系数 beta1–beta5 呈现出明显的收缩行为差异。  
> - Beta1 和 Beta2 保持在其真实信号附近，而 Beta3–Beta5 更集中于零附近，体现了先验的有效收缩。  
> - 密度分布的宽度表明对较弱系数的不确定性依然存在，但框架依然能够区分强效与弱效，验证了收缩先验的作用。

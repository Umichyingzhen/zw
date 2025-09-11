---
title: "Research on Pneumonia Patient Condition Classification Using Diffusion Models and CLIP"
excerpt: " Explored large language model–based techniques for classifying pediatric chest X-ray images into normal, bacterial pneumonia, and viral pneumonia categories. Using 5,856 radiographs and synthetic images generated via LoRA fine-tuning of a Stable Diffusion model, we addressed class imbalance and improved training accuracy. A fine-tuned CLIP model further demonstrated the potential of multimodal approaches for radiologic diagnosis of pneumonia."
collection: portfolio
date: 2024-12-17
---

---

### 🧠 Project Summary

- **Dataset**:  
  - 5,856 pediatric chest X-ray images covering normal, bacterial pneumonia, and viral pneumonia  
  - Synthetic images generated via LoRA fine-tuning of Stable Diffusion to address class imbalance
  - Kaggle Chest X-ray dataset originates from Guangzhou Women and Children’s Medical Center

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

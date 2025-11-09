# GPU Capstone Project — CUDA Sobel Image Denoiser

**Project title:** _FastGPU-Sobel — A CUDA-accelerated Sobel Edge Detector + Denoiser_

## Short description
A CUDA C++ implementation of a high-throughput Sobel edge detector with optional Gaussian denoising stage. The project demonstrates practical CUDA kernel design, shared memory tiling, and CPU/GPU benchmarking on large images. It includes command-line controls for block/grid size, kernel choices, and multiple image inputs so reviewers can reproduce experiments.

## Repository structure
See `src/` for source files (CUDA kernels and host code), `data/` for input images, `artifacts/` for logs and outputs, and `presentation/` for slides and demo notes.

## Build & run (Linux / macOS with NVIDIA GPU & CUDA toolkit)
Prerequisites:
- NVIDIA GPU + CUDA toolkit (tested with CUDA 11.x)
- gcc/g++
- Python 3 (optional scripts)

Build:
```
make
```

Run:
```
./fastgpu-sobel --input data/lena.png --output out.png --mode sobel --repeat 10
```

For full details, open the code in `src/` and `run.sh`.

#!/usr/bin/env bash
set -e
mkdir -p artifacts/logs artifacts/before artifacts/after
cp data/lena.png artifacts/before/ || true
./fastgpu-sobel --input data/lena.png --output artifacts/after/lena_gpu_sobel.png --mode sobel --repeat 10 --csv artifacts/logs/bench_lena.csv 2>&1 | tee artifacts/logs/large_run_log.txt || true
echo "Run complete. Check artifacts/"

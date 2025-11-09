#include <iostream>
#include <vector>
#include <chrono>
#include "image_utils.h"

extern "C" __global__ void sobel_kernel_shared(const unsigned char* in, unsigned char* out, int w, int h);

int main(int argc, char** argv) {
  std::string input = "data/lena.png";
  std::string output = "out.png";
  int repeat = 10;

  // simple arg parsing
  for (int i=1;i<argc;i++) {
    std::string a = argv[i];
    if (a=="--input" && i+1<argc) { input = argv[++i]; }
    if (a=="--output" && i+1<argc) { output = argv[++i]; }
    if (a=="--repeat" && i+1<argc) { repeat = atoi(argv[++i]); }
  }

  int w,h,c;
  std::vector<unsigned char> img;
  if (!load_image(input, w, h, c, img)) { std::cerr<<"Failed to load "<<input<<"\n"; return -1; }

  // convert to grayscale
  std::vector<unsigned char> gray(w*h);
  if (c>=3) {
    for (int i=0;i<w*h;i++) {
      int r = img[3*i+0], g = img[3*i+1], b = img[3*i+2];
      gray[i] = (unsigned char)((0.299*r + 0.587*g + 0.114*b));
    }
  } else {
    for (int i=0;i<w*h;i++) gray[i] = img[i];
  }

  unsigned char* d_in; unsigned char* d_out;
  cudaMalloc(&d_in, w*h);
  cudaMalloc(&d_out, w*h);
  cudaMemcpy(d_in, gray.data(), w*h, cudaMemcpyHostToDevice);

  dim3 block(32, 8);
  dim3 grid((w+31)/32, (h+7)/8);

  // warmup
  sobel_kernel_shared<<<grid, block>>>(d_in, d_out, w, h);
  cudaDeviceSynchronize();

  double total_ms = 0.0;
  for (int i=0;i<repeat;i++) {
    auto t0 = std::chrono::high_resolution_clock::now();
    sobel_kernel_shared<<<grid, block>>>(d_in, d_out, w, h);
    cudaDeviceSynchronize();
    auto t1 = std::chrono::high_resolution_clock::now();
    total_ms += std::chrono::duration<double, std::milli>(t1-t0).count();
  }
  std::cout << "Average GPU time (ms): " << (total_ms/repeat) << std::endl;

  std::vector<unsigned char> out(w*h);
  cudaMemcpy(out.data(), d_out, w*h, cudaMemcpyDeviceToHost);
  std::vector<unsigned char> out_rgb(w*h*3);
  for (int i=0;i<w*h;i++) { out_rgb[3*i+0]=out[i]; out_rgb[3*i+1]=out[i]; out_rgb[3*i+2]=out[i]; }

  if (!write_image(output, w, h, 3, out_rgb)) {
    std::cerr << "Failed to write output\n";
  } else {
    std::cout << "Wrote output to " << output << std::endl;
  }

  cudaFree(d_in); cudaFree(d_out);
  return 0;
}

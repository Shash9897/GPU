#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cstdio>
extern "C" __global__ void sobel_kernel_shared(const unsigned char* in, unsigned char* out, int w, int h) {
  const int TILE_W = 32;
  const int TILE_H = 8;
  __shared__ unsigned char tile[TILE_H + 2][TILE_W + 2];

  int tx = threadIdx.x;
  int ty = threadIdx.y;
  int bx = blockIdx.x * TILE_W;
  int by = blockIdx.y * TILE_H;

  int x = bx + tx;
  int y = by + ty;

  int sx = tx + 1;
  int sy = ty + 1;

  if (x < w && y < h) tile[sy][sx] = in[y*w + x]; else tile[sy][sx] = 0;

  if (tx == 0) {
    int lx = x-1;
    tile[sy][0] = (lx>=0 && y<h && y>=0) ? in[y*w + lx] : 0;
  }
  if (tx == blockDim.x-1) {
    int rx = x+1;
    tile[sy][sx+1] = (rx<w && y<h && y>=0) ? in[y*w + rx] : 0;
  }
  if (ty == 0) {
    int uy = y-1;
    tile[0][sx] = (uy>=0 && x<w && x>=0) ? in[uy*w + x] : 0;
  }
  if (ty == blockDim.y-1) {
    int dy = y+1;
    tile[sy+1][sx] = (dy<h && x<w && x>=0) ? in[dy*w + x] : 0;
  }

  __syncthreads();

  if (x>=w || y>=h) return;

  int gx = -tile[0][0] - 2*tile[1][0] - tile[2][0] + tile[0][2] + 2*tile[1][2] + tile[2][2];
  int gy = -tile[0][0] - 2*tile[0][1] - tile[0][2] + tile[2][0] + 2*tile[2][1] + tile[2][2];
  int mag = abs(gx) + abs(gy);
  if (mag>255) mag = 255;
  out[y*w + x] = (unsigned char)mag;
}

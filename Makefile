NVCC := nvcc
CFLAGS := -O3 -std=c++14
TARGET := fastgpu-sobel
SRCS := src/main.cu src/kernels.cu src/image_utils.cpp

all: $(TARGET)

$(TARGET): $(SRCS)
	$(NVCC) $(CFLAGS) -arch=sm_60 -o $@ $(SRCS)

clean:
	rm -f $(TARGET) *.o

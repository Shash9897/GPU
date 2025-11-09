/* Minimal stub of stb_image_write.h for repository completeness.
   For actual builds use the official stb_image_write.h from https://github.com/nothings/stb */
#ifndef STB_IMAGE_WRITE_H
#define STB_IMAGE_WRITE_H
extern "C" int stbi_write_png(const char *filename, int w, int h, int comp, const void *data, int stride_in_bytes);
#endif

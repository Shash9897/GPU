/* Minimal stub of stb_image.h for repository completeness.
   For actual builds use the official stb_image.h from https://github.com/nothings/stb */
#ifndef STB_IMAGE_H
#define STB_IMAGE_H
extern "C" unsigned char *stbi_load(const char *filename, int *x, int *y, int *channels_in_file, int desired_channels);
extern "C" void stbi_image_free(void *retval_from_stbi_load);
#endif

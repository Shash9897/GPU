#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "image_utils.h"
#include "stb_image.h"
#include "stb_image_write.h"
#include <iostream>

bool load_image(const std::string &path, int &w, int &h, int &c, std::vector<unsigned char> &data) {
  unsigned char *img = stbi_load(path.c_str(), &w, &h, &c, 0);
  if (!img) return false;
  size_t sz = (size_t)w * h * c;
  data.assign(img, img + sz);
  stbi_image_free(img);
  return true;
}

bool write_image(const std::string &path, int w, int h, int c, const std::vector<unsigned char> &data) {
  int success = stbi_write_png(path.c_str(), w, h, c, data.data(), w * c);
  return success != 0;
}

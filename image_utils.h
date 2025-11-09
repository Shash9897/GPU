#pragma once
#include <string>
#include <vector>

bool load_image(const std::string &path, int &w, int &h, int &c, std::vector<unsigned char> &data);
bool write_image(const std::string &path, int w, int h, int c, const std::vector<unsigned char> &data);

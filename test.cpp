
#include <vector>
#include <string>
#include <iostream>
struct T {
    std::vector<std::pair<std::string, std::string>> v;
    ~T() { std::cerr << "[T] destruct\n"; }
};
T t;

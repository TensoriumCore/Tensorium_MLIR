#include "Utils.hpp"
#include <string>

namespace Tensorium {
static int temp_counter = 0;

std::string fresh_var() {
    return "%" + std::to_string(temp_counter++);
}

void reset_temp_counter() {
    temp_counter = 0;
}
}

#pragma once
#include "../Frontend/Tensorium_AST.hpp"
namespace Tensorium {
class Backend {
public:
  virtual ~Backend() = default;
  virtual void generate(const std::shared_ptr<tensorium::ASTNode> &root) = 0;
};
} // namespace Tensorium

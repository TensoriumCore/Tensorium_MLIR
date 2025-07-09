#pragma once
#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <memory>
#include <string>
namespace tensorium {
class FlattenMul {
public:
  std::shared_ptr<ASTNode> run(const std::shared_ptr<ASTNode> &n) {
    if (!n)
      return n;
    for (auto &c : n->children)
      c = run(c);

    if (n->type == ASTNodeType::BinaryOp &&
        (n->value == "*" || n->value == "+")) {

      std::vector<std::shared_ptr<ASTNode>> flat;
      for (auto &c : n->children) {
        if (c->type == ASTNodeType::BinaryOp && c->value == n->value)
          flat.insert(flat.end(), c->children.begin(), c->children.end());
        else
          flat.push_back(c);
      }
      n->children.swap(flat);
    }
    return n;
  }
};
} // namespace tensorium

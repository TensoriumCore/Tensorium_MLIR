#pragma once

#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <iostream>
#include <memory>
#include <string>

namespace tensorium {

inline void print_ast(const std::shared_ptr<tensorium::ASTNode> &node,
                      int indent = 0) {
  if (!node)
    return;

  std::string pad(indent, ' ');
  std::cout << pad << "Node: " << node->value
            << " [Type=" << static_cast<int>(node->type) << "]\n";

  if (node->type == tensorium::ASTNodeType::TensorSymbol) {
    auto tensorNode =
        std::dynamic_pointer_cast<tensorium::TensorSymbolNode>(node);
    if (tensorNode) {
      for (const auto &idx : tensorNode->indices) {
        std::cout << pad << "  Index: " << idx.name << " ("
                  << (idx.variance == tensorium::IndexVariance::Covariant
                          ? "covariant"
                          : "contravariant")
                  << ")\n";
      }
    }
    if (node->type == ASTNodeType::FunctionCall &&
        (node->value == "\\tilde" || node->value == "\\hat")) {
      std::cout << pad << "Decorator: " << node->value << "\n";
      print_ast(node->children[0], indent + 2);
      return;
    }
  }

  for (const auto &child : node->children) {
    print_ast(child, indent + 2);
  }
}

} // namespace tensorium

#pragma once

#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <iostream>
#include <memory>
#include <string>

namespace tensorium {

inline const char *node_type_name(ASTNodeType t) {
  switch (t) {
  case ASTNodeType::Number:
    return "number";
  case ASTNodeType::Symbol:
    return "symbol";
  case ASTNodeType::UnaryOp:
    return "unary";
  case ASTNodeType::BinaryOp:
    return "binary";
  case ASTNodeType::Derivative:
    return "derivative";
  case ASTNodeType::Integral:
    return "integral";
  case ASTNodeType::TensorSymbol:
    return "tensor";
  case ASTNodeType::IndexedExpr:
    return "indexed";
  case ASTNodeType::FunctionCall:
    return "call";
  default:
    return "?";
  }
}

inline void print_ast(const std::shared_ptr<ASTNode> &n, int d = 0) {
  if (!n)
    return;
  std::string pad(d * 2, ' ');
  static const std::unordered_map<std::string, std::string> op = {
      {"+", "+"}, {"-", "−"}, {"*", "×"}, {"/", "÷"}, {"^", "pow"}, {"=", "="}};
  auto v = n->value.empty() ? "ε"
                            : (op.count(n->value) ? op.at(n->value) : n->value);
  std::cout << pad << "• " << v << "  <" << node_type_name(n->type) << ">\n";

  if (n->type == ASTNodeType::TensorSymbol) {
    auto ts = std::static_pointer_cast<TensorSymbolNode>(n);
    for (auto &idx : ts->indices)
      std::cout << pad << "  ⤷ "
                << (idx.variance == IndexVariance::Covariant ? "cov" : "con")
                << ' ' << idx.name << '\n';
  }

  if (n->type == ASTNodeType::IndexedExpr) {
    auto ie = std::static_pointer_cast<IndexedExpressionNode>(n);
    std::cout << pad << "  base\n";
    print_ast(ie->base_, d + 2);
    for (auto &idx : ie->indices_)
      std::cout << pad << "  idx "
                << (idx.variance == IndexVariance::Covariant ? "cov" : "con")
                << ' ' << idx.name << '\n';
    return;
  }

  if (n->type == ASTNodeType::Derivative)
    std::cout << pad << "  ∂\n";
  if (n->type == ASTNodeType::Integral)
    std::cout << pad << "  ∫\n";

  for (auto &c : n->children)
    print_ast(c, d + 1);
}

inline std::vector<std::string> extract_math_blocks(const std::string &input) {
  std::vector<std::string> blocks;
  size_t pos = 0;
  while ((pos = input.find('$', pos)) != std::string::npos) {
    size_t end = input.find('$', pos + 1);
    if (end == std::string::npos)
      break;
    blocks.push_back(input.substr(pos + 1, end - pos - 1));
    pos = end + 1;
  }
  return blocks;
}
} // namespace tensorium

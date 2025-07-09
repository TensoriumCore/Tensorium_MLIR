#pragma once

#include "Tensorium_AST.hpp"
#include <memory>
#include <string>
#include <vector>

namespace tensorium {
struct ASTNode;
enum class IndexVariance { Covariant, Contravariant };

struct Index {
  std::string name;
  IndexVariance variance;

  Index(const std::string &n, IndexVariance v) : name(n), variance(v) {}
};

struct TensorSymbolNode : ASTNode {
  std::string decorator;
  std::vector<Index> indices;

  TensorSymbolNode(const std::string &name, const std::vector<Index> &idx,
                   const std::string &deco = "")
      : ASTNode(ASTNodeType::TensorSymbol, name), decorator(deco),
        indices(idx) {}
};

class IndexedExpressionNode : public ASTNode {
public:
  IndexedExpressionNode(std::shared_ptr<ASTNode> base,
                        const std::vector<Index> &idx)
      : ASTNode(ASTNodeType::IndexedExpr, ""), base_(base), indices_(idx) {}
  std::shared_ptr<ASTNode> base_;
  std::vector<Index> indices_;
};
} // namespace tensorium

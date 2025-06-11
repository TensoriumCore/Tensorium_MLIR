#include "Relativity/Dialect.h"
#include <string>

struct ASTNode {
  virtual ~ASTNode() = default;
};

struct TensorNode : ASTNode {
  std::string name;
  TensorNode(std::string name) : name(std::move(name)) {}
};

struct DerivativeNode : ASTNode {
  ASTNode* operand;
  int index;
  DerivativeNode(ASTNode* operand, int index) 
    : operand(operand), index(index) {}
};

ASTNode* parseLatexEquation(const std::string& latex) {
  // Exemple minimal - À compléter avec un vrai parser
  if (latex.find("\\partial") != std::string::npos) {
    return new DerivativeNode(new TensorNode("g"), 0);
  }
  return new TensorNode(latex);
}

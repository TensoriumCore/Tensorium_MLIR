#pragma once

#include "Tensorium_Tex.hpp"
#include <iostream>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

namespace tensorium {

enum class ASTNodeType {
  Number,
  Symbol,
  BinaryOp,
  UnaryOp,
  FunctionCall,
  Subscript,
  Superscript,
  Derivative,
  Integral,
  TensorSymbol,
  IndexedExpr,
  Decorator,
};

inline const char *to_string(ASTNodeType t) {
  switch (t) {
  case ASTNodeType::Number:
    return "Number";
  case ASTNodeType::Symbol:
    return "Symbol";
  case ASTNodeType::BinaryOp:
    return "BinaryOp";
  case ASTNodeType::UnaryOp:
    return "UnaryOp";
  case ASTNodeType::FunctionCall:
    return "FunctionCall";
  case ASTNodeType::Subscript:
    return "Subscript";
  case ASTNodeType::Superscript:
    return "Superscript";
  case ASTNodeType::Derivative:
    return "Derivative";
  case ASTNodeType::Integral:
    return "Integral";
  case ASTNodeType::TensorSymbol:
    return "TensorSymbol";
  case ASTNodeType::IndexedExpr:
    return "IndexedExpr";
  case ASTNodeType::Decorator:
    return "Decorator";
  }
}

struct ASTNode {
  ASTNodeType type;
  std::string value;
  std::vector<std::shared_ptr<ASTNode>> children;

  ASTNode(ASTNodeType type, const std::string &val = "")
      : type(type), value(val) {}

  ASTNode(ASTNodeType type, const std::string &val,
          const std::vector<std::shared_ptr<ASTNode>> &childs)
      : type(type), value(val), children(childs) {}
  virtual ~ASTNode() = default;

  void print(std::ostream &os, int indent = 0) const {
    for (int i = 0; i < indent; ++i)
      os << "  ";
    os << "ASTNode: " << to_string(this->type) << " [value: " << value << "]\n";
    for (const auto &child : children) {
      if (child)
        child->print(os, indent + 1);
    }
  }
};

class Parser {
public:
  explicit Parser(const std::vector<Token> &tokens) : tokens(tokens), pos(0) {}
  void skip_trivial_tokens() {
    while (!eof() && (peek().type == TokenType::end))
      get();
  }
  std::shared_ptr<ASTNode> parse_expression(int precedence = 0) {
    auto lhs = parse_primary();
    if (!lhs)
      return nullptr;
    return parse_binary_rhs(precedence, lhs);
  }

  std::shared_ptr<ASTNode> attach_indices(std::shared_ptr<ASTNode> base);
  std::vector<std::shared_ptr<ASTNode>> parse_statements();

private:
  std::vector<Token> tokens;
  size_t pos;

  std::shared_ptr<ASTNode> parse_primary();
  std::shared_ptr<ASTNode> parse_primary_with_power();
  std::shared_ptr<ASTNode> parse_binary_rhs(int prec,
                                            std::shared_ptr<ASTNode> lhs);
  std::shared_ptr<ASTNode> parse_tensor_symbol();
  std::shared_ptr<ASTNode> parse_braced_expression();
  Token peek() const {
    if (pos >= tokens.size()) {
      return Token(TokenType::END, "");
    }
    return tokens[pos];
  }

  Token get() {
    if (pos >= tokens.size()) {
      return Token(TokenType::END, "");
    }
    return tokens[pos++];
  }
  bool eof() const { return pos >= tokens.size(); }
  int get_precedence(TokenType t) const {
    switch (t) {
    case TokenType::equal:
      return 1;
    case TokenType::plus:
    case TokenType::minus:
      return 10;
    case TokenType::mult:
    case TokenType::divide:
      return 15;
    case TokenType::POW_OP:
      return 30;
    default:
      return -1;
    }
  }

  bool is_primary_start(TokenType t) const {
    return t == TokenType::symbol || t == TokenType::integer ||
           t == TokenType::real || t == TokenType::lpar ||
           t == TokenType::partial || t == TokenType::decorator ||
           t == TokenType::tilde || t == TokenType::plus ||
           t == TokenType::minus;
  }
};

} // namespace tensorium
namespace tensorium {
std::vector<Token> tokenize(const std::string &input);
}

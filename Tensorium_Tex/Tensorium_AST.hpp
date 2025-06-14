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
  TensorSymbol
};

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
};

class Parser {
public:
  explicit Parser(const std::vector<Token> &tokens) : tokens(tokens), pos(0) {}

  std::shared_ptr<ASTNode> parse_expression(int precedence = 0) {
    auto lhs = parse_primary();
    if (!lhs)
      return nullptr;
    return parse_binary_rhs(precedence, lhs);
  }

private:
  std::vector<Token> tokens;
  size_t pos;

  std::shared_ptr<ASTNode> parse_primary();
  std::shared_ptr<ASTNode> parse_binary_rhs(int prec,
                                            std::shared_ptr<ASTNode> lhs);
  std::shared_ptr<ASTNode> parse_tensor_symbol();
  Token peek() const { return tokens[pos]; }
  Token get() { return tokens[pos++]; }
  bool eof() const { return pos >= tokens.size(); }

  int get_precedence(TokenType t) const {
    switch (t) {
    case TokenType::plus:
    case TokenType::minus:
      return 10;
    case TokenType::mult:
    case TokenType::divide:
      return 20;
    case TokenType::contravariant: 
    case TokenType::pow:
      return 30;
    default:
      return -1;
    }
  }

  bool is_primary_start(TokenType t) const {
    return t == TokenType::symbol || t == TokenType::integer ||
           t == TokenType::real || t == TokenType::lpar ||
           t == TokenType::partial || t == TokenType::decorator ||
           t == TokenType::tilde || t == TokenType::plus // pour unaire +/-
           || t == TokenType::minus;
  }
};

} // namespace tensorium

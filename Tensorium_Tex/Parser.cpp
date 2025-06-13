#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <iostream>

using namespace tensorium;

std::shared_ptr<ASTNode> Parser::parse_primary() {
  Token tok = peek();

  if (tok.type == TokenType::partial) {
    get();

    std::shared_ptr<ASTNode> idxNode = nullptr;
    if (peek().type == TokenType::covariant) {
      get();
      Token idx = get();
      idxNode = std::make_shared<ASTNode>(ASTNodeType::Symbol, idx.value);
    }

    auto operand = parse_primary();

    auto deriv =
        std::make_shared<ASTNode>(ASTNodeType::Derivative, "\\partial");
    if (idxNode)
      deriv->children.push_back(idxNode);
    if (operand)
      deriv->children.push_back(operand);
    return deriv;
  }

  if (tok.type == TokenType::integral) {
    get();
    auto integrand = parse_expression();
    return std::make_shared<ASTNode>(ASTNodeType::Integral, "\\int",
                                     std::vector{integrand});
  }

  // 0) Décorateurs LaTeX
  if (tok.type == TokenType::tilde || tok.type == TokenType::hat ||
      tok.type == TokenType::overbar) {
    auto deco = tok;
    get(); // consume \tilde / \hat / \bar
    auto child = parse_primary();
    // On crée un noeud générique "Decorator" :
    auto node = std::make_shared<ASTNode>(ASTNodeType::FunctionCall,
                                          deco.value /* e.g. "\\tilde" */);
    node->children.push_back(child);
    return node;
  }
  if (tok.type == TokenType::symbol) {
    return parse_tensor_symbol();
  }

  if (tok.type == TokenType::integer || tok.type == TokenType::real) {
    get();
    return std::make_shared<ASTNode>(ASTNodeType::Number, tok.value);
  }

  return nullptr;
}

std::shared_ptr<ASTNode>
Parser::parse_binary_rhs(int prec, std::shared_ptr<ASTNode> lhs) {
  while (!eof()) {
    TokenType t = peek().type;
    int tokPrec = get_precedence(t);
    if (tokPrec < prec)
      return lhs;

    Token op = get(); // consume operator
    auto rhs = parse_primary();
    if (!rhs)
      return nullptr;

    int nextPrec = get_precedence(peek().type);
    if (tokPrec < nextPrec) {
      rhs = parse_binary_rhs(tokPrec + 1, rhs);
      if (!rhs)
        return nullptr;
    }

    auto bin = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, op.value);
    bin->children.push_back(lhs);
    bin->children.push_back(rhs);
    lhs = bin;
  }
  return lhs;
}

std::shared_ptr<ASTNode> Parser::parse_tensor_symbol() {
  Token symbolTok = get();
  std::string name = symbolTok.value;
  std::vector<Index> indices;

  while (!eof()) {
    TokenType t = peek().type;

    if (t == covariant || t == contravariant) {
      IndexVariance variance = (t == covariant) ? IndexVariance::Covariant
                                                : IndexVariance::Contravariant;
      get();

      if (peek().type == lbrace) {
        get();
        while (!eof() && peek().type != rbrace) {
          Token idx = get();
          if (idx.type == symbol) {
            indices.emplace_back(idx.value, variance);
          }
        }
        if (peek().type == rbrace)
          get();
      } else {
        Token idx = get();
        if (idx.type == symbol) {
          indices.emplace_back(idx.value, variance);
        }
      }
    } else {
      break;
    }
  }

  return std::make_shared<TensorSymbolNode>(name, indices);
}

#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <iostream>
#include <optional>

using namespace tensorium;

std::shared_ptr<ASTNode> Parser::parse_primary() {
  Token tok = peek();

  /*============= 1. opérateurs unaires + / - =============*/
  if (tok.type == TokenType::plus || tok.type == TokenType::minus) {
    get();                          // consomme + ou -
    auto operand = parse_primary(); // ce qui suit
    if (!operand)
      return nullptr;
    auto node = std::make_shared<ASTNode>(ASTNodeType::UnaryOp, tok.value);
    node->children.push_back(operand);
    return node;
  }

  /*============= 2. parenthèses =============*/
  if (tok.type == TokenType::lpar) {
    get();
    auto expr = parse_expression();
    if (peek().type == TokenType::rpar)
      get();
    else
      std::cerr << "Error: expected ')'\n";
    return expr;
  }

  /*============= 3. fraction \frac{...}{...} =============*/
  if (tok.type == TokenType::symbol && tok.value == "\\frac") {
    get(); // \frac
    if (peek().type != TokenType::lbrace) {
      std::cerr << "Error: expected '{' after \\frac\n";
      return nullptr;
    }
    get(); // {

    auto num = parse_expression();
    if (peek().type == TokenType::rbrace)
      get(); // }
    else
      std::cerr << "Error: expected '}' after numerator\n";

    if (peek().type != TokenType::lbrace) {
      std::cerr << "Error: expected '{' before denominator\n";
      return nullptr;
    }
    get(); // {

    auto den = parse_expression();
    if (peek().type == TokenType::rbrace)
      get(); // }
    else
      std::cerr << "Error: expected '}' after denominator\n";

    auto frac = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "/");
    frac->children = {num, den};
    return frac;
  }

  /*============= 4. dérivée partielle =============*/
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

  /*============= 5. intégrale =============*/
  if (tok.type == TokenType::integral) {
    get();
    auto integrand = parse_expression();
    return std::make_shared<ASTNode>(ASTNodeType::Integral, "\\int",
                                     std::vector{integrand});
  }

  /*============= 6. décorateurs (\tilde, \hat, \bar) =============*/
  if (tok.type == TokenType::decorator) {
    Token deco = get();
    if (peek().type == TokenType::lbrace) {
      get(); // {
      auto child = parse_expression();
      if (peek().type == TokenType::rbrace)
        get(); // }
      else
        std::cerr << "Error: expected '}'\n";
      auto node =
          std::make_shared<ASTNode>(ASTNodeType::FunctionCall, deco.value);
      node->children.push_back(child);
      return node;
    }
    auto child = parse_primary();
    auto node =
        std::make_shared<ASTNode>(ASTNodeType::FunctionCall, deco.value);
    node->children.push_back(child);
    return node;
  }

  auto make_base_node = [&](Token t) -> std::shared_ptr<ASTNode> {
    if (t.type == TokenType::symbol)
      return parse_tensor_symbol();
    get();
    return std::make_shared<ASTNode>(ASTNodeType::Number, t.value);
  };

  if (tok.type == TokenType::symbol || tok.type == TokenType::integer ||
      tok.type == TokenType::real) {
    auto base = make_base_node(tok);

    /*----- puissance ? -----*/
    if (peek().type == TokenType::contravariant) {
      get(); // '^'

      std::shared_ptr<ASTNode> exponent = nullptr;
      if (peek().type == TokenType::lbrace) {
        get(); // {
        exponent = parse_expression();
        if (peek().type == TokenType::rbrace)
          get(); // }
        else
          std::cerr << "Error: expected '}' after exponent\n";
      } else {
        Token eTok = get();
        if (eTok.type == TokenType::integer || eTok.type == TokenType::symbol) {
          exponent = std::make_shared<ASTNode>(eTok.type == TokenType::symbol
                                                   ? ASTNodeType::Symbol
                                                   : ASTNodeType::Number,
                                               eTok.value);
        } else {
          std::cerr << "Error: bad exponent after '^'\n";
          return base;
        }
      }

      auto power = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "^");
      power->children = {base, exponent};
      return power;
    }
    return base;
  }

  return nullptr; // rien reconnu
}

std::shared_ptr<ASTNode>
Parser::parse_binary_rhs(int prec, std::shared_ptr<ASTNode> lhs) {
  while (!eof()) {
    TokenType t = peek().type;
    int tokPrec = get_precedence(t);
    bool implicit = false;

    /*---------- détection de multiplication implicite ----------*/
    if (tokPrec < 0 && is_primary_start(t)) { // ex. « 2M » ou « r d\theta »
      tokPrec = 20;                           // même priorité que '*'
      implicit = true;
    }

    if (tokPrec < prec) // plus faible priorité → on remonte
      return lhs;

    std::shared_ptr<ASTNode> rhs;

    if (implicit) {
      rhs = parse_primary(); // ne consomme PAS d’opérateur
    } else {
      Token opTok = get(); // consomme +, -, *, /, ^
      rhs = parse_primary();
      if (!rhs)
        return nullptr;

      /* gestion ^ associativité droite */
      if (opTok.type == TokenType::pow &&
          get_precedence(peek().type) > tokPrec) {
        rhs = parse_binary_rhs(tokPrec + 1, rhs);
        if (!rhs)
          return nullptr;
      }

      auto bin = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, opTok.value);
      bin->children = {lhs, rhs};
      lhs = bin;
      continue;
    }

    /* nœud ‘*’ pour l’implicite */
    auto bin = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "*");
    bin->children = {lhs, rhs};
    lhs = bin;
  }
  return lhs;
}

#include <optional>

std::shared_ptr<ASTNode> Parser::parse_tensor_symbol() {
  Token firstTok = get();

  std::string name;
  std::optional<std::string> decorator;
  std::vector<Index> indices;

  if (firstTok.type == TokenType::decorator) {
    decorator = firstTok.value;
    if (peek().type == TokenType::lbrace) {
      get();
      Token inner = get();
      if (inner.type == TokenType::symbol) {
        name = inner.value;
      } else {
        std::cerr << "Expected a symbol inside decorator " << firstTok.value
                  << ", but got: " << inner.value << "\n";
      }
      if (peek().type == TokenType::rbrace)
        get();
      else
        std::cerr << "Missing closing brace after decorator expression\n";
    } else {
      std::cerr << "Decorator " << firstTok.value << " not followed by '{'\n";
    }
  } else {
    name = firstTok.value;
  }

  while (!eof()) {
    TokenType t = peek().type;

    if (t == TokenType::covariant || t == TokenType::contravariant) {
      IndexVariance variance = (t == TokenType::covariant)
                                   ? IndexVariance::Covariant
                                   : IndexVariance::Contravariant;
      get();

      if (peek().type == TokenType::lbrace) {
        get();
        while (!eof() && peek().type != TokenType::rbrace) {
          Token idx = get();
          if (idx.type == TokenType::symbol)
            indices.emplace_back(idx.value, variance);
        }
        if (peek().type == TokenType::rbrace)
          get();
        else
          std::cerr << "Missing closing brace for index group\n";
      } else {
        Token idx = get();
        if (idx.type == TokenType::symbol) {
          indices.emplace_back(idx.value, variance);
        } else {
          std::cerr << "Expected symbol after "
                    << (variance == IndexVariance::Covariant ? "_" : "^")
                    << "\n";
        }
      }
    } else {
      break;
    }
  }

  return std::make_shared<TensorSymbolNode>(name, indices,
                                            decorator.value_or(""));
}

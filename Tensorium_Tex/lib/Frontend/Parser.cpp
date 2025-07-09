#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <algorithm>
#include <iostream>
#include <optional>

using namespace tensorium;

std::vector<std::string> extract_math_blocks(const std::string &input) {
  std::vector<std::string> blocks;
  size_t pos = 0;
  while ((pos = input.find('$', pos)) != std::string::npos) {
    size_t end = input.find('$', pos + 1);
    if (end == std::string::npos)
      break;

    std::string block = input.substr(pos + 1, end - pos - 1);

    auto eq = block.find('=');
    if (eq != std::string::npos)
      block = block.substr(eq + 1);

    block.erase(std::remove(block.begin(), block.end(), '&'), block.end());

    size_t start = block.find_first_not_of(" \t\n\r");
    size_t finish = block.find_last_not_of(" \t\n\r");
    if (start != std::string::npos && finish != std::string::npos)
      block = block.substr(start, finish - start + 1);

    blocks.push_back(block);
    pos = end + 1;
  }
  return blocks;
}

std::vector<std::shared_ptr<ASTNode>> Parser::parse_statements() {
  std::vector<std::shared_ptr<ASTNode>> statements;
  while (!eof()) {
    auto ast = parse_expression();
    if (ast)
      statements.push_back(ast);

    while (!eof() && peek().type == TokenType::end)
      get();

    if (eof())
      break;

    TokenType t = peek().type;
    if (t == TokenType::lpar || t == TokenType::rpar)
      get();
    else if (t != TokenType::end) {
      std::cerr << "Error: unexpected token '" << peek().value
                << "' at position " << pos << "\n";
      get();
    }
  }
  return statements;
}

std::shared_ptr<ASTNode> Parser::parse_primary() {
    Token tok = peek();

    if (tok.type == TokenType::plus || tok.type == TokenType::minus) {
        get(); 
        auto operand = parse_primary();
        if (!operand) return nullptr;

        auto node = std::make_shared<ASTNode>(ASTNodeType::UnaryOp, tok.value);
        node->children.push_back(operand);
        return attach_indices(node); 
    }

    if (tok.type == TokenType::lpar) {
        get();                    
        auto expr = parse_expression();
        if (peek().type == TokenType::rpar) get(); 
        else std::cerr << "Error: expected ')'\n";
		return attach_indices(expr);
	}
	if (tok.type == TokenType::lbrace) {
		get();  
		auto expr = parse_expression();
		if (peek().type == TokenType::rbrace)
			get(); 
		else
			std::cerr << "Error: expected '}'\n";
		return attach_indices(expr); 
	}
	if (tok.type == TokenType::symbol && tok.value == "\\frac") {
		get();
		if (peek().type != TokenType::lbrace) {
			std::cerr << "Error: expected '{' after \\frac\n";
			return nullptr;
		}
		get(); 

		auto num = parse_expression();
		if (peek().type == TokenType::rbrace) get();
		else std::cerr << "Error: expected '}' after numerator\n";

		if (peek().type != TokenType::lbrace) {
			std::cerr << "Error: expected '{' before denominator\n";
			return nullptr;
		}
		get(); 

		auto den = parse_expression();
		if (peek().type == TokenType::rbrace) get();
		else std::cerr << "Error: expected '}' after denominator\n";

		auto frac = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "/");
		frac->children = {num, den};
        return attach_indices(frac);
    }

    if (tok.type == TokenType::partial) {
        get();
        std::shared_ptr<ASTNode> powNode = nullptr, idxNode = nullptr;

        if (peek().type == TokenType::contravariant) {
            get();
            Token pow = get();
            powNode = std::make_shared<ASTNode>(
                pow.type == TokenType::integer ? ASTNodeType::Number
                                               : ASTNodeType::Symbol,
                pow.value);
        }
        if (peek().type == TokenType::covariant) { 
            get();
            Token idx = get();
            idxNode = std::make_shared<ASTNode>(ASTNodeType::Symbol, idx.value);
        }

        auto operand = parse_primary();
        auto deriv = std::make_shared<ASTNode>(ASTNodeType::Derivative, "\\partial");
        if (powNode) deriv->children.push_back(powNode);
        if (idxNode) deriv->children.push_back(idxNode);
        if (operand) deriv->children.push_back(operand);

        return attach_indices(deriv);
    }

    if (tok.type == TokenType::integral) {
        get();
        auto integrand = parse_expression();
        return attach_indices(
            std::make_shared<ASTNode>(ASTNodeType::Integral, "\\int",
                                      std::vector{integrand}));
    }

    if (tok.type == TokenType::decorator || tok.type == TokenType::symbol) {
        return attach_indices(parse_tensor_symbol());
    }

    auto make_base_node = [&](Token t) -> std::shared_ptr<ASTNode> {
        if (t.type == TokenType::symbol) return parse_tensor_symbol();
        get();                                          // consomme nombre
        return std::make_shared<ASTNode>(ASTNodeType::Number, t.value);
    };

    if (tok.type == TokenType::symbol ||
        tok.type == TokenType::integer ||
        tok.type == TokenType::real) {

        auto base = make_base_node(tok);

        if (peek().type == TokenType::contravariant) {
            get(); 

            std::shared_ptr<ASTNode> exponent = nullptr;
            if (peek().type == TokenType::lbrace) {
                get();
                exponent = parse_expression();
                if (peek().type == TokenType::rbrace) get();
                else std::cerr << "Error: expected '}' after exponent\n";
            } else {  
                Token eTok = get();
                if (eTok.type == TokenType::integer || eTok.type == TokenType::symbol) {
                    exponent = std::make_shared<ASTNode>(
                        eTok.type == TokenType::symbol ? ASTNodeType::Symbol
                                                       : ASTNodeType::Number,
                        eTok.value);
                } else {
                    std::cerr << "Error: bad exponent after '^'\n";
                    return attach_indices(base);
                }
            }

            auto power = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "^");
            power->children = {base, exponent};
            return attach_indices(power); 
        }

        return attach_indices(base);
    }

    return nullptr;
}

std::shared_ptr<ASTNode>
Parser::parse_binary_rhs(int prec, std::shared_ptr<ASTNode> lhs) {
    while (!eof()) {
        TokenType t      = peek().type;
        int       tokPrec = get_precedence(t);
        bool      implicit = false;

        /* produit implicite : 20 */
        if (tokPrec < 0 && is_primary_start(t)) {
            tokPrec  = 20;
            implicit = true;
        }

        if (tokPrec < prec)
            return lhs;

        std::shared_ptr<ASTNode> rhs;

        if (implicit) {
			auto prim = parse_primary();                  // χ
			if (!eof() && peek().type == TokenType::pow)  // χ ^ ...
				rhs = parse_binary_rhs(30, prim);         // traite d’abord la puissance
			else
				rhs = prim;
        } else {
            Token opTok = get(); 
            rhs = parse_primary();
            if (!rhs) return nullptr;

            if (opTok.type == TokenType::pow &&
                get_precedence(peek().type) >= tokPrec) { 
                rhs = parse_binary_rhs(tokPrec, rhs);
                if (!rhs) return nullptr;
            }

            auto bin = std::make_shared<ASTNode>(ASTNodeType::BinaryOp,
                                                 opTok.value);
            bin->children = {lhs, rhs};
            lhs = bin;
            continue;
        }

        auto bin = std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "*");
        bin->children = {lhs, rhs};
        lhs = bin;
    }
    return lhs;
}

void append_split_indices(std::vector<Index> &list, const std::string &raw,
                          IndexVariance var) {
  if (raw.size() > 1 && raw.rfind('\\', 0) != 0) {
    for (char c : raw)
      list.emplace_back(std::string(1, c), var);
  } else {
    list.emplace_back(raw, var);
  }
}

std::shared_ptr<ASTNode> Parser::parse_tensor_symbol() {
  Token firstTok = get();
  std::string name;
  std::optional<std::string> decorator;
  std::vector<Index> indices;

  if (firstTok.type == TokenType::decorator) {
    decorator = firstTok.value;
    if (peek().type != TokenType::lbrace)
      return std::make_shared<ASTNode>(ASTNodeType::Symbol, "?");
    get();
    Token inner = get();
    if (inner.type != TokenType::symbol)
      return std::make_shared<ASTNode>(ASTNodeType::Symbol, "?");
    name = inner.value;
    if (peek().type == TokenType::rbrace)
      get();
  } else {
    name = firstTok.value;
  }

  while (!eof()) {
    TokenType t = peek().type;
    if (t != TokenType::covariant && t != TokenType::contravariant)
      break;

    IndexVariance var = (t == TokenType::covariant)
                            ? IndexVariance::Covariant
                            : IndexVariance::Contravariant;
    get();

    if (peek().type == TokenType::lbrace) {
      get();
      while (!eof() && peek().type != TokenType::rbrace) {
        Token idxTok = get();
        if (idxTok.type == TokenType::symbol ||
            idxTok.type == TokenType::integer)
          append_split_indices(indices, idxTok.value, var);
      }
      if (peek().type == TokenType::rbrace)
        get();
    } else {
      Token idxTok = get();
      if (idxTok.type == TokenType::symbol || idxTok.type == TokenType::integer)
        append_split_indices(indices, idxTok.value, var);
    }
  }

  return std::make_shared<TensorSymbolNode>(name, indices,
                                            decorator.value_or(""));
}

std::string token_type_name(TokenType type) {
  switch (type) {
  case TokenType::plus:
    return "plus";
  case TokenType::bar:
    return "bar";
  case TokenType::minus:
    return "minus";
  case TokenType::tilde:
    return "tilde";
  case TokenType::hat:
    return "hat";
  case TokenType::mult:
    return "mult";
  case TokenType::equal:
    return "equal";
  case TokenType::divide:
    return "div";
  case TokenType::pow:
    return "pow";
  case TokenType::lpar:
    return "lpar";
  case TokenType::decorator:
    return "decorator";
  case TokenType::rpar:
    return "rpar";
  case TokenType::lbrace:
    return "lbrace";
  case TokenType::rbrace:
    return "rbrace";
  case TokenType::symbol:
    return "symbol";
  case TokenType::integer:
    return "integer";
  case TokenType::real:
    return "real";
  case TokenType::derivative:
    return "derivative";
  case TokenType::partial:
    return "partial";
  case TokenType::integral:
    return "integral";
  case TokenType::covariant:
    return "covariant";
  case TokenType::contravariant:
    return "contravariant";
  case TokenType::transpose:
    return "transpose";
  case TokenType::inner:
    return "inner";
  case TokenType::outer:
    return "outer";
  case TokenType::end:
    return "end";
  case TokenType::unknown:
    return "unknown";
  default:
    return "???";
  }
}
std::shared_ptr<ASTNode> Parser::attach_indices(std::shared_ptr<ASTNode> base) {
    std::vector<Index> indices;

    while (!eof() && peek().type == TokenType::end)
        get();

    while (!eof()) {
        TokenType t = peek().type;

        if (t == TokenType::end) { get(); continue; }

        if (t != TokenType::covariant && t != TokenType::contravariant)
            break;

        IndexVariance var = (t == TokenType::covariant)
                                ? IndexVariance::Covariant
                                : IndexVariance::Contravariant;
        get(); 

        if (peek().type == TokenType::lbrace) {
            get();
            while (!eof() && peek().type != TokenType::rbrace) {
                Token idxTok = get();
                if (idxTok.type == TokenType::symbol ||
                    idxTok.type == TokenType::integer)
                    append_split_indices(indices, idxTok.value, var);
            }
            if (peek().type == TokenType::rbrace) get();
        } else { 
            Token idxTok = get();
            if (idxTok.type == TokenType::symbol || idxTok.type == TokenType::integer)
                append_split_indices(indices, idxTok.value, var);
        }

    }

    if (indices.empty())
        return base;

    if (auto ts = std::dynamic_pointer_cast<TensorSymbolNode>(base)) {
        ts->indices.insert(ts->indices.end(), indices.begin(), indices.end());
        return ts;
    }

    return std::make_shared<IndexedExpressionNode>(base, indices);
}


#include "FormulaParser.h"
#include <cctype>
#include <sstream>
#include <memory>
#include <string>

namespace FormulaParser {

std::vector<std::string> tokenize(const std::string& expr) {
    std::vector<std::string> tokens;
    size_t i = 0, N = expr.size();
    while (i < N) {
        if (std::isspace(expr[i])) { ++i; continue; }
        if (std::isdigit(expr[i])) {
            size_t j = i;
            while (j < N && (std::isdigit(expr[j]) || expr[j] == '.')) ++j;
            tokens.push_back(expr.substr(i, j-i));
            i = j;
        } else if (std::isalpha(expr[i])) {
            size_t j = i;
            while (j < N && (std::isalnum(expr[j]) || expr[j] == '_')) ++j;
            tokens.push_back(expr.substr(i, j-i));
            i = j;
        } else if (expr[i] == '{' || expr[i] == '}') {
            tokens.push_back(std::string(1, expr[i]));
            ++i;
        } else if (std::string("+-*/()^").find(expr[i]) != std::string::npos) {
            tokens.push_back(std::string(1, expr[i]));
            ++i;
        } else {
            ++i;
        }
    }
    return tokens;
}

std::shared_ptr<ASTNode> parse_expr(const std::vector<std::string>& tokens, size_t &i);

std::shared_ptr<ASTNode> parse_primary(const std::vector<std::string>& tokens, size_t &i) {
    if (i >= tokens.size()) return nullptr;
    const auto &tok = tokens[i];
    if (tok == "(") {
        ++i;
        auto inside = parse_expr(tokens, i);
        if (i < tokens.size() && tokens[i] == ")") ++i;
        return inside;
    }
    if (tok == "frac") {
        ++i;
        ++i; auto num = parse_expr(tokens, i); ++i;
        ++i; auto den = parse_expr(tokens, i); ++i;
        auto n = std::make_shared<ASTNode>(NodeType::BinaryOp, "/");
        n->children = {num, den};
        return n;
    }
    if (tok=="sin"||tok=="cos"||tok=="tan") {
        std::string fn = tok; ++i;
        auto arg = parse_primary(tokens, i);
        auto node = std::make_shared<ASTNode>(NodeType::FunctionCall, fn);
        node->children = {arg};
        return node;
    }
    ++i;
    if (std::isdigit(tok[0]))
        return std::make_shared<ASTNode>(NodeType::Number, tok);
    else
        return std::make_shared<ASTNode>(NodeType::Symbol, tok);
}

std::shared_ptr<ASTNode> parse_factor(const std::vector<std::string>& tokens, size_t &i) {
    auto node = parse_primary(tokens, i);
    while (i < tokens.size() && tokens[i] == "^") {
        ++i;
        std::shared_ptr<ASTNode> exp;
        if (i<tokens.size() && tokens[i]=="{") {
            ++i; exp = parse_expr(tokens, i);
            if (i<tokens.size() && tokens[i]=="}") ++i;
        } else {
            exp = std::make_shared<ASTNode>(NodeType::Number, tokens[i++]);
        }
        auto powNode = std::make_shared<ASTNode>(NodeType::BinaryOp, "^");
        powNode->children = {node, exp};
        node = powNode;
    }
    return node;
}

std::shared_ptr<ASTNode> parse_term(const std::vector<std::string>& tokens, size_t &i) {
    auto node = parse_factor(tokens, i);
    while (i < tokens.size() &&
           (tokens[i] == "*" || tokens[i] == "/")) {
        std::string op = tokens[i++];
        auto rhs = parse_factor(tokens, i);
        auto bin = std::make_shared<ASTNode>(NodeType::BinaryOp, op);
        bin->children = {node, rhs};
        node = bin;
    }
    return node;
}

std::shared_ptr<ASTNode> parse_expr(const std::vector<std::string>& tokens, size_t &i) {
    auto node = parse_term(tokens, i);
    while (i < tokens.size() &&
           (tokens[i] == "+" || tokens[i] == "-")) {
        std::string op = tokens[i++];
        auto rhs = parse_term(tokens, i);
        auto bin = std::make_shared<ASTNode>(NodeType::BinaryOp, op);
        bin->children = {node, rhs};
        node = bin;
    }
    return node;
}

std::shared_ptr<ASTNode> parse(const std::vector<std::string>& tokens) {
	size_t i = 0;
	return parse_expr(tokens, i);
}

std::shared_ptr<ASTNode> simplify(const std::shared_ptr<ASTNode>& root) {
	return root;
}


std::string ast_to_string(const std::shared_ptr<ASTNode>& node) {
    if (!node) return "";
    switch (node->type) {
      case NodeType::Number:
      case NodeType::Symbol:
        return node->value;
      case NodeType::UnaryOp:
        return node->value + "(" + ast_to_string(node->children[0]) + ")";
      case NodeType::BinaryOp:
        return "(" + ast_to_string(node->children[0]) 
                   + " " + node->value + " " 
                   + ast_to_string(node->children[1]) + ")";
      case NodeType::FunctionCall:
        return node->value + "(" + ast_to_string(node->children[0]) + ")";
      case NodeType::TensorSymbol:
        return node->value;
    }
    return "?";
}


std::string simplify_formula(const std::string& expr) {
    auto tokens = tokenize(expr);
    auto ast = parse(tokens);
    auto simp = simplify(ast);
    return ast_to_string(simp);
}

} // namespace FormulaParser

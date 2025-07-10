
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

std::shared_ptr<ASTNode> parse_expr(const std::vector<std::string>& tokens, size_t& i);

std::shared_ptr<ASTNode> parse_primary(const std::vector<std::string>& tokens, size_t& i) {
    if (i >= tokens.size()) return nullptr;
    if (tokens[i] == "frac") {
        ++i;
        if (tokens[i] == "{") ++i;
        auto num = parse_expr(tokens, i);
        if (tokens[i] == "}") ++i;
        if (tokens[i] == "{") ++i;
        auto den = parse_expr(tokens, i);
        if (tokens[i] == "}") ++i;
        auto node = std::make_shared<ASTNode>(NodeType::BinaryOp, "/");
        node->children = {num, den};
        return node;
    }
    if (tokens[i] == "(") {
        ++i;
        auto expr = parse_expr(tokens, i);
        if (i < tokens.size() && tokens[i] == ")") ++i;
        return expr;
    }
    if (tokens[i] == "+" || tokens[i] == "-") {
        std::string op = tokens[i++];
        auto operand = parse_primary(tokens, i);
        auto node = std::make_shared<ASTNode>(NodeType::UnaryOp, op);
        node->children.push_back(operand);
        return node;
    }
    std::string val = tokens[i++];
    std::shared_ptr<ASTNode> base;
    if (std::isdigit(val[0])) base = std::make_shared<ASTNode>(NodeType::Number, val);
    else base = std::make_shared<ASTNode>(NodeType::Symbol, val);

    if (i < tokens.size() && tokens[i] == "^") {
        ++i;
        if (tokens[i] == "{") ++i;
        auto exp = parse_expr(tokens, i);
        if (tokens[i] == "}") ++i;
        auto node = std::make_shared<ASTNode>(NodeType::BinaryOp, "^");
        node->children = {base, exp};
        return node;
    }
    return base;
}


std::shared_ptr<ASTNode> parse_term(const std::vector<std::string>& tokens, size_t& i) {
    auto lhs = parse_primary(tokens, i);

    while (i < tokens.size()) {
        if (tokens[i] == "*" || tokens[i] == "/") {
            std::string op = tokens[i++];
            auto rhs = parse_primary(tokens, i);
            auto node = std::make_shared<ASTNode>(NodeType::BinaryOp, op);
            node->children = {lhs, rhs};
            lhs = node;
        }
        else if (
            tokens[i] == "frac" ||
            tokens[i] == "(" ||
            (tokens[i].size() && (std::isalpha(tokens[i][0]) || std::isdigit(tokens[i][0])))
        ) {
            auto rhs = parse_primary(tokens, i);
            auto node = std::make_shared<ASTNode>(NodeType::BinaryOp, "*");
            node->children = {lhs, rhs};
            lhs = node;
        }
        else {
            break;
        }
    }
    return lhs;
}

std::shared_ptr<ASTNode> parse_expr(const std::vector<std::string>& tokens, size_t& i) {
	auto lhs = parse_term(tokens, i);
	while (i < tokens.size()) {
		if (tokens[i] == "+" || tokens[i] == "-") {
			std::string op = tokens[i++];
			auto rhs = parse_term(tokens, i);
			auto node = std::make_shared<ASTNode>(NodeType::BinaryOp, op);
			node->children = {lhs, rhs};
			lhs = node;
		} else {
			break;
		}
	}
	return lhs;
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
    if (node->type == NodeType::Number || node->type == NodeType::Symbol)
        return node->value;
    if (node->type == NodeType::UnaryOp)
        return node->value + "(" + ast_to_string(node->children[0]) + ")";
    if (node->type == NodeType::BinaryOp)
        return "(" + ast_to_string(node->children[0]) + " " + node->value + " " + ast_to_string(node->children[1]) + ")";
    return "?";
}

std::string simplify_formula(const std::string& expr) {
    auto tokens = tokenize(expr);
    auto ast = parse(tokens);
    auto simp = simplify(ast);
    return ast_to_string(simp);
}

} // namespace FormulaParser

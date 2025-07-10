#pragma once
#include "../Frontend/Tensorium_AST.hpp"
#include <cmath>
#include <memory>
#include <string>

namespace tensorium {

	using Node = std::shared_ptr<ASTNode>;
	inline Node simplify_expression(const Node& node) {
		if (!node) return nullptr;

		if (node->type == ASTNodeType::Symbol || node->type == ASTNodeType::Number)
			return node;

		if (node->type == ASTNodeType::UnaryOp) {
			Node arg = simplify_expression(node->children[0]);
			if (node->value == "-" && arg->type == ASTNodeType::UnaryOp && arg->value == "-")
				return arg->children[0];
			return std::make_shared<ASTNode>(ASTNodeType::UnaryOp, node->value, std::vector<Node>{arg});
		}

		if (node->type == ASTNodeType::BinaryOp && node->children.size() == 2) {
			Node lhs = simplify_expression(node->children[0]);
			Node rhs = simplify_expression(node->children[1]);

			if (lhs->type == ASTNodeType::Number && rhs->type == ASTNodeType::Number) {
				double a = std::stod(lhs->value);
				double b = std::stod(rhs->value);
				if (node->value == "+") return std::make_shared<ASTNode>(ASTNodeType::Number, std::to_string(a + b));
				if (node->value == "-") return std::make_shared<ASTNode>(ASTNodeType::Number, std::to_string(a - b));
				if (node->value == "*") return std::make_shared<ASTNode>(ASTNodeType::Number, std::to_string(a * b));
				if (node->value == "/" && b != 0) return std::make_shared<ASTNode>(ASTNodeType::Number, std::to_string(a / b));
			}

			if (node->value == "+") {
				if (lhs->type == ASTNodeType::Number && lhs->value == "0") return rhs;
				if (rhs->type == ASTNodeType::Number && rhs->value == "0") return lhs;
			}
			if (node->value == "*") {
				if ((lhs->type == ASTNodeType::Number && lhs->value == "0") ||
						(rhs->type == ASTNodeType::Number && rhs->value == "0"))
					return std::make_shared<ASTNode>(ASTNodeType::Number, "0");
				if (lhs->type == ASTNodeType::Number && lhs->value == "1") return rhs;
				if (rhs->type == ASTNodeType::Number && rhs->value == "1") return lhs;
			}
			if (node->value == "-") {
				if (rhs->type == ASTNodeType::Number && rhs->value == "0") return lhs;
				if (lhs->type == ASTNodeType::Number && lhs->value == "0")
					return std::make_shared<ASTNode>(ASTNodeType::UnaryOp, "-", std::vector<Node>{rhs});
			}

			return std::make_shared<ASTNode>(ASTNodeType::BinaryOp, node->value, std::vector<Node>{lhs, rhs});
		}

		return node;
	}

} // namespace tensorium

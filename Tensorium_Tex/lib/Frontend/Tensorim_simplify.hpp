
#pragma once
#include <memory>
#include <string>
#include <sstream>
#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"

namespace tensorium {

inline std::string ast_to_simple_string(const std::shared_ptr<ASTNode>& n) {
    if (!n) return "";

    switch (n->type) {
        case ASTNodeType::Number:
        case ASTNodeType::Symbol:
            return n->value;

        case ASTNodeType::UnaryOp:
            return n->value + ast_to_simple_string(n->children[0]);

        case ASTNodeType::BinaryOp: {
            auto op = n->value;
            if (op == "/")
                return "(" + ast_to_simple_string(n->children[0]) + ")/(" + ast_to_simple_string(n->children[1]) + ")";
            if (op == "^")
                return ast_to_simple_string(n->children[0]) + "^" + ast_to_simple_string(n->children[1]);
           
			if (op == "*" || op == "+" || op == "-") {
				std::ostringstream oss;
				oss << "(";
				for (size_t i = 0; i < n->children.size(); ++i) {
					if (i != 0) oss << " " << op << " ";
					oss << ast_to_simple_string(n->children[i]);
				}
				oss << ")";
				return oss.str();
			}
			return "(" + ast_to_simple_string(n->children[0]) + " " + op + " " + ast_to_simple_string(n->children[1]) + ")";
        }
        case ASTNodeType::FunctionCall: {
            std::ostringstream oss;
            oss << n->value << "(";
            for (size_t i = 0; i < n->children.size(); ++i) {
                if (i != 0) oss << ", ";
                oss << ast_to_simple_string(n->children[i]);
            }
            oss << ")";
            return oss.str();
        }
        case ASTNodeType::TensorSymbol: {
            return n->value;
        }
        case ASTNodeType::IndexedExpr: {
            auto idx = std::dynamic_pointer_cast<IndexedExpressionNode>(n);
            std::ostringstream oss;
            oss << ast_to_simple_string(idx->base_);
            oss << "[";
            for (size_t i = 0; i < idx->indices_.size(); ++i) {
                if (i != 0) oss << ",";
                oss << idx->indices_[i].name;
            }
            oss << "]";
            return oss.str();
        }
        case ASTNodeType::Derivative:
            return "d/d" + ast_to_simple_string(n->children[0]) + " " + ast_to_simple_string(n->children[1]);
        case ASTNodeType::Integral:
            return "integral(" + ast_to_simple_string(n->children[0]) + ")";
        default:
            return "?";
    }
}

inline void associate_trig_functions(std::shared_ptr<ASTNode>& n) {
    if (!n) return;
    for (auto &c : n->children)
        associate_trig_functions(c);

    if (n->type != ASTNodeType::BinaryOp || n->value != "*")
        return;

    for (size_t i = 0; i + 1 < n->children.size(); ++i) {
        auto powNode = n->children[i];
        auto argNode = n->children[i+1];

        if (powNode->type == ASTNodeType::BinaryOp && powNode->value == "^") {
            auto base = powNode->children[0];
            auto expn = powNode->children[1];

            if (expn->type == ASTNodeType::Number) {
                const auto& v = base->value;

                bool is_sin = (v == "sin"  || v == "\\sin");
                bool is_cos = (v == "cos"  || v == "\\cos");
                bool is_tan = (v == "tan"  || v == "\\tan");

                if ((is_sin || is_cos || is_tan) &&
                    (argNode->type == ASTNodeType::Symbol ||
                     argNode->type == ASTNodeType::TensorSymbol))
                {
                    auto call = std::make_shared<ASTNode>(
                        ASTNodeType::FunctionCall,
                        (v.front() == '\\' ? v.substr(1) : v),
                        std::vector<std::shared_ptr<ASTNode>>{argNode}
                    );
                    auto newPow = std::make_shared<ASTNode>(
                        ASTNodeType::BinaryOp,
                        "^",
                        std::vector<std::shared_ptr<ASTNode>>{call, expn}
                    );
                    n->children[i] = newPow;
                    n->children.erase(n->children.begin() + (i + 1));
                    associate_trig_functions(n);
                    return;
                }
            }
        }
    }
}
}

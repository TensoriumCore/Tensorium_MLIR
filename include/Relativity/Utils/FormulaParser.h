
#pragma once
#include <string>
#include <memory>
#include <vector>

namespace FormulaParser {

enum class NodeType { Number, Symbol, BinaryOp, UnaryOp, FunctionCall, TensorSymbol };

struct ASTNode {
    NodeType type;
    std::string value; 
    std::vector<std::shared_ptr<ASTNode>> children;
    ASTNode(NodeType t, const std::string& v) : type(t), value(v) {}
};

std::vector<std::string> tokenize(const std::string& expr);
std::shared_ptr<ASTNode> parse(const std::vector<std::string>& tokens);
std::shared_ptr<ASTNode> simplify(const std::shared_ptr<ASTNode>& root);
std::string ast_to_string(const std::shared_ptr<ASTNode>& node);
std::string simplify_formula(const std::string& expr);

} // namespace FormulaParser

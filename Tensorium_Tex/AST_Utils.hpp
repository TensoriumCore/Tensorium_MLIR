#pragma once

#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include <iostream>
#include <memory>
#include <string>

namespace tensorium {

inline void print_ast(const std::shared_ptr<ASTNode>& node, int indent = 0) {
    if (!node) return;

    std::string pad(indent, ' ');
    std::cout << pad
              << "Node: " << node->value
              << " [Type=" << static_cast<int>(node->type) << "]\n";

    // First: if this is a decorator (FunctionCall of \tilde, \hat, \bar),
    // print it and then its single child, then we're done.
    if (node->type == ASTNodeType::FunctionCall &&
        (node->value == "\\tilde" ||
         node->value == "\\hat"   ||
         node->value == "\\bar")) 
    {
        std::cout << pad << "  Decorator: " << node->value << "\n";
        // child 0 is the thing being decorated
        if (!node->children.empty())
            print_ast(node->children[0], indent + 2);
        return;
    }

    // Next: if it's an actual TensorSymbolNode, show its indices
    if (node->type == ASTNodeType::TensorSymbol) {
        auto tensorNode = 
            std::dynamic_pointer_cast<TensorSymbolNode>(node);
        if (tensorNode) {
            for (const auto& idx : tensorNode->indices) {
                std::cout << pad << "  Index: " << idx.name
                          << " (" 
                          << (idx.variance == IndexVariance::Covariant
                                  ? "covariant"
                                  : "contravariant")
                          << ")\n";
            }
        }
    }

    // Finally, recurse into any remaining children
    for (const auto& child : node->children) {
        print_ast(child, indent + 2);
    }
}

} // namespace tensorium


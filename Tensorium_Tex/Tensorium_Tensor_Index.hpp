#pragma once

#include <string>
#include <vector>
#include <memory>
#include "Tensorium_AST.hpp"

namespace tensorium {

    enum class IndexVariance {
        Covariant, 
        Contravariant 
    };

    struct Index {
        std::string name;
        IndexVariance variance;

        Index(const std::string& n, IndexVariance v)
            : name(n), variance(v) {}
    };

    struct TensorSymbolNode : ASTNode {
        std::vector<Index> indices;

        TensorSymbolNode(const std::string& name, const std::vector<Index>& idx)
            : ASTNode(ASTNodeType::TensorSymbol, name), indices(idx) {}
    };

}

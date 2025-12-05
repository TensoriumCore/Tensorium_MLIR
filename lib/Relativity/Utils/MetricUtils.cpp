#include "Relativity/Frontend/Tensorium_AST.hpp"
#include "Relativity/Frontend/Tensorium_Tensor_Index.hpp"
#include "Relativity/Utils/MetricExtract.hpp"
// #include "MetricExtract.hpp"
#include <algorithm>

void pretty_print_factor(const std::shared_ptr<tensorium::ASTNode> &node,
                         std::ostream &os) {
  if (!node) {
    os << "1";
    return;
  }
  using namespace tensorium;
  switch (node->type) {
  case tensorium::ASTNodeType::Number:
  case tensorium::ASTNodeType::Symbol:
    os << node->value;
    break;

  case tensorium::ASTNodeType::TensorSymbol: {
    auto sym = static_cast<TensorSymbolNode *>(node.get());
    os << sym->value;
    if (!sym->indices.empty()) {
      os << "^{" << sym->indices[0].name << "}";
    }
    break;
  }

  case tensorium::ASTNodeType::UnaryOp:
    if (node->value == "-") {
      os << "-";
      pretty_print_factor(node->children[0], os);
    } else {
      os << node->value;
      pretty_print_factor(node->children[0], os);
    }
    break;

  case tensorium::ASTNodeType::BinaryOp:
    if (node->value == "*") {
      pretty_print_factor(node->children[0], os);
      os << " ";
      pretty_print_factor(node->children[1], os);
    } else if (node->value == "/") {
      os << "\\frac{";
      pretty_print_factor(node->children[0], os);
      os << "}{";
      pretty_print_factor(node->children[1], os);
      os << "}";
    } else if (node->value == "^") {
      pretty_print_factor(node->children[0], os);
      os << "^{";
      pretty_print_factor(node->children[1], os);
      os << "}";
    } else if (node->value == "-") {
      pretty_print_factor(node->children[0], os);
      os << " - ";
      pretty_print_factor(node->children[1], os);
    } else if (node->value == "+") {
      pretty_print_factor(node->children[0], os);
      os << " + ";
      pretty_print_factor(node->children[1], os);
    } else {
      pretty_print_factor(node->children[0], os);
      os << node->value;
      pretty_print_factor(node->children[1], os);
    }
    break;

  default:
    os << "?";
    break;
  }
}

void flatten_sum(const std::shared_ptr<tensorium::ASTNode> &node,
                 std::vector<std::shared_ptr<tensorium::ASTNode>> &out,
                 int sign) {
  using namespace tensorium;
  if (!node)
    return;

  if (node->type == ASTNodeType::BinaryOp &&
      (node->value == "+" || node->value == "-")) {
    flatten_sum(node->children[0], out, sign);
    flatten_sum(node->children[1], out, (node->value == "+") ? sign : -sign);
  } else {
    if (sign == 1) {
      out.push_back(node);
    } else {
      auto minus = std::make_shared<ASTNode>(ASTNodeType::UnaryOp, "-");
      minus->children.push_back(node);
      out.push_back(minus);
    }
  }
}

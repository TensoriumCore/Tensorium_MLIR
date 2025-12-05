#include "Relativity/Utils/MetricExtract.hpp"
#include "Relativity/Frontend/Tensorium_AST.hpp"
#include "Relativity/Frontend/Tensorium_Tensor_Index.hpp"
#include <algorithm>
#include <map>
#include <unordered_map>

namespace tensorium {

using Node = std::shared_ptr<ASTNode>;

static std::string strip_backslash(std::string s) {
  if (!s.empty() && s[0] == '\\')
    s.erase(0, 1);
  return s;
}
static std::string diff_to_index(const std::string &s) {
  if (s.size() > 1 && s[0] == 'd')
    return strip_backslash(s[1] == '\\' ? s.substr(2) : s.substr(1));
  return strip_backslash(s);
}
static bool is_d_symbol(const Node &n, std::string &idx, int &pow) {
  if (n->type != ASTNodeType::TensorSymbol)
    return false;
  auto ts = static_cast<TensorSymbolNode *>(n.get());
  if (ts->value.size() <= 1 || ts->value[0] != 'd')
    return false;
  idx = diff_to_index(ts->value);
  pow = 1;
  if (!ts->indices.empty())
    try {
      pow = std::stoi(ts->indices[0].name);
    } catch (...) {
    }
  return true;
}

static Node add_coeff(Node a, Node b) {
  if (!a)
    return b;
  return std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "*",
                                   std::vector{a, b});
}

std::vector<MetricComponent>
merge_metric_components(const std::vector<MetricComponent> &in) {
  std::map<std::pair<std::string, std::string>, Node> merged;
  for (const auto &mc : in) {

    std::string i1 = mc.indices.first;
    std::string i2 = mc.indices.second;
    if (i1 > i2)
      std::swap(i1, i2);
    auto key = std::make_pair(i1, i2);
    if (merged.count(key)) {
      merged[key] =
          std::make_shared<ASTNode>(ASTNodeType::BinaryOp, "+",
                                    std::vector<Node>{merged[key], mc.factor});
    } else {
      merged[key] = mc.factor;
    }
  }
  std::vector<MetricComponent> out;
  for (const auto &[key, factor] : merged) {
    out.push_back({"g", {key.first, key.second}, factor, true});
  }
  return out;
}

std::vector<MetricComponent> extract_metric_terms(const Node &n, Node factor) {
  std::vector<MetricComponent> out;

  if (!n)
    return {};

  if (n->type == ASTNodeType::UnaryOp && n->value == "-") {
    auto sub = extract_metric_terms(n->children[0], factor);
    for (auto &mc : sub)
      mc.factor = std::make_shared<ASTNode>(ASTNodeType::UnaryOp, "-",
                                            std::vector{mc.factor});
    out.insert(out.end(), sub.begin(), sub.end());
    return merge_metric_components(out);
  }
  if (n->type == ASTNodeType::BinaryOp && n->value == "=")
    return extract_metric_terms(n->children[1], factor);

  if (n->type == ASTNodeType::BinaryOp && n->value == "+") {
    for (auto &c : n->children) {
      auto sub = extract_metric_terms(c, factor);
      out.insert(out.end(), sub.begin(), sub.end());
    }
    return merge_metric_components(out);
  }

  if (n->type == ASTNodeType::BinaryOp && n->value == "*") {
    std::vector<std::string> diff_indices;
    Node coeff = nullptr;

    for (auto &leaf : n->children) {
      std::string idx;
      int p;
      if (is_d_symbol(leaf, idx, p)) {
        for (int k = 0; k < p; ++k)
          diff_indices.push_back(idx);
        continue;
      }
      if (leaf->type == ASTNodeType::BinaryOp && leaf->value == "^" &&
          leaf->children[1]->type == ASTNodeType::Number &&
          leaf->children[0]->type == ASTNodeType::TensorSymbol) {
        int pow = std::stoi(leaf->children[1]->value);
        if (is_d_symbol(leaf->children[0], idx, p)) {
          for (int k = 0; k < pow * p; ++k)
            diff_indices.push_back(idx);
          continue;
        }
      }
      if (leaf->type == ASTNodeType::BinaryOp && leaf->value == "÷") {
        coeff = add_coeff(coeff, leaf);
        continue;
      }
      coeff = add_coeff(coeff, leaf);
    }

    if (diff_indices.size() == 1) {
      out.push_back({"g",
                     {diff_indices[0], diff_indices[0]},
                     coeff ? coeff : factor,
                     true});
    } else if (diff_indices.size() == 2) {
      std::string i1 = diff_indices[0], i2 = diff_indices[1];
      if (i1 > i2)
        std::swap(i1, i2);
      out.push_back({"g", {i1, i2}, coeff ? coeff : factor, true});
    } else if (diff_indices.size() > 2) {
      std::sort(diff_indices.begin(), diff_indices.end());
      for (size_t i = 0; i < diff_indices.size(); ++i) {
        for (size_t j = i; j < diff_indices.size(); ++j) {
          out.push_back({"g",
                         {diff_indices[i], diff_indices[j]},
                         coeff ? coeff : factor,
                         true});
        }
      }
    }
    return merge_metric_components(out);
  }
  if (n->type == ASTNodeType::BinaryOp && n->value == "^" &&
      n->children.size() == 2 && n->children[1]->type == ASTNodeType::Number &&
      n->children[1]->value == "2" &&
      n->children[0]->type == ASTNodeType::TensorSymbol) {
    std::string idx;
    int p;
    if (is_d_symbol(n->children[0], idx, p))
      return merge_metric_components({{"g", {idx, idx}, factor, true}});
  }

  for (auto &c : n->children) {
    auto sub = extract_metric_terms(c, factor);
    out.insert(out.end(), sub.begin(), sub.end());
  }
  return merge_metric_components(out);
}
} // namespace tensorium


#pragma once
#include "../Frontend/Tensorium_AST.hpp"
#include <memory>
#include <vector>
namespace tensorium {
struct MetricComponent {
  std::string variable;
  std::pair<std::string, std::string> indices;
  std::shared_ptr<ASTNode> factor;
  bool is_metric_component = true; 
};
std::vector<MetricComponent>
extract_metric_terms(const std::shared_ptr<ASTNode> &node,
                     std::shared_ptr<ASTNode> facteur = nullptr);
} // namespace tensorium
void pretty_print_factor(const std::shared_ptr<tensorium::ASTNode> &node,
                         std::ostream &os);
void flatten_sum(const std::shared_ptr<tensorium::ASTNode> &node,
                 std::vector<std::shared_ptr<tensorium::ASTNode>> &out,
                 int sign = 1);

#pragma once
#include "../Frontend/Tensorium_AST.hpp"
#include "../Utils/MetricExtract.hpp"
#include "MLIRBackend.hpp"
#include "Utils.hpp"
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
namespace Tensorium {
void generate_metric_tensor_mlir(
    const std::vector<std::shared_ptr<tensorium::ASTNode>> &all_asts);
void generate_lowered_mlir(
    const std::vector<std::shared_ptr<tensorium::ASTNode>> &all_asts);
std::string emit_metric_component_mlir(const std::string &funcName,
                                       const std::vector<std::string> &args,
                                       const std::string &indices,
                                       const std::string &formula,
                                       std::ostream &fout, int indent);
} // namespace Tensorium

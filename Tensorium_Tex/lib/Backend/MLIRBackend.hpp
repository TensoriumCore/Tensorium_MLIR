#pragma once
#include "Tensorium_backend.hpp"
#include <fstream>
#include <iostream>
#include <sstream>
#include <set>

namespace Tensorium {
class MLIRBackend : public Backend {
public:
  MLIRBackend(const std::string &outname = "output.mlir",
              const std::string &funcName = "main") 
      : outname(outname), funcName(funcName) {}
  void generate(const std::shared_ptr<tensorium::ASTNode> &root) override;

private:
  std::string outname;
  std::string funcName;
};

std::string to_ssa_name(const std::string& symbol);
void collect_symbols(const std::shared_ptr<tensorium::ASTNode> &node, std::set<std::string> &symbols);
std::string fresh_var();
}

#include "MLIRBackend.hpp"
#include "EmitDialect.hpp"
#include "Utils.hpp"
#include <fstream>
#include <set>
#include <unordered_map>

namespace Tensorium {

namespace {
std::unordered_map<std::string, std::string> symbol_vars;
}
std::string to_ssa_name(const std::string &symbol) {
  std::string ssa;
  for (char c : symbol) {
    if (std::isalnum(c) || c == '_')
      ssa += c;
    else
      ssa += '_';
  }
  if (!ssa.empty() && std::isdigit(ssa[0]))
    ssa = "_" + ssa;
  return ssa;
}

void collect_symbols(const std::shared_ptr<tensorium::ASTNode> &node,
                     std::set<std::string> &symbols) {
  using namespace tensorium;
  if (!node)
    return;
  if (node->type == ASTNodeType::Symbol ||
      node->type == ASTNodeType::TensorSymbol)
    symbols.insert(node->value);
  for (const auto &c : node->children)
    collect_symbols(c, symbols);
}

std::string emit_mlir(const std::shared_ptr<tensorium::ASTNode> &node,
                      std::ostream &fout, int indent = 2) {
  using namespace tensorium;
  std::string pad(indent, ' ');

  if (!node)
    return "%invalid";

  if (node->type == ASTNodeType::Number) {
    std::string val = node->value;
    if (val.find('.') == std::string::npos)
      val += ".0";
    std::string var = Tensorium::fresh_var();
    fout << pad << var << " = arith.constant " << val << " : f64\n";
    return var;
  }

  if (node->type == ASTNodeType::Symbol ||
      node->type == ASTNodeType::TensorSymbol) {
    auto it = symbol_vars.find(node->value);
    if (it != symbol_vars.end())
      return it->second;
    std::string ssa_name = to_ssa_name(node->value);
    std::string var = "%" + ssa_name;
    symbol_vars[node->value] = var;
    fout << pad << "// [UNEXPECTED] symbol: " << node->value << " as " << var
         << "\n";
    return var;
  }

  if (node->type == ASTNodeType::UnaryOp) {
    if (node->value == "-") {
      auto rhs = emit_mlir(node->children[0], fout, indent);
      std::string zero = Tensorium::fresh_var();
      fout << pad << zero << " = arith.constant 0.0 : f64\n";
      std::string var = Tensorium::fresh_var();
      fout << pad << var << " = arith.subf " << zero << ", " << rhs
           << " : f64\n";
      return var;
    }
    fout << pad << "// [TODO] unknown unary op: " << node->value << "\n";
    return "%invalid";
  }

  if (node->type == ASTNodeType::BinaryOp) {
    if (node->value == "=") {
      auto lhs = emit_mlir(node->children[0], fout, indent);
      auto rhs = emit_mlir(node->children[1], fout, indent);
      fout << pad << "// assignment: " << lhs << " = " << rhs << "\n";
      return lhs;
    }
    if (node->value == "^") {
      auto base = emit_mlir(node->children[0], fout, indent);
      auto exp = emit_mlir(node->children[1], fout, indent);
      std::string var = Tensorium::fresh_var();
      fout << pad << var << " = math.powf " << base << ", " << exp
           << " : f64\n";
      return var;
    }

    std::string op;
    if (node->value == "+")
      op = "arith.addf";
    else if (node->value == "-")
      op = "arith.subf";
    else if (node->value == "*" || node->value == "×")
      op = "arith.mulf";
    else if (node->value == "/" || node->value == "÷")
      op = "arith.divf";

    if (!op.empty()) {
      if (node->children.empty())
        return "%invalid";

      auto lhs = emit_mlir(node->children[0], fout, indent);

      for (size_t i = 1; i < node->children.size(); ++i) {
        auto rhs = emit_mlir(node->children[i], fout, indent);
        std::string var = Tensorium::fresh_var();

        fout << pad << var << " = " << op << " " << lhs << ", " << rhs
             << " : f64\n";

        lhs = var;
      }
      return lhs;
    }

    fout << pad << "// [TODO] unknown binary op: " << node->value << "\n";
    return "%invalid";
  }
  if (node->type == ASTNodeType::FunctionCall) {
    if (node->children.empty())
      return "%invalid";

    auto arg = emit_mlir(node->children[0], fout, indent);

    std::string func_name = node->value;
    if (!func_name.empty() && func_name[0] == '\\')
      func_name.erase(0, 1);

    std::string op;
    if (func_name == "sin")
      op = "math.sin";
    else if (func_name == "cos")
      op = "math.cos";
    else if (func_name == "tan")
      op = "math.tan";
    else if (func_name == "exp")
      op = "math.exp";
    else if (func_name == "log" || func_name == "ln")
      op = "math.log";
    else if (func_name == "sqrt")
      op = "math.sqrt";
    else {
      fout << pad << "// [TODO] unknown function: " << func_name << "\n";
      return "%invalid";
    }

    std::string var = Tensorium::fresh_var();
    fout << pad << var << " = " << op << " " << arg << " : f64\n";
    return var;
  }
  if (node->type == ASTNodeType::Derivative) {
    fout << pad << "// partial derivative: " << node->value << "\n";
    for (const auto &c : node->children)
      emit_mlir(c, fout, indent + 2);
    return "%deriv";
  }

  if (node->type == ASTNodeType::Decorator) {
    fout << pad << "// decorator: " << node->value << "\n";
    for (const auto &c : node->children)
      emit_mlir(c, fout, indent + 2);
    return "%decor";
  }

  fout << pad << "// unknown AST node type: " << to_string(node->type) << "\n";
  return "%invalid";
}

void MLIRBackend::generate(const std::shared_ptr<tensorium::ASTNode> &root) {
  std::set<std::string> symbols;
  collect_symbols(root, symbols);

  std::ofstream fout(outname, std::ios::app);

  fout << "func.func @" << funcName << "(";
  bool first = true;
  std::unordered_map<std::string, std::string> symbol_argnames;

  for (const auto &sym : symbols) {
    std::string ssa = to_ssa_name(sym);
    if (!first)
      fout << ", ";
    fout << "%" << ssa << ": f64";
    symbol_argnames[sym] = "%" + ssa;
    first = false;
  }
  fout << ") -> f64 {\n";

  symbol_vars = symbol_argnames;
  Tensorium::reset_temp_counter();

  std::string result_var = emit_mlir(root, fout, 2);

  if (result_var == "%invalid" || result_var.empty()) {
    fout << "  %ret_zero = arith.constant 0.0 : f64\n";
    fout << "  return %ret_zero : f64\n";
  } else {
    fout << "  return " << result_var << " : f64\n";
  }

  fout << "}\n\n";
  fout.close();
}

} // namespace Tensorium

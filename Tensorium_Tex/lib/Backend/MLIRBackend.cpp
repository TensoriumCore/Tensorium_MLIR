#include "MLIRBackend.hpp"
#include "EmitDialect.hpp"
#include <fstream>
#include <unordered_map>
#include <set>
#include "Utils.hpp"

namespace Tensorium {

namespace {
std::unordered_map<std::string, std::string> symbol_vars;
}
std::string to_ssa_name(const std::string& symbol) {
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

void collect_symbols(const std::shared_ptr<tensorium::ASTNode> &node, std::set<std::string> &symbols) {
	using namespace tensorium;
	if (!node) return;
	if (node->type == ASTNodeType::Symbol || node->type == ASTNodeType::TensorSymbol)
		symbols.insert(node->value);
	for (const auto& c : node->children)
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

	if (node->type == ASTNodeType::Symbol || node->type == ASTNodeType::TensorSymbol) {
		auto it = symbol_vars.find(node->value);
		if (it != symbol_vars.end())
			return it->second;
		std::string ssa_name = to_ssa_name(node->value);
		std::string var = "%" + ssa_name;
		symbol_vars[node->value] = var;
		fout << pad << "// [UNEXPECTED] symbol: " << node->value << " as " << var << "\n";
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
			fout << pad << var << " = math.powf " << base << ", " << exp << " : f64\n";
			return var;
		}

		std::string op;
		if (node->value == "+" || node->value == "-" ||
				node->value == "*" || node->value == "/" || node->value == "÷") {
			auto left = emit_mlir(node->children[0], fout, indent);
			auto right = emit_mlir(node->children[1], fout, indent);
			std::string var = Tensorium::fresh_var();
			if (node->value == "+") op = "arith.addf";
			else if (node->value == "-") op = "arith.subf";
			else if (node->value == "*") op = "arith.mulf";
			else if (node->value == "/" || node->value == "÷") op = "arith.divf";
			fout << pad << var << " = " << op << " " << left << ", " << right << " : f64\n";
			return var;
		}
		fout << pad << "// [TODO] unknown binary op: " << node->value << "\n";
		return "%invalid";
	}

	if (node->type == ASTNodeType::Derivative) {
		fout << pad << "// partial derivative: " << node->value << "\n";
		for (const auto& c : node->children)
			emit_mlir(c, fout, indent + 2);
		return "%deriv";
	}

	if (node->type == ASTNodeType::Decorator) {
		fout << pad << "// decorator: " << node->value << "\n";
		for (const auto& c : node->children)
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
    for (const auto& sym : symbols) {
        std::string ssa = to_ssa_name(sym);
        if (!first) fout << ", ";
        fout << "%" << ssa << ": f64";
        symbol_argnames[sym] = "%" + ssa;
        first = false;
    }
    fout << ") {\n";

    symbol_vars = symbol_argnames;   
	   Tensorium::reset_temp_counter();
    emit_mlir(root, fout, 2);
    fout << "  return\n}\n\n";
    fout.close();
}

} // namespace Tensorium

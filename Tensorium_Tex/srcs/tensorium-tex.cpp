#include "../lib/Backend/MLIRBackend.hpp"
#include "../lib/Backend/PrintBackend.hpp"
#include "../lib/Backend/Tensorium_backend.hpp"
#include "../lib/Frontend/AST_Utils.hpp"
#include "../lib/Frontend/FlattenOps.hpp"
#include "../lib/Frontend/Tensorium_AST.hpp"
#include "../lib/Frontend/Tensorium_Tensor_Index.hpp"
#include "../lib/Frontend/Tensorium_Tex.hpp"
#include "../lib/Utils/MetricExtract.hpp"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <memory>
#include <string>
#include <map>
#include <vector>
#include <sstream>
#include <set>
using namespace tensorium;

namespace tensorium {
    using Node = std::shared_ptr<ASTNode>;
}


void generate_lowered_mlir(const std::vector<std::shared_ptr<tensorium::ASTNode>>& all_asts) {
    for (const auto& root : all_asts) {
        std::vector<std::shared_ptr<tensorium::ASTNode>> terms;
        flatten_sum(root, terms);
        if (terms.empty()) terms.push_back(root);

        std::map<std::pair<std::string, std::string>, tensorium::Node> fusion;
        std::vector<tensorium::MetricComponent> all_components;
        for (const auto& term : terms) {
            auto comps = tensorium::extract_metric_terms(term);
            for (const auto& c : comps)
                if (c.is_metric_component)
                    all_components.push_back(c);
        }
        for (const auto& c : all_components) {
            std::string i1 = c.indices.first, i2 = c.indices.second;
            if (i1 > i2) std::swap(i1, i2);
            auto key = std::make_pair(i1, i2);
            if (fusion.count(key)) {
                fusion[key] = std::make_shared<tensorium::ASTNode>(
                    tensorium::ASTNodeType::BinaryOp, "+", std::vector<tensorium::Node>{fusion[key], c.factor});
            } else {
                fusion[key] = c.factor;
            }
        }

		for (const auto& kv : fusion) {
			std::string i1 = kv.first.first, i2 = kv.first.second;
			std::string func_name = "g_" + i1 + i2;
			Tensorium::MLIRBackend mlir_backend("output.mlir", func_name);
			mlir_backend.generate(kv.second);
		}

	}
}

void generate_dialect_mlir(const std::vector<std::shared_ptr<tensorium::ASTNode>>& all_asts) {
	std::ofstream fout_symbolic("output_symbolic.mlir", std::ios::trunc);
	for (const auto& root : all_asts) {
		std::vector<std::shared_ptr<tensorium::ASTNode>> terms;
		flatten_sum(root, terms);
		if (terms.empty()) terms.push_back(root);

		std::map<std::pair<std::string, std::string>, tensorium::Node> fusion;
		std::vector<tensorium::MetricComponent> all_components;
		for (const auto& term : terms) {
			auto comps = tensorium::extract_metric_terms(term);
			for (const auto& c : comps)
				if (c.is_metric_component)
					all_components.push_back(c);
		}
		for (const auto& c : all_components) {
			std::string i1 = c.indices.first, i2 = c.indices.second;
			if (i1 > i2) std::swap(i1, i2);
            auto key = std::make_pair(i1, i2);
            if (fusion.count(key)) {
                fusion[key] = std::make_shared<tensorium::ASTNode>(
                    tensorium::ASTNodeType::BinaryOp, "+", std::vector<tensorium::Node>{fusion[key], c.factor});
            } else {
                fusion[key] = c.factor;
            }
        }
        for (const auto& kv : fusion) {
            std::string i1 = kv.first.first, i2 = kv.first.second;
            auto mlirify = [](const std::string& idx) {
                std::string out;
                for (char c : idx) {
                    if (std::isalnum(c)) out += c;
                    else out += '_';
                }
                return out;
            };
            std::string func_name = "g_" + mlirify(i1) + mlirify(i2);

            std::set<std::string> symbols;
            Tensorium::collect_symbols(kv.second, symbols);
            std::vector<std::string> args;
            for (const auto& sym : symbols)
                args.push_back("%" + Tensorium::to_ssa_name(sym));

            std::string indices = "\"" + i1 + "\", \"" + i2 + "\"";
            std::ostringstream oss;
            pretty_print_factor(kv.second, oss);
            std::string formula = oss.str();
            formula.erase(std::remove(formula.begin(), formula.end(), '\\'), formula.end());

            fout_symbolic << "func.func @" << func_name << "(";
            for (size_t i = 0; i < args.size(); ++i) {
                if (i != 0) fout_symbolic << ", ";
                fout_symbolic << args[i] << ": f64";
            }
            fout_symbolic << ") -> f64 {\n";
            std::string result_var = Tensorium::emit_metric_component_mlir(func_name, args, indices, formula, fout_symbolic, 2);
            fout_symbolic << "  return " << result_var << " : f64\n}\n\n";
        }
    }
    fout_symbolic.close();
}
int main(int argc, char *argv[]) {
    std::string mode = "--mlir";
    std::string input_file;

    // Parse options
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--mlir" || arg == "--lowered")
            mode = "--mlir";
        else if (arg == "--dialect")
            mode = "--dialect";
        else if (!arg.empty() && arg[0] != '-')
            input_file = arg;
    }

    if (input_file.empty()) {
        std::cerr << "Usage: " << argv[0] << " [--mlir|--dialect] <input.tex>\n";
        return 1;
    }

    std::ifstream file(input_file);
    if (!file) {
        std::cerr << "Error: can't open file " << input_file << "\n";
        return 1;
    }
    std::string input;
    std::getline(file, input, '\0');

    std::vector<std::string> blocks = extract_math_blocks(input);
    for (auto &math : blocks) {
        math.erase(std::remove(math.begin(), math.end(), '&'), math.end());
        size_t start = math.find_first_not_of(" \t\n\r");
        size_t finish = math.find_last_not_of(" \t\n\r");
        if (start != std::string::npos && finish != std::string::npos)
            math = math.substr(start, finish - start + 1);
    }

    std::vector<std::shared_ptr<tensorium::ASTNode>> all_asts;
    for (const auto &math : blocks) {
        Lexer lexer(math);
        std::vector<Token> tokens = lexer.tokenize();
        Parser parser(tokens);
        auto asts = parser.parse_statements();
        FlattenMul fm;
        for (auto &r : asts)
            r = fm.run(r);
        for (const auto &root : asts)
            all_asts.push_back(root);
    }

    if (mode == "--mlir")
        generate_lowered_mlir(all_asts);
    else if (mode == "--dialect")
        generate_dialect_mlir(all_asts);
    else {
        std::cerr << "Unknown mode: " << mode << "\n";
        return 2;
    }
    return 0;
}

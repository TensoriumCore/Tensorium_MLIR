#include "../lib/Backend/MLIRBackend.hpp"
#include "../lib/Backend/PrintBackend.hpp"
#include "../lib/Backend/Tensorium_backend.hpp"
#include "../lib/Frontend/AST_Utils.hpp"
#include "../lib/Frontend/FlattenOps.hpp"
#include "../lib/Frontend/Tensorium_AST.hpp"
#include "../lib/Frontend/Tensorium_Tensor_Index.hpp"
#include "../lib/Frontend/Tensorium_Tex.hpp"
#include "../lib/Utils/MetricExtract.hpp"
#include "../lib/Backend/EmitDialect.hpp"
#include "../lib/Frontend/Tensorim_simplify.hpp"
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

int main(int argc, char *argv[]) {
    std::string mode = "--mlir";
    std::string input_file;

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
	for (char &c : input) 
		std::cout << c;
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
		std::cerr << "=== DUMP des tokens pour la formule: `" << math << "` ===\n";
		for (auto &t : tokens) {
			std::cerr << token_type_name(t.type) << " : `" << t.value << "`\n";
		}
		std::cerr << "========================================\n";
		Parser parser(tokens);
		auto asts = parser.parse_statements();
		FlattenMul fm;
		
		for (auto &root : asts) {
			root = fm.run(root);
			associate_trig_functions(root);
			print_ast(root);
			std::cout << "Simplified: " << ast_to_simple_string(root) << "\n";
			all_asts.push_back(root);
		}
	}


	if (mode == "--mlir")
		Tensorium::generate_lowered_mlir(all_asts);
	else if (mode == "--dialect")
		Tensorium::generate_metric_tensor_mlir(all_asts);
	else {
		std::cerr << "Unknown mode: " << mode << "\n";
		return 2;
	}
	return 0;
}

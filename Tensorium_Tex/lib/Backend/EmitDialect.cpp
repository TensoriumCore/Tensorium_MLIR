#include "EmitDialect.hpp"
namespace tensorium {
    using Node = std::shared_ptr<ASTNode>;
}
namespace Tensorium {
	std::string emit_metric_component_mlir(
			const std::string& funcName,
			const std::vector<std::string>& args,
			const std::string& indices,
			const std::string& formula,
			std::ostream& fout,
			int indent = 2)
	{
		(void)funcName;
		std::string pad(indent, ' ');
		std::string var = fresh_var();

		fout << pad << var << " = relativity.metric_component";
		for (const auto& a : args) fout << " " << a << ",";
		if (!args.empty()) fout.seekp(-1, std::ios_base::cur);

		fout << " {indices = [" << indices << "], formula = \"" << formula << "\"}";
		fout << " : ";
		for (size_t i=0; i < args.size(); ++i) fout << "f64, ";
		if (!args.empty()) fout.seekp(-2, std::ios_base::cur);
		fout << " -> f64\n";
		return var;
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
} // namespace Tensorium

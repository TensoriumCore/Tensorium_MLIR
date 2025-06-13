#include <iostream>
#include <fstream>
#include <vector>
#include "Tensorium_Tex.hpp"
#include "Tensorium_AST.hpp"
#include "Tensorium_Tensor_Index.hpp"
#include "AST_Utils.hpp"

using namespace tensorium;

// Optionnel : mapping lisible des TokenType
std::string token_type_name(TokenType type) {
switch (type) {
    case TokenType::plus: return "plus";
    case TokenType::minus: return "minus";
    case TokenType::mult: return "mult";
    case TokenType::div: return "div";       // <-- plus de conflit ici
    case TokenType::pow: return "pow";
    case TokenType::lpar: return "lpar";
    case TokenType::rpar: return "rpar";
    case TokenType::lbrace: return "lbrace";
    case TokenType::rbrace: return "rbrace";
    case TokenType::symbol: return "symbol";
    case TokenType::integer: return "integer";
    case TokenType::real: return "real";
    case TokenType::derivative: return "derivative";
    case TokenType::partial: return "partial";
    case TokenType::integral: return "integral";
    case TokenType::covariant: return "covariant";
    case TokenType::contravariant: return "contravariant";
    case TokenType::transpose: return "transpose";
    case TokenType::inner: return "inner";
    case TokenType::outer: return "outer";
    case TokenType::end: return "end";
    case TokenType::unknown: return "unknown";
    default: return "???";

    }
}

int main(int argc, char* argv[]) {
    std::string input;

    if (argc > 1) {
        std::ifstream file(argv[1]);
        if (!file) {
            std::cerr << "Erreur : impossible d’ouvrir " << argv[1] << "\n";
            return 1;
        }
        std::getline(file, input, '\0');
    } else {
        input = "\\Gamma^{k}_{ij} + R_{mn}";
    }

    std::cout << "=== Input ===\n" << input << "\n\n";

    Lexer lexer(input);
    std::vector<Token> tokens = lexer.tokenize();

    std::cout << "=== Tokens ===" << std::endl;
    for (const auto& tok : tokens) {
        std::cout << "Token: \"" << tok.value << "\" [Type=" << token_type_name(tok.type) << "]\n";
    }

    Parser parser(tokens);
    auto root = parser.parse_expression();

    std::cout << "\n=== AST ===" << std::endl;
    if (!root) {
        std::cerr << "Erreur : parsing invalide.\n";
        return 1;
    }

    print_ast(root);

    return 0;
}

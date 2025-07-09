#include "../Frontend/AST_Utils.hpp" // si print_ast est ici
#include "PrintBackend.hpp"

namespace Tensorium {

void PrintBackend::generate(const std::shared_ptr<tensorium::ASTNode> &root) {
  print_ast(root);
}
} // namespace Tensorium

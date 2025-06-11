#include "Relativity/Dialect.h"
#include "mlir/IR/Builders.h"

using namespace mlir;

Value convertASTToMLIR(Operation* op, ASTNode* node, OpBuilder &builder) {
  // Implémentation basique
  if (auto* tensor = dynamic_cast<TensorNode*>(node)) {
    return builder.create<relativity::TensorOp>(
        op->getLoc(), 
        builder.getStringAttr(tensor->name)
    );
  }
  // TODO: Ajouter la gestion des dérivées
  return Value();
}

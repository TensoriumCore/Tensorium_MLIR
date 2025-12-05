#include "Relativity/Frontend/AST_Utils.hpp"
#include "Relativity/Frontend/FlattenOps.hpp"
#include "Relativity/Frontend/Tensorim_simplify.hpp"
#include "Relativity/Frontend/Tensorium_Tex.hpp"
#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOps.h"
#include "Relativity/Utils/MetricExtract.hpp"

// INCLUDES CORRIGÉS
#include "mlir/Dialect/Func/IR/FuncOps.h" // INDISPENSABLE pour func::FuncOp
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Types.h"
#include "mlir/Support/FileUtilities.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"

#include <algorithm>
#include <fstream>
#include <iostream>

using namespace mlir;
using namespace tensorium;

int main(int argc, char **argv) {
  llvm::InitLLVM y(argc, argv);

  llvm::cl::opt<std::string> inputFilename(llvm::cl::Positional,
                                           llvm::cl::desc("<input latex file>"),
                                           llvm::cl::Required);
  llvm::cl::ParseCommandLineOptions(argc, argv, "Tensorium LaTeX Compiler\n");

  std::string errorMessage;
  std::unique_ptr<llvm::MemoryBuffer> file =
      mlir::openInputFile(inputFilename, &errorMessage);
  if (!file) {
    llvm::errs() << errorMessage << "\n";
    return 1;
  }
  std::string input = file->getBuffer().str();

  std::vector<std::string> blocks = extract_math_blocks(input);
  for (auto &math : blocks) {
    math.erase(std::remove(math.begin(), math.end(), '&'), math.end());
  }

  std::vector<std::shared_ptr<ASTNode>> parsed_asts;
  for (const auto &math : blocks) {
    Lexer lexer(math);
    Parser parser(lexer.tokenize());
    auto asts = parser.parse_statements();
    FlattenMul fm;
    for (auto &root : asts) {
      root = fm.run(root);
      associate_trig_functions(root);
      parsed_asts.push_back(root);
    }
  }

  std::map<std::pair<std::string, std::string>, std::shared_ptr<ASTNode>>
      fusion;
  for (const auto &root : parsed_asts) {
    std::vector<std::shared_ptr<ASTNode>> terms;
    flatten_sum(root, terms);
    if (terms.empty())
      terms.push_back(root);

    for (const auto &term : terms) {
      auto comps = extract_metric_terms(term);
      for (const auto &c : comps) {
        if (c.is_metric_component) {
          std::string i1 = c.indices.first;
          std::string i2 = c.indices.second;
          if (i1 > i2)
            std::swap(i1, i2);
          auto key = std::make_pair(i1, i2);
          if (fusion.count(key)) {
            fusion[key] = std::make_shared<ASTNode>(
                ASTNodeType::BinaryOp, "+",
                std::vector<std::shared_ptr<ASTNode>>{fusion[key], c.factor});
          } else {
            fusion[key] = c.factor;
          }
        }
      }
    }
  }

  MLIRContext context;
  context.getOrLoadDialect<relativity::RelativityDialect>();
  context.getOrLoadDialect<func::FuncDialect>(); 

  OpBuilder builder(&context);
  ModuleOp module = ModuleOp::create(builder.getUnknownLoc());
  builder.setInsertionPointToStart(module.getBody());

  SmallVector<Type, 5> argTypes(5, builder.getF64Type());
  auto tensorType4x4 = RankedTensorType::get({4, 4}, builder.getF64Type());
  auto funcType = builder.getFunctionType(argTypes, tensorType4x4);

  auto funcOp = builder.create<func::FuncOp>(builder.getUnknownLoc(),
                                             "metric_tensor", funcType);
  Block *entryBlock = funcOp.addEntryBlock();
  builder.setInsertionPointToStart(entryBlock);

  SmallVector<Value> components;
  for (auto const &[indices, ast] : fusion) {
    std::string formula = ast_to_simple_string(ast);
    formula.erase(std::remove(formula.begin(), formula.end(), '\\'),
                  formula.end());

    auto componentOp = builder.create<relativity::MetricComponentOp>(
        builder.getUnknownLoc(),
        builder.getF64Type(),      // Result Type
        entryBlock->getArguments() // Operands (Variadic vars)
    );
    componentOp->setAttr(
        "indices", builder.getStrArrayAttr({indices.first, indices.second}));
    componentOp->setAttr("formula", builder.getStringAttr(formula));

    components.push_back(componentOp);
  }

  auto tensorOp = builder.create<relativity::MetricTensorOp>(
      builder.getUnknownLoc(), tensorType4x4, components);

  builder.create<func::ReturnOp>(builder.getUnknownLoc(), tensorOp.getResult());

  module.print(llvm::outs());

  return 0;
}

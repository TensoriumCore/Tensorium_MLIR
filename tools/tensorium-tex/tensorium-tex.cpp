#include "Relativity/AssembleMetricTensorPass.h"
#include "Relativity/Frontend/AST_Utils.hpp"
#include "Relativity/Frontend/FlattenOps.hpp"
#include "Relativity/Frontend/Tensorim_simplify.hpp"
#include "Relativity/Frontend/Tensorium_Tex.hpp"
#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityLoweringPass.h"
#include "Relativity/RelativityOps.h"
#include "Relativity/Utils/MetricExtract.hpp"
#include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
#include "mlir/Conversion/ControlFlowToLLVM/ControlFlowToLLVM.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVM.h"
#include "mlir/Conversion/MathToLLVM/MathToLLVM.h"
#include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
#include "mlir/Conversion/Passes.h"
#include "mlir/Conversion/ReconcileUnrealizedCasts/ReconcileUnrealizedCasts.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlow.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Target/LLVMIR/Dialect/All.h"
#include "mlir/Target/LLVMIR/ModuleTranslation.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"
#include <algorithm>
#include <fstream>
#include <iostream>

using namespace mlir;
using namespace tensorium;

static int mapIndex(const std::string &s) {
  if (s == "t")
    return 0;
  if (s == "r")
    return 1;
  if (s == "θ" || s == "th" || s == "theta")
    return 2;
  if (s == "φ" || s == "phi")
    return 3;

  try {
    return std::stoi(s);
  } catch (...) {
  }
  throw std::invalid_argument("Invalid tensor index: " + s);
}

int main(int argc, char **argv) {
  llvm::InitLLVM y(argc, argv);

  DialectRegistry registry;
  registry.insert<relativity::RelativityDialect>();
  registry.insert<func::FuncDialect>();
  registry.insert<arith::ArithDialect>();
  registry.insert<math::MathDialect>();
  registry.insert<LLVM::LLVMDialect>();
  registry.insert<cf::ControlFlowDialect>();
  registry.insert<memref::MemRefDialect>();
  mlir::registerAllToLLVMIRTranslations(registry);

  MLIRContext context(registry);
  context.loadAllAvailableDialects();

  llvm::cl::opt<std::string> inputFilename(llvm::cl::Positional,
                                           llvm::cl::desc("<input latex file>"),
                                           llvm::cl::Required);
  llvm::cl::opt<bool> emitRelativity("emit-relativity",
                                     llvm::cl::desc("Dump relativity IR"),
                                     llvm::cl::init(false));
  llvm::cl::opt<bool> emitLLVM("emit-llvm-dialect",
                               llvm::cl::desc("Dump LLVM dialect"),
                               llvm::cl::init(false));

  llvm::cl::ParseCommandLineOptions(argc, argv, "Tensorium Compiler\n");

  auto fileOrErr = llvm::MemoryBuffer::getFileOrSTDIN(inputFilename);
  if (!fileOrErr)
    return 1;
  auto &buffer = *fileOrErr;
  std::string input = buffer->getBuffer().str();

  std::vector<std::string> blocks = extract_math_blocks(input);
  for (auto &math : blocks)
    math.erase(std::remove(math.begin(), math.end(), '&'), math.end());

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
        if (!c.is_metric_component)
          continue;
        std::string i1 = c.indices.first, i2 = c.indices.second;
        if (i1 > i2)
          std::swap(i1, i2);
        auto key = std::make_pair(i1, i2);
        if (fusion.count(key))
          fusion[key] = std::make_shared<ASTNode>(
              ASTNodeType::BinaryOp, "+", std::vector{fusion[key], c.factor});
        else
          fusion[key] = c.factor;
      }
    }
  }

  OpBuilder builder(&context);
  ModuleOp module = ModuleOp::create(builder.getUnknownLoc());

  SmallVector<Type> argTypes(5, builder.getF64Type());
  auto memType = MemRefType::get({4, 4}, builder.getF64Type());
  argTypes.push_back(memType);

  auto funcType = builder.getFunctionType(argTypes, {});
  auto funcOp = builder.create<func::FuncOp>(builder.getUnknownLoc(),
                                             "metric_tensor", funcType);
  funcOp.setPublic();
  funcOp->setAttr("llvm.emit_c_interface", UnitAttr::get(&context));

  Block *entry = funcOp.addEntryBlock();
  builder.setInsertionPointToStart(entry);

  Value outBuf = entry->getArguments().back();
  for (auto const &[indices, ast] : fusion) {
    std::string formula = ast_to_simple_string(ast);
    formula.erase(std::remove(formula.begin(), formula.end(), '\\'),
                  formula.end());
    auto componentOp = builder.create<relativity::MetricComponentOp>(
        builder.getUnknownLoc(), builder.getF64Type(),
        entry->getArguments().drop_back());
    componentOp->setAttr(
        "indices", builder.getStrArrayAttr({indices.first, indices.second}));
    componentOp->setAttr("formula", builder.getStringAttr(formula));

    auto idxI = builder.create<arith::ConstantOp>(
        builder.getUnknownLoc(), builder.getIndexAttr(mapIndex(indices.first)));
    auto idxJ = builder.create<arith::ConstantOp>(
        builder.getUnknownLoc(),
        builder.getIndexAttr(mapIndex(indices.second)));

    builder.create<memref::StoreOp>(builder.getUnknownLoc(), componentOp,
                                    outBuf, ValueRange{idxI, idxJ});
  }

  builder.create<func::ReturnOp>(builder.getUnknownLoc());
  module.push_back(funcOp);

  if (emitRelativity) {
    module.print(llvm::outs());
    return 0;
  }

  PassManager pm(&context);
  pm.addPass(mlir::relativity::createLowerRelativityPass());
  pm.addPass(createCanonicalizerPass());
  pm.addPass(createCSEPass());
  pm.addPass(mlir::relativity::createAssembleMetricTensorPass());
  pm.addPass(createConvertMathToLLVMPass());
  pm.addPass(createArithToLLVMConversionPass());
  pm.addPass(createConvertControlFlowToLLVMPass());
  pm.addPass(createFinalizeMemRefToLLVMConversionPass());
  pm.addPass(createConvertFuncToLLVMPass());
  pm.addPass(createReconcileUnrealizedCastsPass());

  if (failed(pm.run(module)))
    return 1;

  if (emitLLVM) {
    module.print(llvm::outs());
    return 0;
  }

  llvm::LLVMContext llvmContext;
  auto llvmModule = mlir::translateModuleToLLVMIR(module, llvmContext);
  if (!llvmModule)
    return 1;

  llvmModule->print(llvm::outs(), nullptr);
  return 0;
}

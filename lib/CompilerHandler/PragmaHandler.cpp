#include "PragmaHandler.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/ASTContext.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/DiagnosticLex.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
using namespace clang;
using namespace llvm;

void TensoriumPragmaHandler::HandlePragma(Preprocessor &PP,
                                          PragmaIntroducer Introducer,
                                          Token &Tok) {
  SourceLocation Loc = Tok.getLocation();
  std::string TargetName;

  llvm::errs() << "[TensoriumPragmaHandler] Called pragma handler\n";
  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier) ||
      Tok.getIdentifierInfo()->getName() != "target") {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_message)
        << "expected identifier 'target' after '#pragma tensorium'";
    return;
  }

  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(Tok.getLocation(), diag::err_expected_after) << "'target'" << "'('";
    return;
  }

  PP.Lex(Tok);
  if (Tok.is(tok::string_literal) || Tok.is(tok::identifier)) {
    SmallString<64> StrBuf;
    bool Invalid = false;
    TargetName = PP.getSpelling(Tok, &Invalid);
    if (Invalid) {
      PP.Diag(Tok.getLocation(), diag::err_expected_string_literal);
      return;
    }
  } else {
    PP.Diag(Tok.getLocation(), diag::err_expected_string_literal);
    return;
  }

  PP.Lex(Tok);
  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(Tok.getLocation(), diag::err_expected_after) << "target" << "')'";
    return;
  }

  errs() << "[TensoriumPragma] backend target: " << TargetName << "\n";

  std::string Injected = "// Injected by #pragma tensorium target\n";
  Injected += "#define TENSORIUM_TARGET_" + TargetName + "\n";

  pushBuffer(PP, Injected, "<tensorium-pragma>");
  PP.Lex(Tok); 
  while (Tok.isNot(tok::eod) && Tok.isNot(tok::eof))
    PP.Lex(Tok);
}

class TensoriumPluginAction : public clang::PluginASTAction {
protected:
  bool ParseArgs(const CompilerInstance &,
                 const std::vector<std::string> &) override {
    return true;
  }

  std::unique_ptr<ASTConsumer> CreateASTConsumer(CompilerInstance &CI,
                                                 llvm::StringRef) override {
    CI.getPreprocessor().AddPragmaHandler(new TensoriumPragmaHandler);
    return std::make_unique<clang::ASTConsumer>(); // ou ton consumer
                                                   // personnalisé
  }
};

static clang::FrontendPluginRegistry::Add<TensoriumPluginAction>
    X("tensorium-dispatch", "Handle #pragma tensorium directives");

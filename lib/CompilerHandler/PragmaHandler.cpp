#include "PragmaHandler.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "clang/Lex/Lexer.h"
#include "llvm/ADT/StringSet.h"
#include <iostream>

using namespace clang;

std::vector<PragmaSite> pragmaSites;

TensoriumPragmaHandler::TensoriumPragmaHandler() : PragmaHandler("tensorium") {}

void TensoriumPragmaHandler::HandlePragma(Preprocessor &PP, PragmaIntroducer, Token &Tok) {
    PP.Lex(Tok);
    if (Tok.isNot(tok::identifier) || Tok.getIdentifierInfo()->getName() != "target")
        return;
    PP.Lex(Tok);
    if (Tok.isNot(tok::l_paren)) return;
    PP.Lex(Tok);
    std::string target;
    if (Tok.is(tok::string_literal) || Tok.is(tok::identifier)) {
        bool Invalid = false;
        target = PP.getSpelling(Tok, &Invalid);
        if (!target.empty() && target.front() == '"')
            target = target.substr(1, target.size() - 2);
    } else return;
    PP.Lex(Tok);
    if (Tok.isNot(tok::r_paren)) return;
    SourceLocation where = Tok.getLocation();
    pragmaSites.push_back({target, where});
    llvm::errs() << "[TensoriumPragma] stored pragma at "
                 << where.printToString(PP.getSourceManager())
                 << " target=" << target << "\n";
}

class TensoriumVisitor : public RecursiveASTVisitor<TensoriumVisitor> {
    ASTContext *Context;
    Rewriter &RW;
public:
    TensoriumVisitor(ASTContext *Ctx, Rewriter &R) : Context(Ctx), RW(R) {}

    bool VisitCallExpr(CallExpr *CE) {
        SourceManager &SM = Context->getSourceManager();
        SourceLocation callLoc = CE->getBeginLoc();
        for (auto it = pragmaSites.rbegin(); it != pragmaSites.rend(); ++it) {
            if (SM.isBeforeInTranslationUnit(it->location, callLoc)) {
                std::string oldCall = std::string(Lexer::getSourceText(
                    CharSourceRange::getTokenRange(CE->getSourceRange()),
                    SM, Context->getLangOpts()));
                std::string injected = "TENSORIUM_DISPATCH(\"" + it->target + "\", " + oldCall + ")";
                RW.ReplaceText(CE->getSourceRange(), injected);
                llvm::errs() << "[Tensorium] replaced call at "
                             << callLoc.printToString(SM) << " by: " << injected << "\n";
                break;
            }
        }
        return true;
    }
};

class TensoriumConsumer : public ASTConsumer {
    Rewriter RW;
public:
    void Initialize(ASTContext &Ctx) override { RW.setSourceMgr(Ctx.getSourceManager(), Ctx.getLangOpts()); }
    void HandleTranslationUnit(ASTContext &Ctx) override {
        TensoriumVisitor V(&Ctx, RW);
        V.TraverseDecl(Ctx.getTranslationUnitDecl());
        RW.getEditBuffer(Ctx.getSourceManager().getMainFileID()).write(llvm::outs());
    }
};

class TensoriumPluginAction : public PluginASTAction {
protected:
    std::unique_ptr<ASTConsumer> CreateASTConsumer(CompilerInstance &CI, llvm::StringRef) override {
        CI.getPreprocessor().AddPragmaHandler(new TensoriumPragmaHandler());
        return std::make_unique<TensoriumConsumer>();
    }
    bool ParseArgs(const CompilerInstance&, const std::vector<std::string>&) override { return true; }
};
static FrontendPluginRegistry::Add<TensoriumPluginAction>
X("tensorium-dispatch", "Handle #pragma tensorium target(cpu)");

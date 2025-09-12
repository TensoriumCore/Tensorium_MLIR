#include "PragmaHandler.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/Lex/Lexer.h"
#include "llvm/ADT/StringSet.h"
#include <iostream>
#include <fstream>
#include <sys/stat.h>
#include <set>
#include <vector>

using namespace clang;

std::vector<PragmaSite> pragmaSites;

TensoriumPragmaHandler::TensoriumPragmaHandler() : PragmaHandler("tensorium") {}

void TensoriumPragmaHandler::HandlePragma(Preprocessor &PP, PragmaIntroducer, Token &Tok) {
    PP.Lex(Tok);
    if (Tok.isNot(tok::identifier) || Tok.getIdentifierInfo()->getName() != "target")
        return;
    PP.Lex(Tok);
    if (Tok.isNot(tok::l_paren))
        return;
    PP.Lex(Tok);
    std::string target;
    if (Tok.is(tok::string_literal) || Tok.is(tok::identifier)) {
        bool Invalid = false;
        target = PP.getSpelling(Tok, &Invalid);
        if (!target.empty() && target.front() == '"')
            target = target.substr(1, target.size() - 2);
    } else {
        return;
    }
    PP.Lex(Tok);
    if (Tok.isNot(tok::r_paren))
        return;
    SourceLocation where = Tok.getLocation();
    pragmaSites.push_back({target, where});
    llvm::errs() << "[TensoriumPragma] stored pragma at "
                 << where.printToString(PP.getSourceManager())
                 << " target=" << target << "\n";
}

class TensoriumVisitor : public RecursiveASTVisitor<TensoriumVisitor> {
    ASTContext *Context;
    std::set<const FunctionDecl*> alreadyAnnotated;
public:
    std::vector<const FunctionDecl*> exportedFunctions;
    std::vector<std::string> exportTargets;

    TensoriumVisitor(ASTContext *Ctx) : Context(Ctx) {}

    bool VisitCallExpr(CallExpr *CE) {
        SourceManager &SM = Context->getSourceManager();
        SourceLocation callLoc = CE->getBeginLoc();
        for (auto it = pragmaSites.rbegin(); it != pragmaSites.rend(); ++it) {
            if (SM.isBeforeInTranslationUnit(it->location, callLoc)) {
                const Expr* calleeExpr = CE->getCallee()->IgnoreImpCasts();
                if (auto *DRE = dyn_cast<DeclRefExpr>(calleeExpr)) {
                    if (auto *FD = dyn_cast<FunctionDecl>(DRE->getDecl())) {
                        if (alreadyAnnotated.insert(FD).second) {
                            exportedFunctions.push_back(FD);
                            exportTargets.push_back(it->target);
                        }
                    }
                }
                break;
            }
        }
        return true;
    }
};

class TensoriumConsumer : public ASTConsumer {
	public:
		void HandleTranslationUnit(ASTContext &Ctx) override {
			TensoriumVisitor V(&Ctx);
			V.TraverseDecl(Ctx.getTranslationUnitDecl());
			SourceManager &SM = Ctx.getSourceManager();

			std::string exportDir = "tensorium_export";
			struct stat st {};
			if (stat(exportDir.c_str(), &st) == -1) {
				mkdir(exportDir.c_str(), 0755);
			}

			for (size_t i = 0; i < V.exportedFunctions.size(); ++i) {
				const FunctionDecl* FD = V.exportedFunctions[i];
				const std::string& target = V.exportTargets[i];

				SourceRange range = FD->getSourceRange();
				std::string funcCode = Lexer::getSourceText(
						CharSourceRange::getTokenRange(range), SM, Ctx.getLangOpts()).str();

				std::string fname = exportDir + "/" +
					FD->getNameInfo().getAsString() + "_tensorium_" + target + ".cpp";

				std::string attr;
				if (target == "gpu")
					attr = "__attribute__((annotate(\"tensorium_gpu\"))) ";
				else if (target == "cpu")
					attr = "__attribute__((annotate(\"tensorium_cpu\"))) ";
				else
					attr = "";

				std::ofstream out(fname);
				if (!out) {
					llvm::errs() << "[Tensorium] ERROR: Can't open file " << fname << " for writing.\n";
					continue;
				}

				std::string extra_headers;
				if (funcCode.find("_mm512_") != std::string::npos)
					extra_headers += "#include <immintrin.h>\n";
				else if (funcCode.find("_mm256_") != std::string::npos)
					extra_headers += "#include <immintrin.h>\n";
				else if (funcCode.find("_mm_") != std::string::npos)
					extra_headers += "#include <xmmintrin.h>\n";

				out << extra_headers;
				out << "#define UNUSED(x) (void)(x)\n";
				out << attr << funcCode << "\n";
				out.close();
			}
		}
};
class TensoriumPluginAction : public PluginASTAction {
	protected:
		std::unique_ptr<ASTConsumer> CreateASTConsumer(CompilerInstance &CI, llvm::StringRef) override {
			CI.getPreprocessor().AddPragmaHandler(new TensoriumPragmaHandler());
			return std::make_unique<TensoriumConsumer>();
		}
		bool ParseArgs(const CompilerInstance &, const std::vector<std::string> &) override {
			return true;
		}
};
static FrontendPluginRegistry::Add<TensoriumPluginAction>
X("tensorium-dispatch", "Export functions by #pragma tensorium target(cpu/gpu)");

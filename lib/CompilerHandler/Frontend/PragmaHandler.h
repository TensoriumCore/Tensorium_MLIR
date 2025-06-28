#pragma once
#include "clang/Lex/Pragma.h"
#include "clang/Basic/SourceLocation.h"
#include <string>
#include <vector>

struct PragmaSite {
    std::string target;
    clang::SourceLocation location;
};
extern std::vector<PragmaSite> pragmaSites;

class TensoriumPragmaHandler : public clang::PragmaHandler {
public:
    TensoriumPragmaHandler();
    void HandlePragma(clang::Preprocessor &PP, clang::PragmaIntroducer, clang::Token &Tok) override;
};

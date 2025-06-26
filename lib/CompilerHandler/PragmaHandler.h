#pragma once

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/MemoryBuffer.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/Pragma.h"
#include "clang/Lex/Token.h"
#include "clang/Basic/SourceLocation.h"

namespace {

class TensoriumPragmaHandler : public clang::PragmaHandler {
public:
  TensoriumPragmaHandler() : clang::PragmaHandler("tensorium") {}

  void HandlePragma(clang::Preprocessor &PP,
                    clang::PragmaIntroducer,
                    clang::Token &Tok) override;

private:
  static void pushBuffer(clang::Preprocessor &PP,
                         llvm::StringRef Code,
                         llvm::StringRef Name) {
    auto Buf = llvm::MemoryBuffer::getMemBufferCopy(Code, Name);
    clang::FileID F = PP.getSourceManager().createFileID(std::move(Buf));
    PP.EnterSourceFile(F, nullptr, clang::SourceLocation());
  }
};

} // namespace

#!/bin/bash
set -e

SRC=CompilerHandler/PragmaTest.cpp
SDK=$(xcrun --show-sdk-path)

/opt/local/libexec/llvm-20/bin/clang++ -msse2 \
  -isystem "$SDK/usr/include" \
  -Xclang -load -Xclang ../build/lib/libTensoriumPragmaPlugin.dylib \
  -Xclang -add-plugin -Xclang tensorium-dispatch \
  "$SRC" -c -o /dev/null

for CPP in tensorium_export/*_tensorium_gpu.cpp; do
  LL=${CPP%.cpp}.ll

  /opt/local/libexec/llvm-20/bin/clang++ -msse2 \
    -isystem "$SDK/usr/include" \
    -emit-llvm -S "$CPP" -o "$LL"

  /opt/local/libexec/llvm-20/bin/opt \
    -load-pass-plugin ../build/lib/libDumpTensoriumGpuFuncsPass.dylib \
    -passes="dump-tensorium-gpu-funcs" \
    "$LL" -disable-output

  if grep -q '__attribute__((annotate("tensorium_gpu")))' "$CPP"; then
    echo "[CHECK][OK] Annotation found in $CPP"
  else
    echo "[CHECK][FAIL] Annotation MISSING in $CPP"
  fi

  if grep -q 'tensorium_gpu' "$LL"; then
    echo "[CHECK][OK] Annotation found in $LL"
  else
    echo "[CHECK][FAIL] Annotation MISSING in $LL"
  fi
done

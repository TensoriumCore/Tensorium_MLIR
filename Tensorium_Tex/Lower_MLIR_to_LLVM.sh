#!/usr/bin/env bash
set -euo pipefail

SRC_DIR=generated
OUT_DIR=build
mkdir -p "$OUT_DIR"

PIPELINE=(
  "--expand-strided-metadata" 
  "--finalize-memref-to-llvm" 
  "--convert-math-to-llvm"  
  "--convert-arith-to-llvm" 
  "--convert-func-to-llvm"  
  "--reconcile-unrealized-casts"     
)

for mlir in "$SRC_DIR"/*.mlir; do
  base=$(basename "$mlir" .mlir)
  lowered="$OUT_DIR/${base}.lowered.mlir"
  ll="$OUT_DIR/${base}.ll"
  mlir-opt "${PIPELINE[@]}" "$mlir" -o "$lowered"

  mlir-translate --mlir-to-llvmir "$lowered" -o "$ll"

  echo "✅  $mlir  →  $ll"
done

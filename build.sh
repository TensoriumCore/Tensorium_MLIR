#!/bin/bash

rm -rf build
mkdir -p build
cd build

cmake -G Ninja .. \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_DIR="/opt/local/libexec/llvm-20/lib/cmake/llvm" \
  -DMLIR_DIR="/opt/local/libexec/llvm-20/lib/cmake/mlir" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

echo "Étape 1: Génération des fichiers TableGen"
ninja MLIRRelativityOpsIncGen

echo "Étape 2: Construction du dialecte"
ninja MLIRRelativity

echo "Étape 3: Construction de l'exécutable"
ninja -j8 relativity-opt

# Vérification
echo "=== Fichiers générés ==="
find . -name "*inc" | grep Relativity

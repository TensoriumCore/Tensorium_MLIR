#!/bin/bash

# Nettoyage complet
rm -rf build
mkdir -p build
cd build

# Configuration avec chemins absolus
cmake -G Ninja .. \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_DIR="/opt/local/libexec/llvm-20/lib/cmake/llvm" \
  -DMLIR_DIR="/opt/local/libexec/llvm-20/lib/cmake/mlir" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Construction en 3 étapes
echo "Étape 1: Génération des fichiers TableGen"
ninja MLIRRelativityOpsIncGen

echo "Étape 2: Construction du dialecte"
ninja MLIRRelativity

echo "Étape 3: Construction de l'exécutable"
ninja -j4 relativity-opt

# Vérification
echo "=== Fichiers générés ==="
find . -name "*inc" | grep Relativity

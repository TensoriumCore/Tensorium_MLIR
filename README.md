# Tensorium_MLIR

A symbolic-to-MLIR codegen tool for numerical relativity.
This project parses LaTeX expressions of spacetime metrics with a custom C++ parser and automatically generates C++ or MLIR code for initial data in numerical relativity.

## Why this project?

The project aims to build a bridge between **symbolic physics** and **compiler technology**, using MLIR to define a customizable intermediate representation for relativistic computations.  
It aspires to empower physicists and researchers to write **high-level tensorial expressions**, which are then compiled down to **optimized low-level code** (LLVM IR, GPU kernels, etc.).

## Status
This is currently a proof of concept. The system extracts metric tensors from symbolic LaTeX, simplifies them, and emits valid code for use in numerical simulations of general relativity. The current options are :

- Custom LaTex parser
- Custom high level MLIR Dialect from LaTeX to create relativistic tensor patterns
- Emit lower passes MLIR (affine,Linealg/tensor/memref) from metric Tex files
- Can print Custom AST from the parser

## Goals

- [x] Parse LaTeX-formatted metrics (e.g. Schwarzschild, Kerr-Schild, FLRW)
- [x] Generate metric MLIR dialect (still in progress)
- [ ] Lowerging metric dialect to be compiled
- [ ] Support symbolic derivation of Christoffel, Ricci, and Riemann tensors
- [ ] Provide clean initial data for BSSN-based codes
- [ ] Integrate with Tensorium for runtime execution and benchmarking

### Build & install LLVM 20 + MLIR (with RTTI)

> **Tested on macOS 14 / MacPorts.**  
> Adapt the paths and targets to your platform if needed.

```bash
# 1) fetch sources
git clone https://github.com/llvm/llvm-project.git ~/src/llvm-project
cd ~/src

# 2) configure an out-of-tree build directory
export PREFIX=/opt/local/libexec/llvm-20     # install location
mkdir llvm-build-rtti && cd llvm-build-rtti

cmake -G Ninja ../llvm \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DLLVM_ENABLE_PROJECTS="mlir;clang;lld" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DLLVM_ENABLE_RTTI=ON \  
  -DMLIR_ENABLE_BINDINGS_PYTHON=OFF \
  -DCMAKE_BUILD_TYPE=Release

# 3) build & install
ninja -j$(sysctl -n hw.logicalcpu)
sudo ninja install
```
Once installed, add the toolchain to your environment:
```bash
echo 'export PATH='"$PREFIX"'/bin:$PATH' >> ~/.zshrc
echo 'export DYLD_LIBRARY_PATH='"$PREFIX"'/lib:$DYLD_LIBRARY_PATH' >> ~/.zshrc
echo 'export CMAKE_PREFIX_PATH='"$PREFIX"':$CMAKE_PREFIX_PATH' >> ~/.zshrc
source ~/.zshrc

```
You can now configure Tensorium_MLIR:

## Usage

To convert LaTeX metric blocks into MLIR or C++ code, simply provide your .tex input to the frontend tool.
The system will extract and simplify metric components, then emit either "lowered" MLIR, or dialect MLIR for the Tensorium/Relativity dialects.
Status

This is currently a proof of concept. The system extracts metric tensors from symbolic LaTeX, simplifies them, and emits valid code for use in numerical simulations of general relativity.

### build

```bash
mkdir build && cd build && cmake .. && make -j
```

### exemple 

create a ```test.tex``` file with:

```markdown
$-(1 - \frac{2 M r}{\rho^2}) dt^2$
$- \frac{4 M a r \sin^2\theta}{\rho^2} dt d\phi$
$\frac{\rho^2}{\Delta} dr^2$
$\rho^2 d\theta^2$
$(r^2 + a^2 + \frac{2 M a^2 r \sin^2\theta}{\rho^2}) \sin^2\theta d\phi^2$
```

then use ```tensorium-tex``` to parse and convert into a high level MLIR dialect with ```--dialect``` or lowered to low level MLIR with ```--mlir```:

```bash
./tensorium-tex --dialect/mlir test.tex 
```

then you can pass it to relativity-opt :

```bash
./relativity-opt output_symbolic.mlir
```
If you want to lower the custom relativity dialect to LLVM IR, you can use the following command:

```bash
./bin/relativity-opt \
  --relativity-simplify \
  --lower-relativity \
  --assemble-metric-tensor \
  output_symbolic.mlir -o out.mlir
```

```bash
mlir-opt out.mlir \
  --convert-tensor-to-linalg \
  --convert-linalg-to-loops \
  --one-shot-bufferize="allow-return-allocs,bufferize-function-boundaries" \
  --finalize-memref-to-llvm \
  --convert-math-to-llvm \
  --convert-arith-to-llvm \
  --convert-scf-to-cf \
  --convert-cf-to-llvm \
  --convert-func-to-llvm \
  --reconcile-unrealized-casts \
  > lowered.mlir

mlir-translate --mlir-to-llvmir lowered.mlir > lowered.ll
```

## License

MIT — see [LICENSE](./LICENSE)

# Tensorium_MLIR

**A symbolic-to-MLIR codegen tool for numerical relativity.**
This project parses LaTeX expressions of spacetime metrics and automatically generates C++ or MLIR code for initial data in numerical relativity.

## The Latex Parser is in [Tensorium_Tex/](Tensorium_Tex/), you just have to install nix and run nix-shell in the main directory

```bash
python3 Codegen.py --backend mlir/cpp && make 
```
(Type make only if you want all the ```.o``` for tests in a C++ main)

## Status
This is currently a proof of concept. The system extracts metric tensors from symbolic LaTeX, simplifies them, and emits valid code for use in numerical simulations of general relativity.

## Goals

- [x] Parse LaTeX-formatted metrics (e.g. Schwarzschild, Kerr-Schild, FLRW)
- [x] Extract and simplify symbolic tensors using SymPy
- [x] Generate metric functions in standard MLIR or C++
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

```bash
chmod +x build.sh && ./build.sh
```

## Future Ideas

- [ ] **LaTeX/Sympy → MLIR converter**  
  A symbolic parser (maybe a custom symbolic language like Kadath's one) will be developed in `frontend/`.

- [ ] **Automatic generation of geometric objects**  
  Generate Jacobians, Christoffel symbols, Ricci and Riemann tensors using dedicated MLIR operations and optimization passes.

- [ ] **GPU code generation**  
  Target GPU/CPU/TPU architectures to accelerate large-scale simulations.

- [ ] **Runtime integration**  
  Link the MLIR dialect with `Tensorium_lib` to run compiled kernels on real data.

## Why this project?

The project aims to build a bridge between **symbolic physics** and **compiler technology**, using MLIR to define a customizable intermediate representation for relativistic computations.  
It aspires to empower physicists and researchers to write **high-level tensorial expressions**, which are then compiled down to **optimized low-level code** (LLVM IR, GPU kernels, etc.).


## License

MIT — see [LICENSE](./LICENSE)

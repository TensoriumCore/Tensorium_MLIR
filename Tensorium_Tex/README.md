
# Tensorium_tex

**Tensorium_tex** is a symbolic parser and code generation tool designed to bridge LaTeX mathematical notation and tensor-based computation backends (such as MLIR or C++). The goal of this project is to provide a robust frontend that parses LaTeX expressions, builds a structured Abstract Syntax Tree (AST), and enables automatic code generation for high-performance tensor algebra and general relativity.

## Features

- **LaTeX Parser**: Converts LaTeX expressions (including tensor indices and subscripts/superscripts) into an internal AST representation.
- **AST Utilities**: Tools for manipulating and analyzing the parsed abstract syntax tree.
- **Tensor Indexing Support**: Support for complex tensor index manipulation (covariant, contravariant, partial derivatives, etc.).
- **Code Generation Ready**: Backend-agnostic, with planned support for MLIR and C++ code generation.
- **Test Suite**: Simple tests to validate parser and AST functionality.

## Build Instructions

**Requirements**:
- C++17 or newer compiler (tested with Clang and GCC)
- CMake (recommended)
- (Optional) MLIR/LLVM if targeting MLIR backend (future)

### Build

```sh
mkdir build
cd build
cmake ..
make
```
### Usage Example

Given a LaTeX file like:
```latex
$R_{\mu\nu} = R^{\lambda}_{\ \mu\lambda\nu}$
```
Tensorium_tex will parse the expression and build the corresponding AST, ready for further processing or code generation.

### Project Goals

- Robust LaTeX → AST pipeline for tensor and index-rich expressions
- Symbolic manipulation and simplification
- Code generation for MLIR and C++ (planned)
- Extensible design for additional backends and transformations

### Contribution

PRs, issues, and suggestions are welcome!
Please use English for all code and documentation.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Contact
For questions or discussions, please open an issue on the GitHub repository or contact the maintainers.
@at0m741

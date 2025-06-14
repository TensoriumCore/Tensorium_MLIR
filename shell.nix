{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  }
}:

pkgs.mkShell {
  buildInputs = with pkgs; [

    vscode
    gcc
    openblas
    openmpi
    valgrind
    cloc
    tree
    doxygen 
    graphviz 
    bear

    python312Full
    (python312.withPackages (ps: with ps; [
      pip
      virtualenv
      ipykernel
      notebook
      jupyter-client
      pyzmq
      pybind11
      sympy
      numpy
      matplotlib
      pygments 
      lark
    ]))

  ] ++ (with llvmPackages_18; [
    mlir
    clang
    llvm
    libclang
    openmp
  ]);


  shellHook = ''
    echo "[+] Activating Python virtualenv..."
    if [ ! -d .venv ]; then
      python3 -m venv .venv
      source .venv/bin/activate
      echo "[+] Installing pip-only packages..."
      pip install --upgrade pip
      pip install nanobind
	  pip install --force-reinstall --ignore-installed antlr4-python3-runtime==4.11.1
    else
      source .venv/bin/activate
    fi

    export PYTHONPATH=$(pwd):$PYTHONPATH
    echo "[+] Environment ready."
  '';

}

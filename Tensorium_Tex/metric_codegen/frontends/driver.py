from sympy.parsing.latex import parse_latex
from sympy import simplify
from metric_codegen.optim.cse import run as run_cse
from metric_codegen.backends.cpp import generate_cpp_code
from metric_codegen.backends.mlir import generate_mlir_code

def generate_metric_code(name, latex_expr, args, backend="cpp"):
    expr = parse_latex(latex_expr)
    expr = simplify(expr)
    repl, reduced = run_cse(expr)

    if backend == "cpp":
        return generate_cpp_code(name, repl, reduced[0], args)
    elif backend == "mlir":
        return generate_mlir_code(name, repl, reduced[0], args)
    else:
        raise ValueError(f"Backend non reconnu : {backend}")

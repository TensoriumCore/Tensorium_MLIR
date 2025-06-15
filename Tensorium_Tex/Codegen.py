from sympy.parsing.latex import parse_latex
from sympy import symbols, simplify, Function
from metric_codegen.optim.cse import run as run_cse
from metric_codegen.backends.cpp import build_function
from metric_codegen.frontends.driver import generate_metric_code
from metric_codegen.frontends.metric_tensor import extract_metric_tensor
from metric_codegen.frontends.christoffel import build_christoffel_mlir
from metric_codegen.frontends.christoffel import gen_numeric_christoffel_mlir
import os


def export_code_to_file(code: str, name: str, backend: str):
    if code is None:
        print(f"[!] Skipping export for {name}: no code generated.")
        return None
    ext = "mlir" if backend == "mlir" else "cpp"
    os.makedirs("generated", exist_ok=True)
    filename = os.path.join("generated", f"{name}.{ext}")
    with open(filename, "w") as f:
        f.write(code)
    return filename


backend = "mlir"
m, r, t, theta, phi, a = symbols("m r t theta phi a")
x, y, z = symbols("x y z")
dx, dy, dz = symbols("dx dy dz")
dt, dr, dtheta, dphi = symbols("dt dr dtheta dphi")
a_t = Function("a")(t)

constants = {'m': 1.0, 'a': 0.5}
args_common = ['t', 'r', 'theta', 'phi', 'm', 'a']
coord_only  = ['t', 'r', 'theta', 'phi']
args_values = [1.0, 10.0, 0.1, 0.2]

metrics = {
    "schwarzschild": r"-(1 - \frac{2m}{r})dt^2 + (1 - \frac{2m}{r})^{-1}dr^2 + r^2 d\theta^2 + r^2\sin^2\theta\,d\phi^2",
    "minkowski":     r"-dt^2 + dr^2 + r^2 d\theta^2 + r^2 \sin^2\theta d\phi^2",
    "flrw_flat":     r"-dt^2 + a(t)^2 (dr^2 + r^2 d\theta^2 + r^2 \sin^2\theta d\phi^2)",
    "kerr_schild_simple": (
    r"-dt^{2} + dx^{2} + dy^{2} + dz^{2}"
    r" + \frac{2\,m\,r^{3}}{r^{4} + a^{2} z^{2}}"
    r"\left(dt"
    r" + \frac{r\,x + a\,y}{\,r^{2} + a^{2}\,}\,dx"
    r" + \frac{r\,y - a\,x}{\,r^{2} + a^{2}\,}\,dy"
    r" + \frac{z}{r}\,dz\right)^{2}")
}

for name, latex_expr in metrics.items():
    print(f"\n=== {name.upper()} ===")

    try:
        expr = parse_latex(latex_expr)
        expr = expr.subs({
            Function("a")(t): constants['a'],
            'dt': 1.0, 'dr': 1.0, 'dtheta': 0.0, 'dphi': 0.0,
            'dx': 0.0, 'dy': 0.0, 'dz': 0.0
        })
        expr = simplify(expr)

        repl, reduced = run_cse(expr)

        code = generate_metric_code(name, latex_expr, args_common, backend=backend)
        if code:
            print("\n--- Code ---\n")

        filepath = export_code_to_file(code, name, backend)
        if filepath:
            print(f"  → MLIR scalar code generated: {filepath}")

        from metric_codegen.backends.mlir import generate_full_metric_mlir
        tensor_code = generate_full_metric_mlir(
            name=f"{name}_tensor",
            latex_expr=latex_expr,
            coord_order=['t', 'r', 'theta', 'phi'],
            args=args_common
        )
        filepath_tensor = export_code_to_file(tensor_code, f"{name}_tensor", backend="mlir")
        if filepath_tensor:
            print(f"  → MLIR tensor code generated: {filepath_tensor}")

    except Exception as e:
        print(f"Error : {name} : {e}")

coords      = symbols("t r theta phi")
latex       = r"-(1-\frac{2m}{r})dt^2 + (1-\frac{2m}{r})^{-1}dr^2 + r^2 d\theta^2 + r^2\sin^2\theta\,d\phi^2"
args_common = ['t','r','theta','phi','m','a']

christ_mlir = build_christoffel_mlir(
    "schwarzschild_christoffel",
    latex, coords, args_common
)

with open("generated/schwarzschild_christoffel.mlir","w") as f:
    f.write(christ_mlir)
mlir_code = gen_numeric_christoffel_mlir()
with open("generated/christoffel_numeric.mlir", "w") as f:
    f.write(mlir_code)

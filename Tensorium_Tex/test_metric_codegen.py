from sympy.parsing.latex import parse_latex
from sympy import symbols, simplify, Function
from metric_codegen.optim.cse import run as run_cse
from metric_codegen.backends.cpp import build_function
from metric_codegen.frontends.driver import generate_metric_code

import os

def export_code_to_file(code: str, name: str, backend: str):
    ext = "mlir" if backend == "mlir" else "cpp"
    os.makedirs("generated", exist_ok=True)
    filename = os.path.join("generated", f"{name}.{ext}")
    with open(filename, "w") as f:
        f.write(code)
    return filename

# === Paramètre global du backend ===
backend = "mlir"  # ou "cpp"

m, r, t, theta, phi, a = symbols("m r t theta phi a")
x, y, z = symbols("x y z")
dx, dy, dz = symbols("dx dy dz")
dt, dr, dtheta, dphi = symbols("dt dr dtheta dphi")
a_t = Function("a")(t)

args_common = ['m', 'r', 't', 'theta', 'phi', 'a',
               'x', 'y', 'z',
               'dx', 'dy', 'dz',
               'dt', 'dr', 'dtheta', 'dphi']

args_values = [1.0, 10.0, 0.0, 1.0, 0.0,
               0.5,
               1.0, 1.0, 0.0,
               0.0, 0.0, 0.0,
               1.0, 1.0, 0.0, 0.0]

metrics = {
    "schwarzschild": r"-(1 - \frac{2m}{r})dt^2 + (1 - \frac{2m}{r})^{-1}dr^2 + r^2 d\theta^2 + r^2\sin^2\theta\,d\phi^2",
    "minkowski":     r"-dt^2 + dr^2 + r^2 d\theta^2 + r^2 \sin^2\theta d\phi^2",
    "flrw_flat":     r"-dt^2 + a(t)^2 (dr^2 + r^2 d\theta^2 + r^2 \sin^2\theta d\phi^2)",
    "kerr_schild_simple": r"-dt^2 + dx^2 + dy^2 + dz^2 + \frac{2m r^3}{r^4 + a^2 z^2} (dt + \frac{r x + a y}{r^2 + a^2} dx + \frac{r y - a x}{r^2 + a^2} dy + \frac{z}{r} dz)^2"
}

for name, latex_expr in metrics.items():
    print(f"\n=== {name.upper()} ===")
    print(f"LaTeX: {latex_expr}")

    try:
        expr = parse_latex(latex_expr).subs(Function("a")(t), a)
        expr = simplify(expr)
        repl, reduced = run_cse(expr)

        # Génération du code backend (MLIR ou C++)
        code = generate_metric_code(name, latex_expr, args_common, backend=backend)
        print("\n--- Code généré ---\n")
        print(code)

        # Export dans un fichier
        filepath = export_code_to_file(code, name, backend)
        print(f"\nFichier exporté : {filepath}")

        if backend == "cpp":
            func = build_function(name, repl, reduced[0], args_common)
            result = func(*args_values)
            print(f"\nRésultat d’évaluation : g = {result}")

    except Exception as e:
        print(f"Erreur lors du traitement de {name} : {e}")

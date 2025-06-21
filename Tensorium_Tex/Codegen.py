from sympy.parsing.latex import parse_latex
from sympy import symbols, simplify, Function
from metric_codegen.optim.cse import run as run_cse
from metric_codegen.frontends.metric_tensor import extract_metric_tensor
from metric_codegen.frontends.christoffel import build_christoffel_mlir, gen_numeric_christoffel_mlir
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
    # Schwarzschild (coordonnées {t,r,θ,φ})
    "schwarzschild": r"""-(1-2m/r)\,dt^{2}
                         + (1-2m/r)^{-1}\,dr^{2}
                         + r^{2}\,d\theta^{2}
                         + r^{2}\sin^{2}{\theta}\,d\phi^{2}""",

    # Minkowski sphérique
    "minkowski":     r"""-dt^{2} + dr^{2}
                         + r^{2}\,d\theta^{2}
                         + r^{2}\sin^{2}{\theta}\,d\phi^{2}""",

    # FLRW plat (facteur d’échelle a(t))
    "flrw_flat":     r"""-dt^{2}
                         + a(t)^{2}\!\left(
                               dr^{2}
                             + r^{2}\,d\theta^{2}
                             + r^{2}\sin^{2}{\theta}\,d\phi^{2}
                         \right)""",

    # Un exemple « random » avec terme croisé dr dφ
    "Random":        r"""-e^{\sin t}\,dt^{2}
                         + (1+r^{2})\,dr^{2}
                         + r\sin{\theta}\,\bigl(dr\,d\phi + d\phi\,dr\bigr)
                         + r^{2}\,d\theta^{2}
                         + \cos{\theta}\,d\phi^{2}"""
}
for name, latex_expr in metrics.items():
    print(f"\n=== {name.upper()} ===")

    try:
        if "a(t)" in latex_expr:
            expr = parse_latex(latex_expr)
            expr = expr.subs({Function("a")(t): constants['a']})
            expr = simplify(expr)
            latex_for_mlir = latex_expr.replace("a(t)", str(constants['a']))
        else:
            latex_for_mlir = latex_expr

        g = extract_metric_tensor(latex_for_mlir, coord_only)
        print("Matrice extraite symbolique :\n", g)

        subs_dict = {'t': 1.0, 'r': 10.0, 'theta': 0.1, 'phi': 0.2}
        print("Matrice évaluée :\n", g.subs(subs_dict).evalf(6))

        from metric_codegen.backends.mlir import generate_full_metric_mlir
        tensor_code = generate_full_metric_mlir(
            name=f"{name}_tensor",
            latex_expr=latex_for_mlir,
            coord_order=coord_only,
            args=args_common
        )
        filepath_tensor = export_code_to_file(tensor_code, f"{name}_tensor", backend="mlir")
        if filepath_tensor:
            print(f"  → MLIR tensor code generated: {filepath_tensor}")

    except Exception as e:
        print(f"Error : {name} : {e}")

g = extract_metric_tensor(latex_expr, ['t', 'r', 'theta', 'phi'])
print(g)
print(g.subs({'t':1.0, 'r':10.0, 'theta':0.1, 'phi':0.2}).evalf())

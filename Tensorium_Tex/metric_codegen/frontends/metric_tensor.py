# metric_codegen/frontends/metric_tensor.py

from sympy import symbols, Matrix, simplify, Pow, Mul
from sympy.parsing.latex import parse_latex

def extract_metric_tensor(latex_expr: str, coord_order: list[str]) -> Matrix:
    expr = simplify(parse_latex(latex_expr))

    dvars = [symbols(f'd{v}') for v in coord_order]
    n = len(dvars)
    g = Matrix.zeros(n)

    for term in expr.expand().as_ordered_terms():
        if isinstance(term, Pow) and term.base in dvars and term.exp == 2:
            i = dvars.index(term.base)
            coeff = term / term 
            g[i, i] += simplify(coeff)
            continue

        if isinstance(term, Mul):
            which = [i for i, dv in enumerate(dvars) if term.has(dv)]
            if len(which) == 1:
                dv = dvars[which[0]]
                if term.has(dv**2):
                    coeff = term / (dv*dv)
                    g[which[0], which[0]] += simplify(coeff)
                continue
            elif len(which) == 2:
                i, j = which
                coeff = term / (dvars[i] * dvars[j])
                g[i, j] += simplify(coeff)
                if i != j:
                    g[j, i] += simplify(coeff)
                continue

    return simplify(g)

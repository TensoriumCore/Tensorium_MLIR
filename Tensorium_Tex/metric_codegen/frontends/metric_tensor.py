from sympy.parsing.latex import parse_latex
from sympy import Matrix, simplify, symbols, expand, Pow, Mul


import re
from textwrap import dedent
from sympy import E, Symbol, simplify
from sympy.parsing.latex import parse_latex as _sympy_parse_latex

_BAD_MACROS = (r'\bigl', r'\bigr', r'\left', r'\right')

def parse_latex(tex: str):
    for bad in _BAD_MACROS:
        tex = tex.replace(bad, '')
    tex = re.sub(r'\s+', ' ', dedent(tex)).strip()

    expr = _sympy_parse_latex(tex)

    expr = expr.subs(Symbol('e'), E)
    return simplify(expr)

def extract_metric_tensor(latex_expr: str, coord_order: list[str]):
    expr   = simplify(parse_latex(latex_expr))
    dvars  = [symbols(f'd{c}') for c in coord_order]
    n      = len(dvars)
    g      = Matrix.zeros(n)

    for term in expand(expr).as_ordered_terms():

        present = [dv for dv in dvars if term.has(dv)]
        if not present:
            continue

        if len(present) == 1:
            dv   = present[0]
            i    = dvars.index(dv)
            coeff = simplify(term / (dv**2))
            g[i, i] += coeff
            continue

        if len(present) == 2:
            i, j = sorted([dvars.index(p) for p in present])
            coeff = simplify(term / (dvars[i] * dvars[j]) / 2)
            g[i, j] += coeff
            g[j, i] += coeff
            continue

    return simplify(g)

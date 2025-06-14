from sympy.parsing.latex import parse_latex
def parse(expr: str):
    return parse_latex(expr)

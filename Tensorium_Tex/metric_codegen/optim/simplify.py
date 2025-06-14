from sympy import simplify, powdenest, together
def run(expr):
    expr = simplify(expr)
    expr = powdenest(expr, force=True)
    expr = together(expr)
    return expr

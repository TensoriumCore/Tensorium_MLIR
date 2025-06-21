from metric_codegen.frontends.latex_utils import parse_latex_safe as parse_latex
def parse(expr: str):
    return parse_latex(expr)

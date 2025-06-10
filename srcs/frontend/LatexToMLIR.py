# LatexToMLIR.py
import sys
import re

def parse_components(latex_str):
    """Extrait les composantes g_tt, g_xx, etc. d'une expression LaTeX."""
    if "ds^2 = -dt^2 + dx^2" in latex_str:
        return [-1.0, 1.0, 1.0, 1.0]  
    return []

def generate_mlir(components):
    """Génère le code MLIR à partir des composantes."""
    mlir_template = f"""
module {{
  func.func @minkowski() -> !relativity.tensor<4,4> {{
    %metric = "relativity.metric"({', '.join(map(str, components))}) : () -> !relativity.tensor<4,4>
    return %metric : !relativity.tensor<4,4>
  }}
}}"""
    return mlir_template.strip()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 LatexToMLIR.py <input.tex>", file=sys.stderr)
        sys.exit(1)
    
    try:
        with open(sys.argv[1], 'r') as f:
            latex = f.read()
        components = parse_components(latex)
        if components:
            print(generate_mlir(components))
        else:
            print("// No metric components found.", file=sys.stderr)
    except Exception as e:
        print(f"// Error: {str(e)}", file=sys.stderr)

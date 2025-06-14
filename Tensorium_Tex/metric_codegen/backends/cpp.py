
import subprocess, tempfile, importlib.util, importlib.machinery
from pathlib import Path
from sympy.printing.cxx import cxxcode

TEMPLATE = """
#include <pybind11/pybind11.h>
#include <cmath>
double {name}({args}) {{
{body}
}}
PYBIND11_MODULE({modname}, m) {{
    m.def("{name}", &{name});
}}
"""

def build_function(name: str, repl, core, args):
    lines = [f"  double {s} = {cxxcode(e)};" for s, e in repl]
    lines.append(f"  return {cxxcode(core)};")
    body = "\n".join(lines)

    code = TEMPLATE.format(
        name=name,
        args=", ".join(f"double {a}" for a in args),
        body=body,
        modname=name
    )

    with tempfile.TemporaryDirectory() as tmp:
        cpp = Path(tmp)/"gen.cpp"
        cpp.write_text(code)
        so  = Path(tmp)/"gen.so"
        subprocess.check_call(
            f"c++ -O3 -shared -std=c++17 -fPIC $(python3 -m pybind11 --includes) {cpp} -o {so}",
            shell=True
        )

        spec = importlib.util.spec_from_file_location(name, so)
        mod  = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)

        return getattr(mod, name)


def generate_cpp_code(name: str, repl, core, args) -> str:
    lines = [f"  double {s} = {cxxcode(e)};" for s, e in repl]
    lines.append(f"  return {cxxcode(core)};")
    body  = "\n".join(lines)

    return TEMPLATE.format(
        name=name,                     # ✅ ici
        body=body,
        args=", ".join(f"double {a}" for a in args),
        modname=f"_{name}_mod"
    )


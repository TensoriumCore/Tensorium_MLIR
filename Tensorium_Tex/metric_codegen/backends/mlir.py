
from sympy import preorder_traversal, Symbol
from sympy import Symbol
from sympy import Number

from sympy import tan, cot
from sympy import Symbol, Number, Add, Mul, Pow, Function, sin, cos, exp, tan, preorder_traversal

def generate_mlir_code(name: str, repl: list, reduced_expr, args: list[str]) -> str:
    mlir_ops = []
    counter = [0]

    var_mapping = {str(sym): f"%{str(sym)}" for sym in args}
    func_table = {
        sin: "math.sin",
        cos: "math.cos",
        exp: "math.exp",
    }

    def _sympy_expr_to_mlir(expr):
        if isinstance(expr, Symbol):
            return var_mapping.get(str(expr), f"%{str(expr)}")

        if isinstance(expr, Number):
            val = float(expr)
            tmp = f"%c{counter[0]}"
            counter[0] += 1
            mlir_ops.append(f"{tmp} = arith.constant {val} : f64")
            return tmp

        if isinstance(expr, Mul):
            args_mlir = [_sympy_expr_to_mlir(arg) for arg in expr.args]
            acc = args_mlir[0]
            for arg in args_mlir[1:]:
                tmp = f"%x{counter[0]}"
                counter[0] += 1
                mlir_ops.append(f"{tmp} = arith.mulf {acc}, {arg} : f64")
                acc = tmp
            return acc

        if isinstance(expr, Add):
            args_mlir = [_sympy_expr_to_mlir(arg) for arg in expr.args]
            acc = args_mlir[0]
            for arg in args_mlir[1:]:
                tmp = f"%x{counter[0]}"
                counter[0] += 1
                mlir_ops.append(f"{tmp} = arith.addf {acc}, {arg} : f64")
                acc = tmp
            return acc

        if isinstance(expr, Pow):
            base, exp = expr.args
            if isinstance(base, Function) and exp == 2:
                op = func_table.get(base.func, None)
                if op:
                    arg_mlir = _sympy_expr_to_mlir(base.args[0])
                    tmp1 = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{tmp1} = {op} {arg_mlir} : f64")
                    tmp2 = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{tmp2} = arith.mulf {tmp1}, {tmp1} : f64")
                    return tmp2

            if isinstance(exp, Number) and int(exp) == exp:
                base_mlir = _sympy_expr_to_mlir(base)
                acc = base_mlir
                for _ in range(abs(int(exp)) - 1):
                    tmp = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{tmp} = arith.mulf {acc}, {base_mlir} : f64")
                    acc = tmp
                if int(exp) < 0:
                    one = f"%c{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{one} = arith.constant 1.0 : f64")
                    inv = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{inv} = arith.divf {one}, {acc} : f64")
                    return inv
                return acc

            raise NotImplementedError("Unsupported power expression")

        if isinstance(expr, Function):
            op = func_table.get(expr.func, None)
            if op:
                arg_mlir = _sympy_expr_to_mlir(expr.args[0])
                tmp = f"%x{counter[0]}"
                counter[0] += 1
                mlir_ops.append(f"{tmp} = {op} {arg_mlir} : f64")
                return tmp
            return var_mapping.get(str(expr.func), f"%{str(expr.func)}")

        raise NotImplementedError(f"Unsupported expr: {expr} (type {type(expr)})")

    for sym in preorder_traversal(reduced_expr):
        if isinstance(sym, Symbol):
            sname = str(sym)
            if sname not in var_mapping:
                tmp = f"%c{counter[0]}"
                counter[0] += 1
                mlir_ops.append(f"{tmp} = arith.constant 1.0 : f64")
                var_mapping[sname] = tmp

    result_expr = _sympy_expr_to_mlir(reduced_expr)
    zero = f"%c{counter[0]}"
    counter[0] += 1
    mlir_ops.append(f"{zero} = arith.constant 0.0 : f64")
    mlir_ops.append(f"%result = arith.addf {result_expr}, {zero} : f64")

    args_fmt = ", ".join([f"%{a}: f64" for a in args])
    body = "\n    ".join(mlir_ops)

   
    return f"""
module {{
  func.func @{name}({args_fmt}) -> f64 {{
    {body}
    return %result : f64
  }}
}}
""".strip()



def generate_full_metric_mlir(name, latex_expr, coord_order, args):

    from sympy import symbols, simplify
    from metric_codegen.frontends.metric_tensor import extract_metric_tensor
    from metric_codegen.optim.cse import run as run_cse

    dvars = symbols("dt dr dtheta dphi dx dy dz")
    replacements = {d: 1.0 for d in dvars if str(d) not in args}
    g = simplify(extract_metric_tensor(latex_expr, coord_order).subs(replacements))

    mlir = []
    mlir.append("module {")
    arg_sig = ", ".join(f"%{a}: f64" for a in args)
    mlir.append(f"  func.func @{name}({arg_sig}) -> memref<4x4xf64> {{")
    mlir.append("    %buf = memref.alloc() : memref<4x4xf64>")
    mlir.append("    %c0_f64 = arith.constant 0.0 : f64")

    counter = [1] 
    idx_done = set()

    for i in range(len(coord_order)):
        for j in range(len(coord_order)):
            expr = g[i, j]
            repl, reduced = run_cse(expr)
            core = reduced[0]

            for line in _sympy_to_mlir_snippet(repl, core, args, counter, f"g{i}{j}"):
                mlir.append(f"    {line}")

            for v in (i, j):
                if v not in idx_done:
                    mlir.append(f"    %c{v}_idx = arith.constant {v} : index")
                    idx_done.add(v)

            mlir.append(f"    memref.store %g{i}{j}, %buf[%c{i}_idx, %c{j}_idx] : memref<4x4xf64>")

    mlir.append("    return %buf : memref<4x4xf64>")
    mlir.append("  }")
    mlir.append("}")

    return "\n".join(mlir)


def uniquify_mlir_ssa(mlir_code: str) -> str:
    import re
    counter = 0
    ssa_map = {}
    def_vars = set()

    for line in mlir_code.splitlines():
        m = re.match(r"\s*(%[a-zA-Z_][a-zA-Z0-9_]*)\s*=", line)
        if m:
            def_vars.add(m.group(1))

    def replace_ssa(match):
        nonlocal counter
        name = match.group(0)
        if name not in def_vars:
            return name  
        if name in ssa_map:
            return ssa_map[name]
        new_name = f"%{name[1:]}__{counter}"
        ssa_map[name] = new_name
        counter += 1
        return new_name

    def update_line(line):
        return re.sub(r"%[a-zA-Z_][a-zA-Z0-9_]*", replace_ssa, line)

    return "\n".join(update_line(line) for line in mlir_code.splitlines())



def uniquify_mlir_ssa(mlir_code: str) -> str:
    import re
    counter = 0
    ssa_map = {}
    def_vars = set()

    for line in mlir_code.splitlines():
        m = re.match(r"\s*(%[a-zA-Z_][a-zA-Z0-9_]*)\s*=", line)
        if m:
            def_vars.add(m.group(1))

    def replace_ssa(match):
        nonlocal counter
        name = match.group(0)
        if name not in def_vars:
            return name  
        if name in ssa_map:
            return ssa_map[name]
        new_name = f"%{name[1:]}__{counter}"
        ssa_map[name] = new_name
        counter += 1
        return new_name

    def update_line(line):
        return re.sub(r"%[a-zA-Z_][a-zA-Z0-9_]*", replace_ssa, line)

    return "\n".join(update_line(line) for line in mlir_code.splitlines())

def _sympy_to_mlir_snippet(repl, core, args, counter, result_name):
    from sympy import Symbol, Number, Function, Add, Mul, Pow, sin, cos, exp

    lines = []
    var_map = {a: f"%{a}" for a in args}          # t, r, …
    func_op = {sin: "math.sin", cos: "math.cos", exp: "math.exp", tan: "math.tan", cot: "math.cot"}

    def fresh(pref="x"):
        name = f"%{pref}{counter[0]}"
        counter[0] += 1
        return name

    def emit(expr):      
        if isinstance(expr, Symbol):
            key = str(expr)
            if key not in var_map: 
                raise ValueError(f"[MLIR] Variable `{key}` not in args, cannot lower to MLIR.")

            return var_map[key]

        if isinstance(expr, Number):
            cst = fresh("c")
            lines.append(f"{cst} = arith.constant {float(expr)} : f64")
            return cst

        if isinstance(expr, Function) and expr.func in func_op:
            arg = emit(expr.args[0])
            tmp = fresh("x")
            lines.append(f"{tmp} = {func_op[expr.func]} {arg} : f64")
            return tmp

        if isinstance(expr, Mul):
            args_mlir = [emit(a) for a in expr.args]
            acc = args_mlir[0]
            for v in args_mlir[1:]:
                tmp = fresh("x")
                lines.append(f"{tmp} = arith.mulf {acc}, {v} : f64")
                acc = tmp
            return acc

        if isinstance(expr, Add):
            args_mlir = [emit(a) for a in expr.args]
            acc = args_mlir[0]
            for v in args_mlir[1:]:
                tmp = fresh("x")
                lines.append(f"{tmp} = arith.addf {acc}, {v} : f64")
                acc = tmp
            return acc

        if isinstance(expr, Pow):
            base, expn = expr.args
            if isinstance(expn, Number) and int(expn) == expn:
                acc = emit(base)
                for _ in range(abs(int(expn)) - 1):
                    tmp = fresh("x")
                    lines.append(f"{tmp} = arith.mulf {acc}, {emit(base)} : f64")
                    acc = tmp
                if int(expn) < 0:
                    one = fresh("c")
                    lines.append(f"{one} = arith.constant 1.0 : f64")
                    inv = fresh("x")
                    lines.append(f"{inv} = arith.divf {one}, {acc} : f64")
                    acc = inv
                return acc
        raise NotImplementedError(f"expr {expr}")

    for sym, expr in repl:
        val = emit(expr)
        lines.append(f"%{sym} = arith.addf {val}, %c0_f64 : f64") 

    res_val = emit(core)
    lines.append(f"%{result_name} = arith.addf {res_val}, %c0_f64 : f64")
    return lines

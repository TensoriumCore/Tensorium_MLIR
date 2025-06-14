
from sympy import preorder_traversal, Symbol
from sympy import Symbol
from sympy import Number

def _sympy_expr_to_mlir(expr, var_mapping, counter=[100]):
    from sympy import Add, Mul, Pow

    if expr in var_mapping:
        return var_mapping[expr]

    
    if isinstance(expr, Symbol):
        name = str(expr)
        if name in var_mapping:
            return var_mapping[name]
        else:
            tmp = f"%{name}"
            const = f"%c{counter[0]}"
            counter[0] += 1
            mlir_ops.append(f"{const} = arith.constant 1.0 : f64")
            var_mapping[name] = const
            return const


    if isinstance(expr, Number):
        return str(float(expr))
    if isinstance(expr, Mul):
        args = [ _sympy_expr_to_mlir(arg, var_mapping, counter) for arg in expr.args ]
        acc = args[0]
        for arg in args[1:]:
            tmp = f"%tmp{counter[0]}"
            counter[0] += 1
            line = f"{tmp} = arith.mulf {acc}, {arg} : f64"
            var_mapping[tmp] = tmp  
            acc = tmp
        return acc

    if isinstance(expr, Add):
        args = [ _sympy_expr_to_mlir(arg, var_mapping, counter) for arg in expr.args ]
        acc = args[0]
        for arg in args[1:]:
            tmp = f"%tmp{counter[0]}"
            counter[0] += 1
            line = f"{tmp} = arith.addf {acc}, {arg} : f64"
            var_mapping[tmp] = tmp
            acc = tmp
        return acc

    
    
    if isinstance(exp, Number) and int(exp) == exp:
        base_mlir = _sympy_expr_to_mlir(base)
        acc = base_mlir
        abs_exp = abs(int(exp))
        for _ in range(abs_exp - 1):
            tmp = f"%x{counter[0]}"
            counter[0] += 1
            mlir_ops.append(f"{tmp} = arith.mulf {acc}, {base_mlir} : f64")
            acc = tmp
        if int(exp) > 0:
            return acc
        else:
            inv = f"%x{counter[0]}"
            counter[0] += 1
            mlir_ops.append(f"{inv} = arith.divf 1.0, {acc} : f64")
            return inv
    raise NotImplementedError(f"Unsupported expr type: {expr}")





from sympy import Symbol, Number, Add, Mul, Pow, Function, sin, cos, exp, preorder_traversal

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

    # Inject constants for unknown symbols (e.g., a(t) → %a = 1.0)
    for sym in preorder_traversal(reduced_expr):
        if isinstance(sym, Symbol):
            sname = str(sym)
            if sname not in var_mapping:
                tmp = f"%c{counter[0]}"
                counter[0] += 1
                mlir_ops.append(f"{tmp} = arith.constant 1.0 : f64")
                var_mapping[sname] = tmp

    result_expr = _sympy_expr_to_mlir(reduced_expr)
# Après avoir calculé result_expr
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
    from metric_codegen.frontends.metric_tensor import extract_metric_tensor
    from metric_codegen.optim.cse import run as run_cse
    import metric_codegen.backends.mlir as mlir_backend

    # 1) on récupère g (Sympy Matrix)
    g = extract_metric_tensor(latex_expr, coord_order)
    n = len(coord_order)

    body = []
    body.append("  %buf = memref.alloc() : memref<4x4xf64>")

    zero = "  %c0 = arith.constant 0.0 : f64"
    body.append(zero)

    for i in range(n):
        for j in range(n):
            expr = g[i,j]
            # applique CSE local
            repl, reduced = run_cse(expr)
            core = reduced[0]

            snippet = mlir_backend._sympy_to_mlir_snippet(
                repl, core, args, result_name="gij"
            )
            body.extend("  " + line for line in snippet.splitlines())

            body.append(f"  memref.store %gij, %buf[{i},{j}] : memref<4x4xf64>")

    args_sig = ", ".join(f"%{a}: f64" for a in args)
    return f"""
module {{
  func.func @{name}({args_sig}) -> memref<4x4xf64> {{
{chr(10).join(body)}
    return %buf : memref<4x4xf64>
  }}
}}
""".strip()



from sympy import Symbol
from sympy import Number

def _sympy_expr_to_mlir(expr, var_mapping, counter=[100]):
    from sympy import Add, Mul, Pow

    if expr in var_mapping:
        return var_mapping[expr]

    if isinstance(expr, Symbol):
        return f"%{str(expr)}"

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




from sympy import Symbol, Number, Add, Mul, Pow, Function, sin, cos, exp

def generate_mlir_code(name: str, repl: list, reduced_expr, args: list[str]) -> str:
    mlir_ops = []
    var_mapping = {str(sym): f"%{str(sym)}" for sym in args}
    counter = [0]

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
            # Special case: Pow(f(x), 2)
            if isinstance(base, Function) and exp == 2:
                base_op = func_table.get(base.func, None)
                if base_op:
                    arg_mlir = _sympy_expr_to_mlir(base.args[0])
                    tmp1 = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{tmp1} = {base_op} {arg_mlir} : f64")
                    tmp2 = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{tmp2} = arith.mulf {tmp1}, {tmp1} : f64")
                    return tmp2

            # Standard integer exponentiation
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
                    one = f"%c{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{one} = arith.constant 1.0 : f64")
                    tmp = f"%x{counter[0]}"
                    counter[0] += 1
                    mlir_ops.append(f"{tmp} = arith.divf {one}, {acc} : f64")
                    return tmp
            else:
                raise NotImplementedError("Only integer powers or Pow(f(x),2) supported")

        if isinstance(expr, Function):
            op = func_table.get(expr.func, None)
            if op:
                arg_mlir = _sympy_expr_to_mlir(expr.args[0])
                tmp = f"%x{counter[0]}"
                counter[0] += 1
                mlir_ops.append(f"{tmp} = {op} {arg_mlir} : f64")
                return tmp
            else:
                # Generic function like a(t) maps to %a
                return var_mapping.get(str(expr.func), f"%{str(expr.func)}")

        raise NotImplementedError(f"Unsupported expr type: {expr} of type {type(expr)}")

    for sym, rhs in repl:
        rhs_mlir = _sympy_expr_to_mlir(rhs)
        var_mapping[str(sym)] = rhs_mlir

    result_expr = _sympy_expr_to_mlir(reduced_expr)
    mlir_ops.append(f"%result = arith.addf {result_expr}, {result_expr} : f64")

    body = "\n    ".join(mlir_ops)
    args_fmt = ", ".join([f"%{a}: f64" for a in args])

    return f"""
module {{
  func.func @{name}({args_fmt}) -> f64 {{
    {body}
    return %result : f64
  }}
}}
""".strip()

import sympy as sp
import numpy as np
from metric_codegen.frontends.metric_tensor import extract_metric_tensor
from metric_codegen.optim.cse import run as run_cse
from metric_codegen.backends.mlir import _sympy_to_mlir_snippet

from sympy import sin, cos, tan, cot, exp   # ⬅︎ ajouter tan & cot

def christoffel_list(metric, coord_syms):
    """
    Retourne un tableau Python [i][j][k] de Γ^i_{jk}
    construit exactement comme EinsteinPy.from_metric.
    """
    n      = len(coord_syms)
    g_cov  = metric
    g_inv  = sp.Matrix(g_cov.tolist()).inv()
    Gamma  = np.zeros((n, n, n), dtype=object).tolist()

    for t in range(n ** 3):
        k = t % n
        j = (t // n) % n
        i = t // (n ** 2)

        if k > j:     # symétrie j↔k
            continue

        tmp = 0
        for l in range(n):
            tmp += (g_inv[i, l] / 2) * (
                sp.diff(g_cov[l, j], coord_syms[k])
                + sp.diff(g_cov[l, k], coord_syms[j])
                - sp.diff(g_cov[j, k], coord_syms[l])
            )
        tmp = sp.simplify(tmp)
        if tmp == sp.nan:
            tmp = 0

        Gamma[i][j][k] = Gamma[i][k][j] = tmp
        print(f"Γ^{i}_{j}{k} = {Gamma[i][j][k]}")

    return Gamma


def build_christoffel_mlir(name, latex_expr, coord_syms, mlir_args):
    g_cov = extract_metric_tensor(latex_expr, [str(c) for c in coord_syms])
    print(f"Extracted metric tensor from christoffel function: {g_cov}")
    cleanup = {s: 1.0 for s in sp.symbols("dt dr dtheta dphi dx dy dz")}
    g_cov   = g_cov.subs(cleanup)

    Gamma = christoffel_list(g_cov, coord_syms)

    mlir  = ["module {"]
    sig   = ", ".join(f"%{a}: f64" for a in mlir_args)
    mlir += [f"  func.func @{name}({sig}) -> memref<4x4x4xf64> {{",
             "    %buf = memref.alloc() : memref<4x4x4xf64>",
             "    %c0_f64 = arith.constant 0.0 : f64"]

    counter, idx_done = [0], set()
    n = len(coord_syms)

    for i in range(n):
        for j in range(n):
            for k in range(n):
                repl, red = run_cse(Gamma[i][j][k])
                core      = red[0]

                for line in _sympy_to_mlir_snippet(
                        repl, core, mlir_args, counter, f"g{i}{j}{k}"
                ):
                    mlir.append("    " + line)

                for idx in (i, j, k):
                    if idx not in idx_done:
                        mlir.append(f"    %c{idx}_idx = arith.constant {idx} : index")
                        idx_done.add(idx)

                mlir.append(
                    f"    memref.store %g{i}{j}{k}, "
                    f"%buf[%c{i}_idx, %c{j}_idx, %c{k}_idx] "
                    ": memref<4x4x4xf64>"
                )

    mlir += ["    return %buf : memref<4x4x4xf64>", "  }", "}"]
    return "\n".join(mlir)


from textwrap import indent


def gen_numeric_christoffel_mlir(
        dim: int = 4,
        func_name: str = "christoffel_numeric",
        metric_gen_sym: str = "metric_generator") -> str:

    def mem(shape): 
        return f"memref<{shape}xf64>" if isinstance(shape, int) \
               else f"memref<{shape}xf64>"

    f64   = " : f64"
    idx0  = "%c0_idx"
    idx1  = "%c1_idx"
    dim_i = "%c_dim"
    c0f   = "%c0_f64"
    c1f   = "%c1_f64"
    two   = "%two"


    lines = [
        "module {",
        f"  func.func private @{metric_gen_sym}(%x: {mem(dim)}, %g: {mem(f'{dim}x{dim}')}) -> ()",
        "",
        f"  func.func @{func_name}("
        f"%x: {mem(dim)}, "
        "%h: f64, "
        f"%g0:   {mem(f'{dim}x{dim}')}, "
        f"%ginv: {mem(f'{dim}x{dim}')}, "
        f"%out:  {mem(f'{dim}x{dim}x{dim}')}) {{",

        f"    {c0f} = arith.constant 0.0{f64}",
        f"    {c1f} = arith.constant 1.0{f64}",
        f"    {two} = arith.constant 2.0{f64}",
        f"    {idx0} = arith.constant 0 : index",
        f"    {idx1} = arith.constant 1 : index",
        f"    {dim_i} = arith.constant {dim} : index",

        f"    %dg  = memref.alloc() : {mem(f'{dim}x{dim}x{dim}')}",
        f"    %tmp = memref.alloc() : {mem(f'{dim}x{dim}x{dim}')}",
    ]


    lines += [
        "    scf.for %rho = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        f"      %x_plus  = memref.alloc() : {mem(dim)}",
        f"      %x_minus = memref.alloc() : {mem(dim)}",

        f"      memref.copy %x, %x_plus  : memref<4xf64> to {mem(dim)}",
        f"      memref.copy %x, %x_minus : memref<4xf64> to {mem(dim)}",

        f"      %v1 = memref.load %x_plus[%rho]  : {mem(dim)}",
        "      %v2 = arith.addf %v1, %h : f64",
        f"      memref.store %v2, %x_plus[%rho]  : {mem(dim)}",

        f"      %v3 = memref.load %x_minus[%rho] : {mem(dim)}",
        "      %v4 = arith.subf %v3, %h : f64",
        f"      memref.store %v4, %x_minus[%rho] : {mem(dim)}",

        f"      %g_plus  = memref.alloc() : {mem(f'{dim}x{dim}')}",
        f"      %g_minus = memref.alloc() : {mem(f'{dim}x{dim}')}",

        f"      func.call @{metric_gen_sym}(%x_plus,  %g_plus)"
        f" : ({mem(dim)}, {mem(f'{dim}x{dim}')}) -> ()",
        f"      func.call @{metric_gen_sym}(%x_minus, %g_minus)"
        f" : ({mem(dim)}, {mem(f'{dim}x{dim}')}) -> ()",

        "      scf.for %lam = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        "        scf.for %nu  = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        f"          %gp = memref.load %g_plus[%lam, %nu]  : {mem(f'{dim}x{dim}')}",
        f"          %gm = memref.load %g_minus[%lam, %nu] : {mem(f'{dim}x{dim}')}",
        "          %num = arith.subf %gp, %gm : f64",
        "          %den = arith.mulf " + two + ", %h : f64",
        "          %val = arith.divf %num, %den : f64",
        f"          memref.store %val, %dg[%lam, %nu, %rho] : {mem(f'{dim}x{dim}x{dim}')}",
        "        } }",

        f"      memref.dealloc %g_plus : {mem(f'{dim}x{dim}')}",
        f"      memref.dealloc %g_minus : {mem(f'{dim}x{dim}')}",
        f"      memref.dealloc %x_plus : {mem(dim)}",
        f"      memref.dealloc %x_minus : {mem(dim)}",
        "    }",  # end rho
    ]

    lines += [
        "    %half = arith.constant 0.5" + f64,
        "    scf.for %lam = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        "      scf.for %nu  = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        "        scf.for %mu  = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        f"          %d1 = memref.load %dg[%nu, %lam, %mu] : {mem(f'{dim}x{dim}x{dim}')}",
        f"          %d2 = memref.load %dg[%mu, %lam, %nu] : {mem(f'{dim}x{dim}x{dim}')}",
        f"          %d3 = memref.load %dg[%mu, %nu, %lam] : {mem(f'{dim}x{dim}x{dim}')}",
        "          %s1 = arith.addf %d1, %d2 : f64",
        "          %s2 = arith.subf %s1, %d3 : f64",
        "          %val = arith.mulf %half, %s2 : f64"  # Γ^lam_{nu mu},
        f"          memref.store %val, %tmp[%lam,%nu,%mu] : {mem(f'{dim}x{dim}x{dim}')}",
        "        } } }",
    ]


    lines += [
        "    scf.for %kap = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        "      scf.for %nu  = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        "        scf.for %mu  = " + idx0 + " to " + dim_i + " step " + idx1 + " {",
        f"          %acc_init = arith.constant 0.0{f64}",
        f"          %acc = scf.for %lam = {idx0} to {dim_i} step {idx1} "
        f"iter_args(%acc = %acc_init) -> f64 {{",
        f"            %gkl      = memref.load %ginv[%kap,%lam] : {mem(f'{dim}x{dim}')}",
        f"            %tpl      = memref.load %tmp[%lam,%nu,%mu] : {mem(f'{dim}x{dim}x{dim}')}",
        "            %prod     = arith.mulf %gkl, %tpl : f64",
        "            %acc_next = arith.addf %acc, %prod : f64",
        "            scf.yield %acc_next : f64",
        "          }",
        f"          memref.store %acc, %out[%kap,%nu,%mu] : {mem(f'{dim}x{dim}x{dim}')}",
        "        } } }",
    ]


    lines += ["    return", "  }", "}"]
    return indent("\n".join(lines), "")


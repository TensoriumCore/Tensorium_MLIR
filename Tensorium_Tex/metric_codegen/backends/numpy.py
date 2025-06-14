from sympy import lambdify
from numba import njit

def jit_function(expr, args=("x",)):
    f = lambdify(args, expr, modules="numpy")
    return njit(f)

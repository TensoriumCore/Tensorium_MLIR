
from sympy import cse, symbols as make_symbols

def run(expr, symbols_prefix="x"):
    from itertools import count
    syms = (make_symbols(f"{symbols_prefix}{i}") for i in count())
    return cse(expr, symbols=syms)


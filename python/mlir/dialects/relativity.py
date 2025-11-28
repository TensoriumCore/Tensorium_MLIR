from mlir import ir as _ir

from mlir.dialects import _relativity_ops as _rel_c_ext

from ._relativity_ops_gen import *

def register_passes():
    _rel_c_ext.register_passes()

def register_dialect(context: _ir.Context, load: bool = True):
    _rel_c_ext.register_dialect(context._CAPIPtr, load)

__all__ = [
    *[name for name in globals().keys()
      if not name.startswith("_") and name not in ("register_dialect", "register_passes")],
    "register_dialect",
    "register_passes",
]

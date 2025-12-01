from mlir.ir import Context
from . import _relativity_ops_gen
from . import _relativity_ops


def register_dialect(context: Context, load: bool = True):
    _relativity_ops.register_dialect(context._CAPIPtr, load)


def register_passes():
    _relativity_ops.register_passes()


__all__ = [
    "register_dialect",
    "register_passes",
] + [name for name in dir(_relativity_ops_gen) if not name.startswith("_")]

globals().update({name: getattr(_relativity_ops_gen, name)
                  for name in dir(_relativity_ops_gen) if not name.startswith("_")})

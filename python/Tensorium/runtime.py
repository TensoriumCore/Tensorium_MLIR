import ctypes
import numpy as np
import os

try:
    from .dialects import _tensorium_runtime
except ImportError:
    import _tensorium_runtime


def get_memref_descriptor(array: np.ndarray):
    if array.dtype != np.float64:
        raise TypeError(f" float64 needed, received {array.dtype}")

    if not array.flags['C_CONTIGUOUS']:
        array = np.ascontiguousarray(array)

    rank = array.ndim
    if rank == 1:
        return _tensorium_runtime.MemRefDescriptor1D(array)
    elif rank == 2:
        return _tensorium_runtime.MemRefDescriptor2D(array)
    elif rank == 3:
        return _tensorium_runtime.MemRefDescriptor3D(array)
    else:
        raise ValueError(f"Rank {rank} not supported")


def make_memref_ctype(rank):
    class MemRefType(ctypes.Structure):
        _fields_ = [
            ("allocated", ctypes.c_void_p),
            ("aligned", ctypes.c_void_p),
            ("offset", ctypes.c_int64),
            ("sizes", ctypes.c_int64 * rank),
            ("strides", ctypes.c_int64 * rank),
        ]

        def to_numpy(self):
            if not self.aligned:
                return None
            shape = tuple(self.sizes)
            src_ptr = ctypes.cast(
                self.aligned, ctypes.POINTER(ctypes.c_double))
            return np.ctypeslib.as_array(src_ptr, shape=shape).copy()

    return MemRefType


MemRef1DF64 = make_memref_ctype(1)
MemRef2DF64 = make_memref_ctype(2)
MemRef3DF64 = make_memref_ctype(3)


class GridMetric1DRet(ctypes.Structure):
    _fields_ = [
        ("alpha", MemRef1DF64),
        ("beta",  MemRef2DF64),
        ("gamma", MemRef3DF64),
    ]


def extract_results(metric_struct: GridMetric1DRet):
    return (
        metric_struct.alpha.to_numpy(),
        metric_struct.beta.to_numpy(),
        metric_struct.gamma.to_numpy()
    )


class Kernel:
    def __init__(self, lib_path, func_name="GridMetric1D"):
        if not os.path.exists(lib_path):
            raise FileNotFoundError(f"Lib not found: {lib_path}")

        self.lib = ctypes.CDLL(lib_path)

        symbol = f"_mlir_ciface_{func_name}"
        if not hasattr(self.lib, symbol):
            if hasattr(self.lib, func_name):
                symbol = func_name
            else:
                raise AttributeError(
                    f"{symbol}: Not found in {lib_path}")

        self.func = getattr(self.lib, symbol)
        self.func.restype = None

    def __call__(self, coords_np):
        coords_desc = get_memref_descriptor(coords_np)
        out = GridMetric1DRet()
        self.func(ctypes.byref(out), ctypes.c_void_p(coords_desc.ptr))
        return extract_results(out)

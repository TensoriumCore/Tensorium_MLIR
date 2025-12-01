#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include "Runtime/TensoriumRuntime.h" 

namespace py = pybind11;

template <int Rank>
class MemRefDescriptor {
    StridedMemRef<double, Rank> descriptor;
    py::array_t<double> original_array; 

public:
    MemRefDescriptor(py::array_t<double> array) : original_array(array) {
        py::buffer_info buf = array.request();
        if (buf.ndim != Rank) throw std::runtime_error("Rank mismatch");

        std::vector<int64_t> dims(Rank);
        for (int i = 0; i < Rank; ++i) dims[i] = buf.shape[i];

        descriptor = StridedMemRef<double, Rank>(
            static_cast<double*>(buf.ptr),
            dims
        );
    }

    uintptr_t get_struct_ptr() const {
        return reinterpret_cast<uintptr_t>(&descriptor);
    }
};

PYBIND11_MODULE(_tensorium_runtime, m) {
    py::class_<MemRefDescriptor<1>>(m, "MemRefDescriptor1D")
        .def(py::init<py::array_t<double>>())
        .def_property_readonly("ptr", &MemRefDescriptor<1>::get_struct_ptr);

    py::class_<MemRefDescriptor<2>>(m, "MemRefDescriptor2D")
        .def(py::init<py::array_t<double>>())
        .def_property_readonly("ptr", &MemRefDescriptor<2>::get_struct_ptr);

    py::class_<MemRefDescriptor<3>>(m, "MemRefDescriptor3D")
        .def(py::init<py::array_t<double>>())
        .def_property_readonly("ptr", &MemRefDescriptor<3>::get_struct_ptr);
        
}

#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_gpu"))) void overloaded(double x) { UNUSED(x); }

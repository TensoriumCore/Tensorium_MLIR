#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_gpu"))) void baz(int x) { UNUSED(x); }

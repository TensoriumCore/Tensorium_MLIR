#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_gpu"))) void qux(double y, int x) {
  UNUSED(y);
  UNUSED(x);
}

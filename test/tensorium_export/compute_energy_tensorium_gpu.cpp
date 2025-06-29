#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_gpu"))) double compute_energy(double mass, double velocity, int power) {
  double vpow = 1.0;
  for (int i = 0; i < power; ++i)
    vpow *= velocity;
  return 0.5 * mass * vpow;
}

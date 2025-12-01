#include "../../include/Runtime/TensoriumRuntime.h"

struct GridMetric1DRet {
  StridedMemRef<double, 1> alpha;
  StridedMemRef<double, 2> beta;
  StridedMemRef<double, 3> gamma;
};

extern "C" void _mlir_ciface_GridMetric1D(GridMetric1DRet *out, 
                                          StridedMemRef<double, 2> *coords);

void printCoords(const StridedMemRef<double, 2> &C) {
  printf("coords (t, x, y, z):\n");
  for (int i = 0; i < C.sizes[0]; i++) {
    printf("  [%2d] (%.4f, %.4f, %.4f, %.4f)\n", i, 
           C(i, 0), C(i, 1), C(i, 2), C(i, 3));
  }
  printf("\n");
}

int main() {
  const int H = 10, W = 4;
  StridedMemRef<double, 2> coords({H, W});

  for (int i = 0; i < H; i++) {
    coords(i, 0) = 0.0;
    coords(i, 1) = 1.0 + 0.1 * i;
    coords(i, 2) = 1.0;
    coords(i, 3) = 4.0;
  }

  GridMetric1DRet out; 

  _mlir_ciface_GridMetric1D(&out, &coords);

  printf("Schwarzschild KS 3+1 decomposition\n\n");
  printCoords(coords);

  printf("Alpha[0]: %.10f\n", out.alpha(0));
  
  return 0;
}

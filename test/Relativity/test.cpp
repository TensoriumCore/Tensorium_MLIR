#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cmath>

struct MemRef3x3F64 {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
};

struct DetInvRet {
  double det;
  MemRef3x3F64 inv;
};

extern "C" {
  void _mlir_ciface_SchwarzschildSpatial(MemRef3x3F64 *out,
                                         double t, double x, double y, double z);
  void _mlir_ciface_DetInvGamma(DetInvRet *out,
                                double t, double x, double y, double z);
}

static inline long idx_of(const MemRef3x3F64 &A, int i, int j) {
  return A.offset + (long)i * A.strides[0] + (long)j * A.strides[1];
}

static void printMat3(const char *title, const MemRef3x3F64 &A) {
  std::printf("%s (sizes=[%ld,%ld], strides=[%ld,%ld], offset=%ld)\n",
              title, (long)A.sizes[0], (long)A.sizes[1],
              (long)A.strides[0], (long)A.strides[1], (long)A.offset);
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      std::printf(" % .16e", A.aligned[idx_of(A, i, j)]);
    }
    std::puts("");
  }
}

static double matmul_max_err_I3(const MemRef3x3F64 &A,
                                const MemRef3x3F64 &B) {
  double maxe = 0.0;
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      double s = 0.0;
      for (int k = 0; k < 3; ++k)
        s += A.aligned[idx_of(A, i, k)] * B.aligned[idx_of(B, k, j)];
      double target = (i == j) ? 1.0 : 0.0;
      double e = std::fabs(s - target);
      if (e > maxe) maxe = e;
    }
  }
  return maxe;
}




int main() {
  double t = 0.0, x = 1.0, y = 1.0, z = 1.0;

  std::printf("Testing Schwarzschild spatial metric at:\n");
  std::printf("X = [%.16e, %.16e, %.16e, %.16e]\n\n", t, x, y, z);

  MemRef3x3F64 gamma{};
  _mlir_ciface_SchwarzschildSpatial(&gamma, t, x, y, z);
  printMat3("gamma (spatial metric)", gamma);

  DetInvRet di{};
  _mlir_ciface_DetInvGamma(&di, t, x, y, z);
  std::printf("\ndet(gamma) = %.16e\n\n", di.det);
  printMat3("gamma^{-1} (inverse)", di.inv);

  double maxErr = matmul_max_err_I3(gamma, di.inv);
  std::printf("\nmax|gamma*inv - I| = %.3e\n", maxErr);

  std::free(gamma.allocated);
  std::free(di.inv.allocated);
  return 0;
}


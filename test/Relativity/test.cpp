#include <cstdint>
#include <cstdio>
#include <cstdlib>

struct MemRef3x3F64 {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
};

using v4f64 = double __attribute__((vector_size(32)));

extern "C" {
MemRef3x3F64 SchwarzschildSpatial(v4f64 x);

struct DetInvRet {
  double det;
  MemRef3x3F64 inv;
};
DetInvRet DetInvGamma(v4f64 x);
}

static void printMat3(const char *title, const MemRef3x3F64 &A) {
  // std::printf("%s (sizes=[%ld,%ld], strides=[%ld,%ld])\n", title,
  //             (long)A.sizes[0], (long)A.sizes[1], (long)A.strides[0],
  //             (long)A.strides[1]);
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      long idx = A.offset + i * A.strides[0] + j * A.strides[1];
      std::printf(" % .16e", A.aligned[idx]);
    }
    std::puts("");
  }
}

int main() {
  v4f64 X = {1.0, 1.0, 1.0, 1.0};
  printf("Testing Schwarzschild spatial metric at:\n");
  printf("X = [%.16e, %.16e, %.16e]\n\n", X[0], X[1], X[2]);


  printf("struct MemRef3x3F64 aligned=%p offset=%ld sizes=[%ld,%ld] "
		 "strides=[%ld,%ld]\n",
		 (void *)0, (long)0, (long)3, (long)3, (long)3, (long)1);

  MemRef3x3F64 gamma = SchwarzschildSpatial(X);
  printMat3("gamma (spatial metric)", gamma);

  DetInvRet di = DetInvGamma(X);
  std::printf("\ndet(gamma) = %.16e\n\n", di.det);
  printMat3("gamma^{-1} (inverse)", di.inv);

  std::free(gamma.allocated);
  std::free(di.inv.allocated);
  return 0;
}

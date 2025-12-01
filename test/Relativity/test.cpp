#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[1];
  int64_t strides[1];
} MemRef1DF64;

typedef struct {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
} MemRef2DF64;

typedef struct {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[3];
  int64_t strides[3];
} MemRef3DF64;

typedef struct {
  MemRef1DF64 alpha;
  MemRef2DF64 beta;
  MemRef3DF64 gamma;
} GridMetric1DRet;

extern "C" void _mlir_ciface_GridMetric1D(GridMetric1DRet *out,
                                          MemRef2DF64 *coords);
static inline int64_t idx1(const MemRef1DF64 &A, int i) {
  return A.offset + i * A.strides[0];
}

static inline int64_t idx2(const MemRef2DF64 &A, int i, int j) {
  return A.offset + i * A.strides[0] + j * A.strides[1];
}

static inline int64_t idx3(const MemRef3DF64 &A, int i, int j, int k) {
  return A.offset + i * A.strides[0] + j * A.strides[1] + k * A.strides[2];
}

void printAlpha(const MemRef1DF64 &A) {
  printf("alpha:\n");
  for (int i = 0; i < A.sizes[0]; i++)
    printf("  [%2d] %.10f\n", i, A.aligned[idx1(A, i)]);
}

void printCoords(const MemRef2DF64 &C) {
  printf("coords (t, x, y, z):\n");
  for (int i = 0; i < C.sizes[0]; i++) {
    double t = C.aligned[idx2(C, i, 0)];
    double x = C.aligned[idx2(C, i, 1)];
    double y = C.aligned[idx2(C, i, 2)];
    double z = C.aligned[idx2(C, i, 3)];
    printf("  [%2d] (%.10f, %.10f, %.10f, %.10f)\n", i, t, x, y, z);
  }
  printf("\n");
}
void printBeta(const MemRef2DF64 &B) {
  printf("beta:\n");
  for (int i = 0; i < B.sizes[0]; i++) {
    double bx = B.aligned[idx2(B, i, 0)];
    double by = B.aligned[idx2(B, i, 1)];
    double bz = B.aligned[idx2(B, i, 2)];
    printf("  [%2d] [%.10f %.10f %.10f]\n", i, bx, by, bz);
  }
}

void printGamma(const MemRef3DF64 &G) {
  printf("gamma:\n");
  for (int p = 0; p < G.sizes[0]; p++) {
    printf("  [%2d]\n", p);
    for (int i = 0; i < 3; i++) {
      printf("       ");
      for (int j = 0; j < 3; j++)
        printf(" %.10f", G.aligned[idx3(G, p, i, j)]);
      printf("\n");
    }
  }
}
MemRef2DF64 make_coords() {
  MemRef2DF64 A;
  const int H = 10, W = 4;

  A.sizes[0] = H;
  A.sizes[1] = W;
  A.strides[1] = 1;
  A.strides[0] = W;
  A.offset = 0;

  size_t nbytes = H * W * sizeof(double);

  void *ptr = nullptr;
  if (posix_memalign(&ptr, 64, nbytes) != 0) {
    fprintf(stderr, "posix_memalign failed\n");
    exit(1);
  }
  A.allocated = (double *)ptr;
  A.aligned = A.allocated;

  for (int i = 0; i < H; i++) {
    A.aligned[i * W + 0] = 0.0;
    A.aligned[i * W + 1] = 1.0 + 0.1 * i;
    A.aligned[i * W + 2] = 1.0;
    A.aligned[i * W + 3] = 4.0;
  }
  return A;
}

int main() {

  MemRef2DF64 coords = make_coords();
  GridMetric1DRet out;

  _mlir_ciface_GridMetric1D(&out, &coords);
  printf("Schwarzschild KS 3+1 decomposition\n\n");
  printCoords(coords);
  printAlpha(out.alpha);
  printBeta(out.beta);
  printGamma(out.gamma);

  free(coords.allocated);
  free(out.alpha.allocated);
  free(out.beta.allocated);
  free(out.gamma.allocated);

  return 0;
}

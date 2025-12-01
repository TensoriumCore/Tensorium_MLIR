#include <vector>
#include <iostream>
#include <numeric>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <type_traits>

template <typename T, int Rank>
struct StridedMemRef {
  T *allocated;
  T *aligned;
  int64_t offset;
  int64_t sizes[Rank];
  int64_t strides[Rank];

  StridedMemRef() : allocated(nullptr), aligned(nullptr), offset(0) {}

  StridedMemRef(const std::vector<int64_t> &dims) {
    if (dims.size() != Rank) {
      fprintf(stderr, "Error: Dimension mismatch\n");
      exit(1);
    }

    offset = 0;
    int64_t total_size = 1;
    for (int i = Rank - 1; i >= 0; --i) {
      sizes[i] = dims[i];
      strides[i] = (i == Rank - 1) ? 1 : strides[i + 1] * sizes[i + 1];
      total_size *= sizes[i];
    }

    size_t nbytes = total_size * sizeof(T);
    void *ptr = nullptr;
    if (posix_memalign(&ptr, 64, nbytes) != 0) {
      fprintf(stderr, "Allocation failed\n");
      exit(1);
    }
    allocated = (T *)ptr;
    aligned = allocated;
  }

  StridedMemRef(const StridedMemRef &) = delete;
  StridedMemRef &operator=(const StridedMemRef &) = delete;

  StridedMemRef(StridedMemRef &&other) noexcept {
    *this = std::move(other);
  }

  StridedMemRef &operator=(StridedMemRef &&other) noexcept {
    if (this != &other) {
      if (allocated) free(allocated);
      allocated = other.allocated;
      aligned = other.aligned;
      offset = other.offset;
      memcpy(sizes, other.sizes, sizeof(sizes));
      memcpy(strides, other.strides, sizeof(strides));
      other.allocated = nullptr;
      other.aligned = nullptr;
    }
    return *this;
  }

  ~StridedMemRef() {
    if (allocated) free(allocated);
  }

  template<typename... Args>
  T& operator()(Args... indices) {
    return aligned[offset + linearize(0, indices...)];
  }

  template<typename... Args>
  const T& operator()(Args... indices) const {
    return aligned[offset + linearize(0, indices...)];
  }

private:
  template<typename Arg, typename... Args>
  int64_t linearize(int dim, Arg idx, Args... rest) const {
    return idx * strides[dim] + linearize(dim + 1, rest...);
  }
  
  int64_t linearize(int dim) const { return 0; }
};

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

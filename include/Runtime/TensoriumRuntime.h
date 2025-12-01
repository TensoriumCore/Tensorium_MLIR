#pragma once
#include <cstdint>
#include <cstdlib>
#include <vector>
#include <numeric>
#include <cstring>
#include <utility>
#include <stdexcept>

template <typename T, int Rank>
struct StridedMemRef {
  T *allocated;
  T *aligned;
  int64_t offset;
  int64_t sizes[Rank];
  int64_t strides[Rank];

  StridedMemRef() : allocated(nullptr), aligned(nullptr), offset(0) {
    std::memset(sizes, 0, sizeof(sizes));
    std::memset(strides, 0, sizeof(strides));
  }

  StridedMemRef(const std::vector<int64_t> &dims) {
    if (dims.size() != Rank) std::abort();
    offset = 0;
    int64_t total = 1;
    for (int i = Rank - 1; i >= 0; --i) {
      sizes[i] = dims[i];
      strides[i] = (i == Rank - 1) ? 1 : strides[i + 1] * sizes[i + 1];
      total *= sizes[i];
    }
    if (posix_memalign((void **)&allocated, 64, total * sizeof(T)) != 0) std::abort();
    aligned = allocated;
  }

  StridedMemRef(T *data, const std::vector<int64_t> &dims) {
    if (dims.size() != Rank) std::abort();
    allocated = nullptr; 
    aligned = data;
    offset = 0;
    for (int i = Rank - 1; i >= 0; --i) {
      sizes[i] = dims[i];
      strides[i] = (i == Rank - 1) ? 1 : strides[i + 1] * sizes[i + 1];
    }
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
      std::memcpy(sizes, other.sizes, sizeof(sizes));
      std::memcpy(strides, other.strides, sizeof(strides));
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

#include <xmmintrin.h>
#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_gpu"))) void test_simd_intrinsic() {
  __m128 a = _mm_set1_ps(1.0f);
  __m128 b = _mm_set1_ps(2.0f);
  __m128 c = _mm_add_ps(a, b);
  float res[4];
  _mm_storeu_ps(res, c);
  UNUSED(res);
}

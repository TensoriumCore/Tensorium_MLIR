#include <xmmintrin.h>
#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_cpu"))) static __inline__ __m128 __DEFAULT_FN_ATTRS_CONSTEXPR
_mm_add_ps(__m128 __a, __m128 __b) {
  return (__m128)((__v4sf)__a + (__v4sf)__b);
}

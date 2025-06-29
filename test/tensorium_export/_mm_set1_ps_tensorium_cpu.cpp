#include <xmmintrin.h>
#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_cpu"))) static __inline__ __m128 __DEFAULT_FN_ATTRS_CONSTEXPR
_mm_set1_ps(float __w) {
  return __extension__ (__m128){ __w, __w, __w, __w };
}

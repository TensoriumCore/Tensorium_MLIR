#include <xmmintrin.h>
#define UNUSED(x) (void)(x)
__attribute__((annotate("tensorium_cpu"))) static __inline__ void __DEFAULT_FN_ATTRS
_mm_storeu_ps(float *__p, __m128 __a)
{
  struct __storeu_ps {
    __m128_u __v;
  } __attribute__((__packed__, __may_alias__));
  ((struct __storeu_ps*)__p)->__v = __a;
}

#ifdef __x86_64__
#include <xmmintrin.h>
#include <immintrin.h>
#endif

#define UNUSED(x) (void)(x)
#pragma tensorium target(cpu)
void foo() {}

void bar() {}

void baz(int x) { UNUSED(x); }

void qux(double y, int x) {
  UNUSED(y);
  UNUSED(x);
}

static void staticfunc() {}

inline void inlinefunc() {}

void overloaded();
void overloaded(int);
void overloaded(double);

void overloaded() {}
void overloaded(int x) { UNUSED(x); }
void overloaded(double x) { UNUSED(x); }

void proto_func();
void proto_func() {}

double compute_energy(double mass, double velocity, int power) {
  double vpow = 1.0;
  for (int i = 0; i < power; ++i)
    vpow *= velocity;
  return 0.5 * mass * vpow;
}

#ifndef __TENSORIUM_GPU__
#ifdef __x86_64__
#include <xmmintrin.h>
#include <immintrin.h>
#endif
void test_simd_intrinsic() {
  __m128 a = _mm_set1_ps(1.0f);
  __m128 b = _mm_set1_ps(2.0f);
  __m128 c = _mm_add_ps(a, b);
  float res[4];
  _mm_storeu_ps(res, c);
  UNUSED(res);
}
#endif

int global = 0;

int main() {
// --- Simple call ---
#pragma tensorium target(gpu)
  foo();

// --- Multiple calls (un pragma chacun) ---
#pragma tensorium target(gpu)
  bar();
#pragma tensorium target(gpu)
  baz(123);

// --- Static & Inline ---
#pragma tensorium target(gpu)
  staticfunc();
#pragma tensorium target(gpu)
  inlinefunc();

// --- Overloaded ---
#pragma tensorium target(gpu)
  overloaded();
#pragma tensorium target(gpu)
  overloaded(42);
#pragma tensorium target(gpu)
  overloaded(3.14);

// --- Prototype/Separate declaration ---
#pragma tensorium target(gpu)
  proto_func();

// --- With params ---
#pragma tensorium target(gpu)
  qux(1.23, 4);

// --- Affectation simple (toujours un call simple à annoter) ---
#pragma tensorium target(gpu)
  global = 123;

#pragma tensorium target(gpu)
  compute_energy(1.2, 3.4, 2);

// --- SIMD intrinsic ---
// Ne compile que si on n'est PAS sur GPU
#ifndef __TENSORIUM_GPU__
#pragma tensorium target(gpu)
  test_simd_intrinsic();
#endif

  return 0;
}

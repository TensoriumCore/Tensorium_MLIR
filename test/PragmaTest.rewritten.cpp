#define TENSORIUM_DISPATCH(target, call) call
#define UNUSED(x) (void)(x)

#pragma tensorium target(cpu)
__attribute__((annotate("tensorium_gpu"))) void foo() {}

__attribute__((annotate("tensorium_gpu"))) void bar() {}

__attribute__((annotate("tensorium_gpu"))) void baz(int x) { UNUSED(x); }

__attribute__((annotate("tensorium_gpu"))) void qux(double y, int x) { UNUSED(y); UNUSED(x); }

__attribute__((annotate("tensorium_gpu"))) static void staticfunc() {}

__attribute__((annotate("tensorium_gpu"))) inline void inlinefunc() {}

void overloaded();
void overloaded(int);
void overloaded(double);

__attribute__((annotate("tensorium_gpu"))) void overloaded() {}
__attribute__((annotate("tensorium_gpu"))) void overloaded(int x) { UNUSED(x); }
__attribute__((annotate("tensorium_gpu"))) void overloaded(double x) { UNUSED(x); }

void proto_func();
__attribute__((annotate("tensorium_gpu"))) void proto_func() {}

__attribute__((annotate("tensorium_gpu"))) double compute_energy(double mass, double velocity, int power) {
    double vpow = 1.0;
    for(int i = 0; i < power; ++i)
        vpow *= velocity;
    return 0.5 * mass * vpow;
}


int global = 0;

int main() {
    // --- Simple call ---
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", foo());

    // --- Multiple calls (un pragma chacun) ---
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", bar());
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", baz(123));

    // --- Static & Inline ---
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", staticfunc());
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", inlinefunc());

    // --- Overloaded ---
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", overloaded());
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", overloaded(42));
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", overloaded(3.14));

    // --- Prototype/Separate declaration ---
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", proto_func());

    // --- With params ---
    #pragma tensorium target(gpu)
    TENSORIUM_DISPATCH("gpu", qux(1.23, 4));

    // --- Affectation simple (toujours un call simple à annoter) ---
    #pragma tensorium target(gpu)
    global = 123;

	#pragma tensorium target(gpu)
	TENSORIUM_DISPATCH("gpu", compute_energy(1.2, 3.4, 2));

    return 0;
}

#include <iostream>
#include <iomanip>
#include <cmath>

template <int Rank>
struct Memref {
    double*  allocated;
    double*  aligned;
    int64_t  offset;
    int64_t  sizes  [Rank];
    int64_t  strides[Rank];
};

extern "C" Memref<2> schwarzschild_tensor      (double, double, double, double, double, double);
extern "C" Memref<2> minkowski_tensor          (double, double, double, double, double, double);
extern "C" Memref<2> Random_tensor			   (double, double, double, double, double, double);
extern "C" Memref<2> flrw_flat_tensor		   (double, double, double, double, double, double);

extern "C" void metric_generator(Memref<1> /*x*/, Memref<2> g) {
    int64_t N0 = g.sizes[0];
    int64_t N1 = g.sizes[1];
    for (int64_t i = 0; i < N0; ++i) {
        for (int64_t j = 0; j < N1; ++j) {
            int64_t idx = g.offset
                          + i * g.strides[0]
                          + j * g.strides[1];
            g.aligned[idx] = 0.0;
        }
    }
}


void print_metric(const char* title, const Memref<2>& g) {
    std::cout << title << '\n';
    for (int i = 0; i < g.sizes[0]; ++i) {
        for (int j = 0; j < g.sizes[1]; ++j) {
            auto idx = g.offset + i * g.strides[0] + j * g.strides[1];
            std::cout << std::setw(12) << g.aligned[idx] << ' ';
        }
        std::cout << '\n';
    }
}

void print_christoffel(const char* title, const Memref<3>& Γ) {
    std::cout << title << " (non-zero entries):\n";
    for (int mu = 0; mu < Γ.sizes[0]; ++mu)
        for (int nu = 0; nu < Γ.sizes[1]; ++nu)
            for (int rho = 0; rho < Γ.sizes[2]; ++rho) {
                auto idx = Γ.offset
                         + mu  * Γ.strides[0]
                         + nu  * Γ.strides[1]
                         + rho * Γ.strides[2];
                double val = Γ.aligned[idx];
                if (std::abs(val) > 1e-14)  
                    std::cout << "  Γ^" << mu << "_{" << nu << rho << "} = "
                              << val << '\n';
            }
}

void compare_christoffel(const Memref<3>& analytic, const Memref<3>& numeric) {
    std::cout << "\nComparison (analytic vs numeric, abs diff > 1e-8):\n";
    for (int mu = 0; mu < analytic.sizes[0]; ++mu)
        for (int nu = 0; nu < analytic.sizes[1]; ++nu)
            for (int rho = 0; rho < analytic.sizes[2]; ++rho) {
                auto idx = analytic.offset
                         + mu  * analytic.strides[0]
                         + nu  * analytic.strides[1]
                         + rho * analytic.strides[2];
                double a = analytic.aligned[idx];
                double n = numeric  .aligned[idx];
                double d = std::abs(a - n);
                if (d > 1e-8) {
                    std::cout << "  (" << mu << "," << nu << "," << rho << ")  A="
                              << a << ", N=" << n << ", Δ=" << d << '\n';
                }
            }
}

int main() {
    constexpr double t = 1.0, r = 10.0, th = 0.1, ph = 0.1, m = 1.0, a = 0.0;

    auto gS  = schwarzschild_tensor      (t, r, th, ph, m, a);
    auto gM  = minkowski_tensor          (t, r, th, ph, m, a);
	auto gR	 = Random_tensor			 (t, r, th, ph, m, a);
	auto gFL = flrw_flat_tensor			 (t, r, th, ph, m, a);
    print_metric("Schwarzschild metric :", gS);
    print_metric("\nMinkowski metric :",    gM);
	print_metric("\nRandom metric",		gR);
	print_metric("\nFLRW metric",		gFL);
    return 0;
}

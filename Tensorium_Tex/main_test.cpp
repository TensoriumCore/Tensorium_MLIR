
#include <iostream>
#include <iomanip>

struct Memref4x4 {
    double*  allocated;
    double*  aligned;
    int64_t  offset;
    int64_t  sizes[2];
    int64_t  strides[2];
};

extern "C" Memref4x4 schwarzschild_tensor(double, double, double, double,
                                          double, double);
extern "C" Memref4x4 minkowski_tensor(double, double, double, double,
										  double, double);

int main() {
    auto g = schwarzschild_tensor(1.0, 10.0, 0.1, 0.1, 1.0, 0.0);

    std::cout << "Schwarzschild metric (t=1, r=10, θ=0.1, φ=0.1, m=1):\n";
    for (int i = 0; i < g.sizes[0]; ++i) {
        for (int j = 0; j < g.sizes[1]; ++j) {
            int64_t idx = g.offset + i * g.strides[0] + j * g.strides[1];
            std::cout << std::setw(12) << g.aligned[idx] << ' ';
        }
        std::cout << '\n';
    }

	auto m = minkowski_tensor(1.0, 10.0, 0.1, 0.1, 1.0, 0.0);
	std::cout << "Minkowski metric (t=1, r=10, θ=0.1, φ=0.1, m=1):\n";
	for (int i = 0; i < m.sizes[0]; ++i) {
		for (int j = 0; j < m.sizes[1]; ++j) {
			int64_t idx = m.offset + i * m.strides[0] + j * m.strides[1];
			std::cout << std::setw(12) << m.aligned[idx] << ' ';
		}
		std::cout << '\n';
	}
    return 0;
}


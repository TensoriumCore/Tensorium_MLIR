
#include <iostream>

extern "C" double schwarzschild(double t, double r, double theta, double phi);
extern "C" double flrw_flat(double t, double r, double theta, double phi);
extern "C" double kerr_schild_simple(double t, double r, double theta, double phi);

int main() {
    std::cout << "schwarzschild(1, 10, 0.1, 0.10) = " << schwarzschild(1, 10, 0.1, 0.10) << "\n";
    std::cout << "flrw_flat(1, 10, 0.1, 0.10) = " << flrw_flat(1, 10, 0.1, 0.10) << "\n";
	std::cout << "kerr_schild_simple(1, 10, 0.1, 0.10) = " << kerr_schild_simple(1, 10, 0.1, 0.10) << "\n";
    return 0;
}


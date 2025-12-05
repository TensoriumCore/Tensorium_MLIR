#include <iostream>
#include <cmath>
#include <vector>
#include <string>
#include <iomanip>

extern "C" {
    double g_tt(double M, double rho, double r); 
    double g_rr(double Delta, double rho);
    double g_thetatheta(double rho);
    double g_phiphi(double M, double rho, double theta, double a, double r);
    double g_phit(double M, double rho, double theta, double a, double r);
}

void check(std::string name, double computed, double theoretical) {
    double diff = std::abs(computed - theoretical);
    std::cout << std::left << std::setw(15) << name 
              << " | Comp: " << std::setw(10) << computed 
              << " | Theo: " << std::setw(10) << theoretical;
    
    if (diff < 1e-6) std::cout << " | MATCH\n";
    else             std::cout << " | MISMATCH (diff=" << diff << ")\n";
}

int main() {
    double M = 1.0;
    double a = 0.935;
    double r = 4.0;
    double theta = M_PI / 3.0;

    double rho2 = r*r + a*a * std::pow(std::cos(theta), 2);
    double rho = std::sqrt(rho2);
    double Delta = r*r - 2.0*M*r + a*a;
    double sin2 = std::pow(std::sin(theta), 2);

    std::cout << "========================================\n";
    std::cout << "       KERR METRIC VALIDATION TEST      \n";
    std::cout << "========================================\n";
    std::cout << "Parameters: M=" << M << ", a=" << a << ", r=" << r << ", theta=60deg\n";
    std::cout << "Implicit: rho=" << rho << " (rho^2=" << rho2 << "), Delta=" << Delta << "\n";
    std::cout << "----------------------------------------------------------------------\n";

    double val_tt = g_tt(M, rho, r);
    double theo_tt = -(1.0 - (2.0 * M * r) / rho2);
    check("g_tt", val_tt, theo_tt);

    double val_rr = g_rr(Delta, rho);
    double theo_rr = rho2 / Delta;
    check("g_rr", val_rr, theo_rr);

    double val_thth = g_thetatheta(rho);
    double theo_thth = rho2;
    check("g_thth", val_thth, theo_thth);

    double val_phph = g_phiphi(M, rho, theta, a, r);
    double term_masse = (2.0 * M * a*a * r * sin2) / rho2;
    double theo_phphi = (r*r + a*a + term_masse) * sin2;
    check("g_phiphi", val_phph, theo_phphi);

    double val_tphi_term = g_phit(M, rho, theta, a, r);
    double theo_tphi = - (4.0 * M * a * r * sin2) / rho2;
    check("g_tphi_term", val_tphi_term, theo_tphi);

    std::cout << "========================================\n";
    std::cout << "       FULL METRIC TENSOR (g_mu_nu)     \n";
    std::cout << "========================================\n";

    double g_tphi = val_tphi_term / 2.0;

    double metric[4][4] = {
        {val_tt,  0.0,     0.0,      g_tphi},
        {0.0,     val_rr,  0.0,      0.0},
        {0.0,     0.0,     val_thth, 0.0},
        {g_tphi,  0.0,     0.0,      val_phph}
    };

    std::cout << std::fixed << std::setprecision(4);
    std::cout << "   t        r        theta    phi\n";
    for(int i = 0; i < 4; ++i) {
        std::cout << "| ";
        for(int j = 0; j < 4; ++j) {
            std::cout << std::setw(8) << metric[i][j] << " ";
        }
        std::cout << "|\n";
    }
    std::cout << "========================================\n";

    return 0;
}

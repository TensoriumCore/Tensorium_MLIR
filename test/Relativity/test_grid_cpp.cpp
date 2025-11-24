#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <vector>

template <typename T, int N> struct MemRef {
  T *allocated;
  T *aligned;
  int64_t offset;
  int64_t sizes[N];
  int64_t strides[N];
};

struct Result1D {
  MemRef<double, 1> alpha;
  MemRef<double, 2> beta;
  MemRef<double, 3> gamma;
};

struct Result2D {
  MemRef<double, 2> alpha;
  MemRef<double, 3> beta;
  MemRef<double, 4> gamma;
};

struct Result3D {
  MemRef<double, 3> alpha;
  MemRef<double, 4> beta;
  MemRef<double, 5> gamma;
};

extern "C" {
void _mlir_ciface_GridMetric1D(Result1D *res, MemRef<double, 2> *in);
void _mlir_ciface_GridMetric2D(Result2D *res, MemRef<double, 3> *in);
void _mlir_ciface_GridMetric3D(Result3D *res, MemRef<double, 4> *in);
}

double get_theoretical_alpha(double x, double y, double z, double M) {
  double r = std::sqrt(x * x + y * y + z * z);
  if (r < 1e-9)
    return 0.0;
  double H = M / r;
  return 1.0 / std::sqrt(1.0 + 2.0 * H);
}

int64_t idx1(MemRef<double, 1> &m, int i) {
  return m.offset + i * m.strides[0];
}
int64_t idx2(MemRef<double, 2> &m, int i, int j) {
  return m.offset + i * m.strides[0] + j * m.strides[1];
}
int64_t idx3(MemRef<double, 3> &m, int i, int j, int k) {
  return m.offset + i * m.strides[0] + j * m.strides[1] + k * m.strides[2];
}
void print_1d_table(MemRef<double, 1> &alpha, MemRef<double, 2> &beta,
                    MemRef<double, 3> &gamma, int N) {
  std::cout << "\n--- 1D Grid Preview (First 10 points) ---" << std::endl;
  std::cout << std::left << std::setw(6) << "Idx" << std::setw(12) << "Alpha"
            << std::setw(12) << "Beta(x)" << std::setw(12) << "Gamma(xx)"
            << std::endl;
  std::cout << std::string(45, '-') << std::endl;

  for (int i = 0; i < std::min(N, 10); ++i) {
    double a = alpha.aligned[idx1(alpha, i)];
    double bx =
        beta.aligned[beta.offset + i * beta.strides[0] + 1 * beta.strides[1]];

    double gxx = gamma.aligned[gamma.offset + i * gamma.strides[0] +
                               1 * gamma.strides[1] + 1 * gamma.strides[2]];

    std::cout << std::left << std::setw(6) << i << std::fixed
              << std::setprecision(6) << std::setw(12) << a << std::setw(12)
              << bx << std::setw(12) << gxx << std::endl;
  }
  std::cout << std::endl;
}

// Affiche une matrice 2D (Alpha uniquement)
void print_2d_slice(MemRef<double, 2> &alpha, int N, int limit = 10) {
  std::cout << "\n--- 2D Alpha Slice (Top-Left " << limit << "x" << limit
            << ") ---" << std::endl;

  int loop_lim = std::min(N, limit);

  std::cout << "      ";
  for (int j = 0; j < loop_lim; ++j)
    std::cout << "Y=" << std::setw(2) << j << "   ";
  std::cout << "\n";

  for (int i = 0; i < loop_lim; ++i) {
    std::cout << "X=" << std::setw(2) << i << " | ";
    for (int j = 0; j < loop_lim; ++j) {
      double val = alpha.aligned[idx2(alpha, i, j)];
      if (val < 0.9)
        std::cout << "\033[31m";
      std::cout << std::fixed << std::setprecision(3) << val << "\033[0m ";
    }
    std::cout << "|" << std::endl;
  }
}

void print_point_metric(int x, int y, int z, Result3D &res) {
  int64_t offsetG = res.gamma.offset + x * res.gamma.strides[0] +
                    y * res.gamma.strides[1] + z * res.gamma.strides[2];

  std::cout << "\n--- Metric at Grid Point [" << x << "," << y << "," << z
            << "] ---" << std::endl;
  std::cout << "Alpha (Lapse): " << res.alpha.aligned[idx3(res.alpha, x, y, z)]
            << std::endl;

  std::cout << "Beta  (Shift): [ ";
  int64_t offsetB = res.beta.offset + x * res.beta.strides[0] +
                    y * res.beta.strides[1] + z * res.beta.strides[2];
  for (int i = 0; i < 3; ++i)
    std::cout << std::fixed << std::setprecision(4)
              << res.beta.aligned[offsetB + i] << " ";
  std::cout << "]" << std::endl;

  std::cout << "Gamma (Spatial):" << std::endl;
  for (int i = 0; i < 3; ++i) {
    std::cout << "  [ ";
    for (int j = 0; j < 3; ++j) {
      double val = res.gamma.aligned[offsetG + i * res.gamma.strides[3] +
                                     j * res.gamma.strides[4]];
      std::cout << std::fixed << std::setprecision(4) << std::setw(8) << val
                << " ";
    }
    std::cout << "]" << std::endl;
  }
}
bool test_1D() {
  std::cout << "\n=== Test 1D Grid [10] ===" << std::endl;
  const int N = 10;

  std::vector<double> inData(N * 4);
  for (int i = 0; i < N; ++i) {
    inData[i * 4 + 0] = 0.0;
    inData[i * 4 + 1] = 5.0 + i;
    inData[i * 4 + 2] = 0.0;
    inData[i * 4 + 3] = 0.0;
  }
  MemRef<double, 2> inMem = {inData.data(), inData.data(), 0, {N, 4}, {4, 1}};

  Result1D res = {0}; 

  _mlir_ciface_GridMetric1D(&res, &inMem);
  print_1d_table(res.alpha, res.beta, res.gamma, N);
  double val = res.alpha.aligned[idx1(res.alpha, 0)];
  double theo = get_theoretical_alpha(5.0, 0, 0, 1.0);
  std::cout << "Alpha[0] (r=5.0) = " << val << " (Theo: " << theo << ")"
            << std::endl;

  free(res.alpha.allocated);
  free(res.beta.allocated);
  free(res.gamma.allocated);

  return std::abs(val - theo) < 1e-12;
}

bool test_2D() {
  std::cout << "\n=== Test 2D Grid [64x64] ===" << std::endl;
  const int N = 64;
  std::vector<double> inData(N * N * 4);
  
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      int base = (i * N + j) * 4;
      inData[base + 0] = 0;
      inData[base + 1] = 3.0 + i; // x
      inData[base + 2] = 3.0 + j; // y
      inData[base + 3] = 0;
    }
  }

  MemRef<double, 3> inMem = {
      inData.data(), inData.data(), 0, {N, N, 4}, {N * 4, 4, 1}};

  Result2D res = {0};

  _mlir_ciface_GridMetric2D(&res, &inMem);

  print_2d_slice(res.alpha, N, 8);

  std::ofstream csv("adm_2d.csv");
  csv << "x,y,alpha,err\n"; 
  csv << std::scientific << std::setprecision(16);

  double max_err = 0.0;
  
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      double val = res.alpha.aligned[idx2(res.alpha, i, j)];
      
      double x = 3.0 + i;
      double y = 3.0 + j;
      
      double theo = get_theoretical_alpha(x, y, 0.0, 2.0);
      
      double err = std::abs(val - theo);
      max_err = std::max(max_err, err);

      csv << x << "," << y << "," << val << "," << err << "\n";
    }
  }
  
  csv.close();

  std::cout << "Max Error 2D: " << max_err << std::endl;

  free(res.alpha.allocated);
  free(res.beta.allocated);
  free(res.gamma.allocated);

  return max_err < 1e-12;
}

bool test_3D() {
  std::cout << "\n=== Test 3D Grid [5x5x5] ===" << std::endl;
  const int N = 5;
  std::vector<double> inData(N * N * N * 4);
  for (int i = 0; i < N * N * N; ++i) { // Remplissage simplifié
    inData[i * 4 + 1] = 4.0;
    inData[i * 4 + 2] = 4.0;
    inData[i * 4 + 3] = 4.0;
  }
  int idx_check = (2 * 25 + 2 * 5 + 2) * 4;
  inData[idx_check + 1] = 6.0;
  inData[idx_check + 2] = 6.0;
  inData[idx_check + 3] = 6.0;

  MemRef<double, 4> inMem = {
      inData.data(), inData.data(), 0, {N, N, N, 4}, {N * N * 4, N * 4, 4, 1}};

  Result3D res = {0};
  _mlir_ciface_GridMetric3D(&res, &inMem);
  print_point_metric(2, 2, 2, res);
  double val = res.alpha.aligned[idx3(res.alpha, 2, 2, 2)];
  double theo = get_theoretical_alpha(6.0, 6.0, 6.0, 1.5);
  std::cout << "Alpha[2,2,2] = " << val << " (Theo: " << theo << ")"
            << std::endl;

  free(res.alpha.allocated);
  free(res.beta.allocated);
  free(res.gamma.allocated);
  return std::abs(val - theo) < 1e-12;
}

int main() {
  bool ok = true;
  ok &= test_1D();
  ok &= test_2D();
  ok &= test_3D();
  if (ok)
    std::cout << "\n[SUCCESS] All tests passed." << std::endl;
  else
    std::cout << "\n[FAILURE] Tests failed." << std::endl;
  return ok ? 0 : 1;
}

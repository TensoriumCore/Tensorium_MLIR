import sys
import os
import time
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from mlir.ir import Context, Module

from Tensorium.compiler import Compiler
from Tensorium.runtime import Kernel
import Tensorium.dialects.relativity as relativity


def benchmark_numpy_implementation(coords_flat, M_val):

    start_time = time.perf_counter()

    x = coords_flat[:, 1]
    y = coords_flat[:, 2]
    z = coords_flat[:, 3]

    r2 = x*x + y*y + z*z
    r = np.sqrt(r2)
    inv_r = 1.0 / r

    nx = x * inv_r
    ny = y * inv_r
    nz = z * inv_r

    H = M_val * inv_r

    two_H = 2.0 * H
    alpha = 1.0 / np.sqrt(1.0 + two_H)

    factor = two_H / (1.0 + two_H)
    beta = np.stack([factor * nx, factor * ny, factor * nz], axis=1)

    n_vec = np.stack([nx, ny, nz], axis=1)  # (N, 3)
    nn = n_vec[:, :, np.newaxis] * n_vec[:, np.newaxis, :]
    delta = np.eye(3)  # (3, 3)
    gamma = delta + two_H[:, np.newaxis, np.newaxis] * nn

    end_time = time.perf_counter()
    return (end_time - start_time) * 1000.0, alpha, beta, gamma


def test_compile_benchmark_plot_2d():
    NX = 1000
    NY = 1000
    N_TOTAL = NX * NY
    M_VAL = 1.0

    print(
        f"--- Configuration: 2D Grid ({NX}x{NY} = {N_TOTAL} points), M={M_VAL} ---")

    print("--- 1. Compilation MLIR (AOT) ---")
    with Context() as ctx:
        relativity.register_dialect(ctx)
        relativity.register_passes()

        mlir_source = f"""
        module {{
          func.func @GridMetric2D(%coords: tensor<{N_TOTAL}x4xf64>)
            -> (tensor<{N_TOTAL}xf64>, tensor<{N_TOTAL}x3xf64>, tensor<{N_TOTAL}x3x3xf64>) {{
            
            %alpha, %beta, %gamma =
              relativity.metric.get "schwarzschild_ks"
                params = {{M = {M_VAL} : f64}}(%coords)
                : tensor<{N_TOTAL}x4xf64>
                  -> (tensor<{N_TOTAL}xf64>, tensor<{N_TOTAL}x3xf64>, tensor<{N_TOTAL}x3x3xf64>)
            
            return %alpha, %beta, %gamma :
              tensor<{N_TOTAL}xf64>, tensor<{N_TOTAL}x3xf64>, tensor<{N_TOTAL}x3x3xf64>
          }}
        }}
        """

        module = Module.parse(mlir_source)
        c = Compiler()
        so_path = c.compile_to_shared_lib(
            module, output_path="lib_metric_bench_2d.so")
        print(f"Compilation successful: {so_path}")

    print("\n--- 2. Data Setup ---")
    kernel = Kernel(so_path, "GridMetric2D")

    x_vals = np.linspace(1.5, 10.0, NX)
    y_vals = np.linspace(-5.0, 5.0, NY)
    X_grid, Y_grid = np.meshgrid(x_vals, y_vals)

    coords_2d = np.zeros((NY, NX, 4), dtype=np.float64)
    coords_2d[:, :, 1] = X_grid
    coords_2d[:, :, 2] = Y_grid

    coords_flat = coords_2d.reshape((-1, 4))
    print(
        f"Input Shape: {coords_flat.shape} ({coords_flat.nbytes / 1024 / 1024:.2f} MB)")

    print("\n--- 3. Benchmarking ---")

    kernel(coords_flat)

    N_RUNS = 60
    times = []

    print(f"Running MLIR Kernel {N_RUNS} times...")
    for _ in range(N_RUNS):
        t0 = time.perf_counter()
        alpha_flat, beta_flat, gamma_flat = kernel(coords_flat)
        t1 = time.perf_counter()
        times.append((t1 - t0) * 1000.0)

    avg_time = np.mean(times)
    std_time = np.std(times)
    throughput = N_TOTAL / (avg_time / 1000.0) / 1e6

    print(
        f"\n[Tensorium MLIR] Average Time: {avg_time:.4f} ms ± {std_time:.4f} ms")
    print(f"[Tensorium MLIR] Throughput:   {throughput:.2f} Mpts/s")

    print(f"\nRunning NumPy Reference...")
    numpy_time_ms, _, _, _ = benchmark_numpy_implementation(coords_flat, M_VAL)
    print(f"[Reference NumPy] Time:        {numpy_time_ms:.4f} ms")

    speedup = numpy_time_ms / avg_time
    print(f"\n>>> Speedup MLIR vs NumPy: {speedup:.2f}x <<<")

    print("\n--- 4. Validation ---")
    alpha_2d = alpha_flat.reshape((NY, NX))

    r_grid = np.sqrt(X_grid**2 + Y_grid**2)
    expected_alpha = 1.0 / np.sqrt(1.0 + 2.0 * M_VAL / r_grid)
    err = np.max(np.abs(alpha_2d - expected_alpha))

    print(f"Max Error: {err:.6e}")
    assert err < 1e-5, "Error too high!"

    if NX <= 1000:
        print("\n--- 5. Plotting ---")
        beta_2d = beta_flat.reshape((NY, NX, 3))
        gamma_2d = gamma_flat.reshape((NY, NX, 3, 3))

        fig, axes = plt.subplots(1, 3, figsize=(20, 6))
        fig.suptitle(
            f' Kerr-Schild Metric (a = 0.0 Schwarzschild) (2D Slice, M={M_VAL}, Gridsize = {NX} x {NY})', fontsize=16)

        im1 = axes[0].pcolormesh(
            X_grid, Y_grid, alpha_2d, shading='auto', cmap='viridis')
        axes[0].set_title(f'Lapse Alpha\n(Compute: {avg_time:.2f} ms)')
        axes[0].set_xlabel('x')
        axes[0].set_ylabel('y')
        axes[0].set_aspect('equal')
        fig.colorbar(im1, ax=axes[0])

        beta_mag = np.linalg.norm(beta_2d, axis=2)
        im2 = axes[1].pcolormesh(
            X_grid, Y_grid, beta_mag, shading='auto', cmap='plasma')
        axes[1].set_title('Shift Vector |Beta|')
        axes[1].set_xlabel('x')
        axes[1].set_yticks([])
        axes[1].set_aspect('equal')
        fig.colorbar(im2, ax=axes[1])

        gamma_xy = gamma_2d[:, :, 0, 1]
        norm_g = Normalize(vmin=-np.max(np.abs(gamma_xy)),
                           vmax=np.max(np.abs(gamma_xy)))
        im3 = axes[2].pcolormesh(
            X_grid, Y_grid, gamma_xy, shading='auto', cmap='RdBu_r', norm=norm_g)
        axes[2].set_title(r'Spatial Metric $\gamma_{xy}$')
        axes[2].set_xlabel('x')
        axes[2].set_yticks([])
        axes[2].set_aspect('equal')
        fig.colorbar(im3, ax=axes[2])

        plt.tight_layout()
        plt.show()


if __name__ == "__main__":
    test_compile_benchmark_plot_2d()

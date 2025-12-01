import sys
import os
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from mlir.ir import Context, Module

from Tensorium.compiler import Compiler
from Tensorium.runtime import Kernel
import Tensorium.dialects.relativity as relativity


def test_compile_and_plot_2d():
    NX = 256
    NY = 256
    N_TOTAL = NX * NY
    M_VAL = 1.0

    print(
        f"--- Configuration: 2D Grid ({NX}x{NY} = {N_TOTAL} points), M={M_VAL} ---")

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
        print("--- 1. Input MLIR (High Level 2D) ---")
        print(module)

        c = Compiler()
        c._optimize(module)

        so_path = c.compile_to_shared_lib(
            module, output_path="lib_metric_test_2d.so")
        print(f"Compilation successful: {so_path}")

    print("\n--- 3. Execution (Runtime 2D) ===")

    kernel = Kernel(so_path, "GridMetric2D")

    x_vals = np.linspace(2.5, 10.0, NX)
    y_vals = np.linspace(-5.0, 5.0, NY)
    X_grid, Y_grid = np.meshgrid(x_vals, y_vals)

    coords_2d = np.zeros((NY, NX, 4), dtype=np.float64)
    coords_2d[:, :, 1] = X_grid
    coords_2d[:, :, 2] = Y_grid
    coords_flat = coords_2d.reshape((-1, 4))

    print(f"Input Input Shape (Flattened): {coords_flat.shape}")

    alpha_flat, beta_flat, gamma_flat = kernel(coords_flat)

    print("\n--- 4. Results & Reshaping ---")
    alpha_2d = alpha_flat.reshape((NY, NX))
    beta_2d = beta_flat.reshape((NY, NX, 3))
    gamma_2d = gamma_flat.reshape((NY, NX, 3, 3))

    print(f"Alpha 2D shape: {alpha_2d.shape}")
    print(f"Beta 2D shape:  {beta_2d.shape}")
    print(f"Gamma 2D shape: {gamma_2d.shape}")

    r_grid = np.sqrt(X_grid**2 + Y_grid**2)
    expected_alpha_approx = 1.0 / np.sqrt(1.0 + 2.0 * M_VAL / r_grid)
    err = np.max(np.abs(alpha_2d - expected_alpha_approx))
    print(f"Max error vs analytical alpha (approx): {err:.6e}")
    assert err < 1e-5, "Error too high!"

    print("SUCCESS: 2D Pipeline execution finished.")

    print("\n--- 5. Plotting 2D Heatmaps ---")

    fig, axes = plt.subplots(1, 3, figsize=(20, 6))
    fig.suptitle(
        f'Schwarzschild Kerr-Schild Metric (2D Slice z=0, M={M_VAL})', fontsize=16)

    im1 = axes[0].pcolormesh(X_grid, Y_grid, alpha_2d,
                             shading='auto', cmap='viridis')
    axes[0].set_title('Lapse Function (Alpha)')
    axes[0].set_xlabel('x')
    axes[0].set_ylabel('y')
    axes[0].set_aspect('equal')
    fig.colorbar(im1, ax=axes[0])

    beta_mag_2d = np.linalg.norm(beta_2d, axis=2)
    im2 = axes[1].pcolormesh(X_grid, Y_grid, beta_mag_2d,
                             shading='auto', cmap='plasma')
    axes[1].set_title('Shift Vector Magnitude (|Beta|)')
    axes[1].set_xlabel('x')
    axes[1].set_yticks([]) 
    axes[1].set_aspect('equal')
    fig.colorbar(im2, ax=axes[1])

    gamma_xy_2d = gamma_2d[:, :, 0, 1]

    norm_g = Normalize(vmin=-np.max(np.abs(gamma_xy_2d)),
                       vmax=np.max(np.abs(gamma_xy_2d)))
    im3 = axes[2].pcolormesh(X_grid, Y_grid, gamma_xy_2d,
                             shading='auto', cmap='RdBu_r', norm=norm_g)
    axes[2].set_title(r'Spatial Metric Cross-Term ($\gamma_{xy}$)')
    axes[2].set_xlabel('x')
    axes[2].set_yticks([])
    axes[2].set_aspect('equal')
    fig.colorbar(im3, ax=axes[2])

    plt.tight_layout()
    print("Displaying plot...")
    plt.show()


if __name__ == "__main__":
    test_compile_and_plot_2d()

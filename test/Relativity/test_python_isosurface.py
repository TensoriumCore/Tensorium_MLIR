import sys
import os
import numpy as np

import plotly.graph_objects as go
from plotly.subplots import make_subplots

from mlir.ir import Context, Module
from Tensorium.compiler import Compiler
from Tensorium.runtime import Kernel
import Tensorium.dialects.relativity as relativity


def test_3d_isosurfaces_plotly():
    NX = 30
    NY = 30
    NZ = 30
    N_TOTAL = NX * NY * NZ
    M_VAL = 1.0

    print(
        f"--- Configuration: 3D Grid ({NX}x{NY}x{NZ} = {N_TOTAL} points), M={M_VAL} ---")

    with Context() as ctx:
        relativity.register_dialect(ctx)
        relativity.register_passes()

        mlir_source = f"""
        module {{
          func.func @GridMetric3D(%coords: tensor<{N_TOTAL}x4xf64>)
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
            module, output_path="lib_metric_iso.so")
        print(f"Compilation successful: {so_path}")

    kernel = Kernel(so_path, "GridMetric3D")

    limit = 5.0
    x_vals = np.linspace(-limit, limit, NX)
    y_vals = np.linspace(-limit, limit, NY)
    z_vals = np.linspace(-limit, limit, NZ)

    X_grid, Y_grid, Z_grid = np.meshgrid(x_vals, y_vals, z_vals, indexing='ij')

    coords_3d = np.zeros((NX, NY, NZ, 4), dtype=np.float64)
    coords_3d[:, :, :, 1] = X_grid
    coords_3d[:, :, :, 2] = Y_grid
    coords_3d[:, :, :, 3] = Z_grid

    print("Computing kernel on 3D grid...")
    alpha_flat, beta_flat, _ = kernel(coords_3d.reshape((-1, 4)))

    beta_mag_flat = np.linalg.norm(beta_flat, axis=1)

    print("\n--- Generating Interactive 3D Isosurfaces (Plotly) ---")
    print("Opening browser window for visualization...")

    fig = make_subplots(
        rows=1, cols=2,
        specs=[[{'type': 'scene'}, {'type': 'scene'}]],
        subplot_titles=("Lapse Function (Alpha) - Layers of equal time dilation",
                        "Shift Magnitude (|Beta|) - Layers of equal space drag")
    )

    fig.add_trace(
        go.Isosurface(
            x=X_grid.flatten(),
            y=Y_grid.flatten(),
            z=Z_grid.flatten(),
            value=alpha_flat,
            isomin=alpha_flat.min(),
            isomax=alpha_flat.max(),
            surface_count=6,
            colorscale='Inferno_r',
            caps=dict(x_show=False, y_show=False, z_show=False),
            opacity=0.5,
            colorbar=dict(title='Alpha', x=-0.05)
        ),
        row=1, col=1
    )

    fig.add_trace(
        go.Isosurface(
            x=X_grid.flatten(),
            y=Y_grid.flatten(),
            z=Z_grid.flatten(),
            value=beta_mag_flat,
            isomin=beta_mag_flat.min(),
            isomax=beta_mag_flat.max() * 0.9,
            surface_count=6,
            colorscale='Viridis',
            caps=dict(x_show=False, y_show=False, z_show=False),
            opacity=0.5,
            colorbar=dict(title='|Beta|')
        ),
        row=1, col=2
    )

    fig.update_layout(
        title_text=f"Schwarzschild Kerr-Schild Metric 3D Isosurfaces (M={M_VAL})",
        height=700,
        scene=dict(aspectmode='data'),
        scene2=dict(aspectmode='data'),
    )

    fig.show()


if __name__ == "__main__":
    test_3d_isosurfaces_plotly()

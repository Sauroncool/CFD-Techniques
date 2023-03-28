using SparseArrays, Plots

# Define the grid and physical parameters
Lx, Ly = 2.0, 1.0  # Length of the domain in the x and y direction (m)
Δx = Δy = 0.1  # Grid spacing in the x and y direction (m)
Nx, Ny = Int(Lx / Δx), Int(Ly / Δy)  # Number of grid points in the x and y direction
α = 2e-04  # Thermal diffusivity (m^2/s)

# Define the simulation parameters
total_time = 150  # Total simulation time (s)
Δt = 0.25  # Time step size (s)
num_time_step = round(total_time / Δt)  # Number of time steps

# Define the initial condition
u = 10 * ones(Nx, Ny)

u[:, end] .= 80  # Top boundary condition

r1 = α * Δt / (2Δx^2)
r2 = α * Δt / (2Δy^2)


function create_matrix(n,r)
    matrix=spdiagm(-1 => -r * ones(n - 1), 0 => (1 + 2r) * ones(n), 1 => -r * ones(n - 1))
    # Apply boundary conditions for each row/column
    matrix[1, 1] = 1
    matrix[1, 2] = 0
    matrix[end, end] = 1
    matrix[end, end-1] = 0
    return matrix
end

A= sparse(create_matrix(Nx,r1))
B= create_matrix(Nx,-r1)
C= create_matrix(Ny,-r2)
D= sparse(create_matrix(Ny,r2))

# Define the functions for the First and Second step
function first_step(u)
    Nx, Ny = size(u)
    v = copy(u)
    for j = 2:Ny-1  
        # We are doing it from 2 to Ny-1 so we don't change the top and bottom BCs
        b = B * u[:, j]
        c = A \ u[:, j]
        v[:, j] = b + c - u[:, j]
    end
    return v
end

function second_step(u)
    Nx, Ny = size(u)
    v = copy(u)
    for i = 2:Nx-1
        # We are doing it from 2 to Nx-1 so we don't change the left and right BCs
        b = C * u[i, :]
        c = D \ u[i, :]
        v[i, :] = b + c - u[i, :]
    end
    return v
end

# Define the function for ADI scheme
function adi_scheme(u)
    v = first_step(u)
    w = second_step(v)
    return w
end

# Perform the time integration using the ADI scheme
for n = 1:num_time_step
    global u = adi_scheme(u)
end

#Visualize the final solution with a heatmap, 3D plot, and contour curve
plotly(ticks = :native) # Allow to zoom and will adjust the grid
display(heatmap(u', xlabel="x (cm)", ylabel="y (cm)", color=:viridis))
display(surface(u, xlabel="x (cm)", ylabel="y (cm)", zlabel="Temperature (C)", color=:viridis))
display(contour(u', xlabel="x (cm)", ylabel="y (cm)", color=:viridis))
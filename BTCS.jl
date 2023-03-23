using SparseArrays, Plots
plotly(ticks = :native) # Allow to zoom and will adjust the grid


function create_matrix()

  # Creates a tridiagonal banded matrix A used in the BTCS method
  A=spdiagm(-1 => -d * ones(Nx - 1), 0 => (1 + 2d) * ones(Nx), 1 => -d * ones(Nx - 1))
  # Apply boundary conditions
  A[1, 1] = 1
  A[1, 2] = 0
  A[end, end] = 1
  A[end, end-1] = 0

  return A
end

# Define the grid parameters
L = 1.0  # Length of the domain in the x direction (m)
Δx = 0.01  # Grid spacing in the x direction (m)
Nx = Int(L / Δx)  # Number of grid points in the x direction

# Define the physical parameters
α = 6e-05  # Thermal diffusivity (m^2/s)

# Define the simulation parameters
total_time = 300  # Total simulation time (s) [We will run it 6 times]
d = 0.6
Δt = round(d * Δx^2 / α, digits=4)  # time step size (s)
num_time_step = round(total_time / Δt)  # Number of time steps

# Define the initial condition
u = zeros(Nx)
x_values = range(0, L, length=Nx)
u .= 60 .* x_values + 100 .* sin.(π .* x_values)

# Plot the initial condition
plot(xlabel="x", ylabel="Temperature (C)")
plot!(x_values, u, label="Initial Condition")

T(x, t) = 60x + 100(exp(-α * π^2 * t)) * sin(π*x)  # Analytical Equation

# Note we didn't need to define any further boundary value conditions. As they are same as the boundary conditions of the initial state.

# Create the matrix and precompute its LU factorization. Now it won't need to find the inverse of A at each iteration
A = create_matrix()

# Run the simulation using the BTCS method with a matrix
for i in 1:6  # Running it 6 times
  for j in 1:num_time_step  # Running for each time interval
    u .= A \ u  # Solving and updating it
  end
  # Numerical
  plot!(x_values, u, label="After $(Int(i*total_time/60)) minutes (numerically)")
  # Analytical
  plot!(0:0.01:1, T.(0:0.01:1, 60 * 5 * i), label="After $(5*i) minutes (analytically)")
end

plot!(legend=:topleft, grid=true, title="For d=$(d)")

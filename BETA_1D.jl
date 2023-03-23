using LinearAlgebra, Plots
plotly(ticks = :native) # Allow to zoom and will adjust the grid

function create_matrix()

  # Creates a tridiagonal banded matrix A used in the BTCS method
  # Create a zero-filled matrix with appropriate dimensions
  A = zeros(Nx, Nx)

  # Fill in the diagonal values
  for i in 1:Nx
    A[i, i] = 1 + 2 * β * d
    if i > 1
      A[i, i-1] = -β * d
    end
    if i < Nx
      A[i, i+1] = -β * d
    end
  end


  # Apply boundary conditions
  A[1, 1] = 1
  A[1, 2] = 0
  A[end, end] = 1
  A[end, end-1] = 0

  return A
end

# Define the grid parameters
L = 10.0  # Length of the domain in the x direction (m)
Δx = 0.1  # Grid spacing in the x direction (m)
Nx = Int(L / Δx)  # Number of grid points in the x direction

# Define the physical parameters
α = 2e-04  # Thermal diffusivity (m^2/s)
β=0.5

# Define the simulation parameters
total_time = 60*60
simul_time = round(total_time/6)  # simulation time (s) [We will run it 6 times]
d = 0.4
Δt = round(d * Δx^2 / α, digits=4)  # time step size (s)
num_time_step = round(simul_time / Δt)  # Number of time steps

# Define the initial condition
x_values = range(0, L, length=Nx)
u = zeros(Nx)
u[x_values .< 4] .= 30.0
u[(4 .<= x_values .< 6)] .= 100.0
u[6 .<= x_values] .= 40.0

# Plot the initial condition
plot(xlabel="x", ylabel="Temperature (C)")
plot!(x_values, u, label="Initial Condition")

u[1]=30
u[end]=30

# Create the matrix and precompute its LU factorization. Now it won't need to find the inverse of A at each iteration
A = create_matrix()
f = lu(A)

# Run the simulation using the BTCS method with a matrix
for i in 1:6  # Running it 6 times
  for j in 1:num_time_step  # Running for each time interval
    B = copy(u)
    B[2:end-1] .= u[2:end-1] .+ (1-β) * d * (u[3:end] .- 2 .* u[2:end-1] .+ u[1:end-2])
    u .= f \ B  # Solving and updating it
  end
  # Numerical
  plot!(x_values, u, label="After $(i*simul_time/60) minutes (numerically)")
end

plot!(legend=:topleft, grid=true, title="For β=$(β)")
gui()


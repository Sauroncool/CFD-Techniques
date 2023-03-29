using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function GEN_K(u, c)
    n = length(u)
    v = similar(u)
    ϵ = 1
    k = -1
    for i = 1:n
        in1 = mod1(i - 1, n)    # index of i-1 with periodic boundary
        in2 = mod1(i - 2, n)    # index of i-2 with periodic boundary
        ip1 = mod1(i + 1, n)    # index of i+1 with periodic boundary
        v[i] = u[i] - c * (u[i] - u[in1]) - (ϵ * c / 4) * ((1 - k) * (u[i] - 2 * u[in1] + u[in2]) + (1 + k) * (u[ip1] - 2 * u[i] + u[in1]))
    end
    return v
end

# Define the grid parameters
L = 10.0   # Length of the domain in the x direction 
Δx = 0.01  # Grid spacing in the x direction 
Nx = Int(L / Δx)   # Number of grid points in the x direction
c = 0.5   # Courant Numbers

# Define the physical parameters
α = 2   # Speed of Propagataion

# Define the simulation parameters
sim_time = 4   # Total simulation time 
Δt = round(c * Δx / α, digits=4)  # time step size 
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = exp.(-4 .* (x_values .- 5) .^ 2)
# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="Generalized K", legend=:topleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = GEN_K(u, c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")

# Define the simulation parameters
sim_time_2 = 6   # Total simulation time 
num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# Run the simulation
for j in 1:num_time_step_2
    global u = GEN_K(u, c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time+sim_time_2) seconds (numerically)")
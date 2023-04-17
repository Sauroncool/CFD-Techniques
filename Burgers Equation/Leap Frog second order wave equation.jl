using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function leapfrog(u, u_prev, c)
    v = copy(u)
    v[1] = 2 * u[1] - u_prev[1] + (c^2) * (u[2] - 2 * u[1] + u[end])
    v[2:end-1] .= 2 .* u[2:end-1] .- u_prev[2:end-1] .+ (c^2) .* (u[3:end] .- 2 .* u[2:end-1] .+ u[1:end-2])
    v[1] = 2 * u[end] - u_prev[end] + (c^2) * (u[1] - 2 * u[end] + u[end-1])
    return v
end

# Define the grid parameters
L = 10.0   # Length of the domain in the x direction 
Δx = 0.005  # Grid spacing in the x direction 
Nx = Int(L / Δx)   # Number of grid points in the x direction

# Define the physical parameters
α = 1   # Speed of Propagation

# Define the simulation parameters
sim_time = 0.3   # Total simulation time 
Δt = Δx  # time step size 
num_time_step = round(sim_time / Δt)   # Number of time steps

c = α * Δt / Δx

# Define the initial condition
x_values = range(-5, stop=(-5 + L), length=Nx)
u = 2 .* exp.(-2 .* x_values .^ 2)
u_prev = copy(u)

# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="Leapfrog", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u, u_prev = leapfrog(u, u_prev, c), u
end

# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")

# Run the simulation
for j in 1:Int(num_time_step * 5 / 3)
    global u, u_prev = leapfrog(u, u_prev, c), u
end

# Numerical
plot!(x_values, u, label="After $(round(sim_time*8/3,digits=2)) seconds (numerically)")


# Run the simulation
for j in 1:Int(num_time_step * 10 / 3)
    global u, u_prev = leapfrog(u, u_prev, c), u
end

# Numerical
plot!(x_values, u, label="After $(round(sim_time*18/3,digits=2)) seconds (numerically)")
png("5b Leapfrog")
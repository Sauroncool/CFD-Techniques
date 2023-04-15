using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function FOUPW(u, Δt, Δx)
    v = similar(u)
    v[2:end-1] .=u[2:end-1] .- ((Δt / Δx) .* ((u[2:end-1] .+ u[1:end-2])./2)) .* (u[2:end-1] .- u[1:end-2])
    v[1] = 1.0    # Boundary condition
    v[end] = 0.0  # Boundary condition
    return v
end

# Define the grid parameters
L = 5.0   # Length of the domain in the x direction (m)
Δx = 0.025  # Grid spacing in the x direction (m)
Nx = Int(L / Δx)   # Number of grid points in the x direction


# Define the simulation parameters
sim_time = 2.0   # Total simulation time (s)
Δt = Δx  # time step size (s)
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = zeros(Nx)
u[x_values .< 0.25] .= 1
u[0.25 .<= x_values .<= 1.25] = 1.25 .- x_values[0.25 .<= x_values .<= 1.25]


# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="First Order Upwind", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = FOUPW(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = FOUPW(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(2*sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = FOUPW(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(3*sim_time) seconds (numerically)")
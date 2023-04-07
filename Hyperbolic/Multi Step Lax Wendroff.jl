using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function predictor(u, c)    # Lax Friedrich Method
    v = similar(u)
    v[1:end-1] .= ((u[2:end] .+ u[1:end-1]) ./ 2) .- (c / 2) .* (u[2:end] .- u[1:end-1])
    v[end] = (u[1] + u[end]) / 2 - (c / 2) * (u[1] - u[end])

    w = similar(u)
    w[1] = (u[1] + u[end]) / 2 - (c / 2) * (u[1] - u[end])
    w[2:end] .= ((u[2:end] .+ u[1:end-1]) ./ 2) .- (c / 2) .* (u[2:end] .- u[1:end-1])
    return v,w
end

function corrector(v,w, u_prev, c)    # Leap Frog Method
    u = similar(v)
    u[1:end] .= u_prev[1:end] .- c .* (v[1:end] .- w[1:end])
    return u
end

function LW(u, c)
    u_prev = copy(u)
    u_plus_half,u_minus_half = predictor(u, c)
    u_corrected = corrector(u_plus_half,u_minus_half, u_prev, c)
    return u_corrected
end
# Define the grid parameters
L = 10.0   # Length of the domain in the x direction 
Δx = 0.01  # Grid spacing in the x direction 
Nx = Int(L / Δx)   # Number of grid points in the x direction
c = 1.2   # Courant Numbers

# Define the physical parameters
α = 2   # Speed of Propagation

# Define the simulation parameters
sim_time = 4   # Total simulation time 
Δt = round(c * Δx / α, digits=4)  # time step size 
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = exp.(-4 .* (x_values .- 5) .^ 2)

# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="Multi Step Lax Wendroff", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:20
    global u = LW(u, c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")

# Define the simulation parameters
# sim_time_2 = 6   # Total simulation time 
# num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# # Run the simulation
# for j in 1:num_time_step_2
#     global u = LW(u, c)
# end

# # Numerical
# plot!(x_values, u, label="After $(sim_time+sim_time_2) seconds (numerically)")
# png("1_Multi Step Lax Wendroff")
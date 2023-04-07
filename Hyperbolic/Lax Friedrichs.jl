using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function LF(u, c)
    v = copy(u)
    v[1] = (u[2] + u[end]) / 2 - (c / 2) * (u[2] - u[end])
    v[2:end-1] .= ((u[3:end] .+ u[1:end-2]) ./ 2) .- (c / 2) .* (u[3:end] .- u[1:end-2])
    v[end] = (u[1] + u[end-1]) / 2 - (c / 2) * (u[1] - u[end-1])
    return v
end

# Define the grid parameters
L = 10.0   # Length of the domain in the x direction 
Δx = 0.01  # Grid spacing in the x direction 
Nx = Int(L / Δx)   # Number of grid points in the x direction
# c = 0.5   # Courant Numbers
c = 1.2

# Define the physical parameters
α = 2   # Speed of Propagation

# Define the simulation parameters
sim_time = 4   # Total simulation time 
Δt = round(c * Δx / α, digits=4)  # time step size 
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = exp.(-4 .* (x_values .- 5) .^ 2)
# u = exp.(-30 .* (x_values .- 2) .^ 2) + exp.(-(x_values .- 5) .^ 2)
# u = zeros(Nx)
# u[1 .<= x_values .<= 2] = x_values[1 .<= x_values .<= 2] .- 1
# u[2 .<= x_values .<= 3] = 3 .- x_values[2 .<= x_values .<= 3]
# u = ones(Nx)
# u[x_values .<= 5] .= 2

# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude",title="Lax Friedrich",legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# # Run the simulation
# for j in 1:num_time_step
#     global u = LF(u, c)
# end

# # Numerical
# plot!(x_values, u, label="After $(sim_time) seconds (numerically)")

# # Define the simulation parameters
# sim_time_2 = 6   # Total simulation time 
# num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# # Run the simulation
# for j in 1:num_time_step_2
#     global u = LF(u,c)
# end

# # Numerical
# plot!(x_values, u, label="After $(sim_time+sim_time_2) seconds (numerically)")

# Run the simulation
for j in 1:20
    global u = LF(u, c)
end

# Numerical
plot!(x_values, u, label="After 20 time steps (numerically)")
png("1b_Lax Friedrichs")
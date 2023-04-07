using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

# Analytical
function Analytical(u, t)
    v = similar(u)
    for i in 1:Nx
        v[Int(mod1(i+α*t/Δx,Nx))]= u[i]
    end
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
plot(xlabel="x", ylabel="Amplitude", title="Analytical", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")


# # Define the simulation parameters
# sim_time_2 = 6   # Total simulation time 

# plot!(x_values, Analytical(u, sim_time), label="After $(sim_time) seconds (analytically)")
# plot!(x_values, Analytical(u, sim_time + sim_time_2), label="After $(sim_time+sim_time_2) seconds (analytically)")

# plot!(x_values, Analytical(u, 20*Δt), label="After 20 time steps (analytically)")
# png("1b_Analytical")
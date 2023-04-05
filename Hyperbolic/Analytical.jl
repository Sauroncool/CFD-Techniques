using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

# Define the grid parameters
L = 10.0   # Length of the domain in the x direction 
Δx = 0.01  # Grid spacing in the x direction 
Nx = Int(L / Δx)   # Number of grid points in the x direction
c = 0.5   # Courant Numbers

# Define the physical parameters
α = 2   # Speed of Propagation

# Define the simulation parameters
sim_time = 4   # Total simulation time 
Δt = round(c * Δx / α, digits=4)  # time step size 
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
#u = exp.(-4 .* (x_values .- 5) .^ 2)
u = exp.(-30 .* (x_values .- 2) .^ 2) + exp.(-(x_values .- 5) .^ 2)

# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="Richtmyer", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")


# Define the simulation parameters
sim_time_2 = 6   # Total simulation time 
num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# Analytical
function Analytical(x, t)
    peak_point = 5 + α * t
    while (peak_point >= 10)
        peak_point = peak_point - 10
    end
    peak_point_2 = 2 + α * t
    while (peak_point_2 >= 10)
        peak_point_2 = peak_point_2 - 10
    end
    return exp(-30(x - peak_point_2)^2) + exp(-30(x - (peak_point_2 + 10))^2) + exp(-(x - peak_point)^2) + exp(-(x - (peak_point + 10))^2)
    # return exp(-4(x-peak_point)^2)+exp(-4(x-(peak_point+10))^2)
end

plot!(0:Δx:10, Analytical.(0:Δx:10, sim_time), label="After $(sim_time) seconds (analytically)")
plot!(0:Δx:10, Analytical.(0:Δx:10, sim_time + sim_time_2), label="After $(sim_time+sim_time_2) seconds (analytically)")
# png("1_Analytical")
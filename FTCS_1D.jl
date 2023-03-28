using Plots
plotly(ticks = :native) # Allow to zoom and will adjust the grid

function FTCS()
    v = copy(u)
    v[2:end-1] .= u[2:end-1] .+ α * Δt * ((u[3:end] .- 2 .* u[2:end-1] .+ u[1:end-2]) ./ Δx^2)
    return v
end

# Define the grid parameters
L = 1.0   # Length of the domain in the x direction (m)
Δx = 0.001  # Grid spacing in the x direction (m)
d = 0.4   # ratio of time step to spatial step
Nx = Int(L / Δx)   # Number of grid points in the x direction

# Define the physical parameters
α = 6e-05   # Thermal diffusivity (m^2/s)

# Define the simulation parameters
sim_time = 5 * 60   # Total simulation time (s)
Δt = round(d * Δx^2 / α, digits=4)  # time step size (s)
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = 60 .* x_values .+ 100 .* sin.(π .* x_values)
# Plot the initial condition
plot(xlabel="x (m)", ylabel="Temperature (C)")
plot!(x_values, u, label="Initial Condition")
T(x, t) = 60x + 100 * (exp(-α * π^2 * t)) * sin(π * x)  # Analytical Equation

# Run the simulation
for i in 1:6   # Running 5 minute simulation 6 times.
    for j in 1:num_time_step
        global u = FTCS()
    end

    # Numerical
    plot!(x_values, u, label="After $(Int(i*sim_time/60)) minutes (numerically)")
    # Analytical
    plot!(0:0.01:1, T.(0:0.01:1, 60 * 5 * i), label="After $(5*i) minutes (analytically)")
end
plot!(legend=:topleft, grid=true)
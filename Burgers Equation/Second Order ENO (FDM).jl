using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function ENO(u, Δt, Δx)
    n=length(u)
    v = copy(u)
    for i = 3:n-1
        v[i] = u[i] - ((Δt * ((u[i] + u[i-1])/2)) * (((u[i] - u[i-1]) / Δx) + (Δx / 2) * minmod((u[i+1] - 2 * u[i] + u[i-1]) / (Δx^2), (u[i] - 2 * u[i-1] + u[i-2]) / (Δx^2))))
    end
    v[1] = 0.0    # Boundary condition
    v[end] = 1.0  # Boundary condition
    return v
end

function minmod(p, q)
    if (p * q > 0)
        return sign(p) * min(abs(p), abs(q))
    end
    return 0
end

# Define the grid parameters
L = 5.0   # Length of the domain in the x direction (m)
Δx = 0.005  # Grid spacing in the x direction (m)
Nx = Int(L / Δx)   # Number of grid points in the x direction


# Define the simulation parameters
sim_time = 2.0   # Total simulation time (s)
Δt = Δx  # time step size (s)
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = zeros(Nx)
# u[x_values .< 0.25] .= 1
# u[0.25 .<= x_values .<= 1.25] = 1.25 .- x_values[0.25 .<= x_values .<= 1.25]
# u[x_values .< 1] .= 1
u[x_values.>1] .= 1


# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="ENO", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = ENO(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = ENO(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(2*sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = ENO(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(3*sim_time) seconds (numerically)")
png("3 Second Order ENO")
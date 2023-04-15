using Plots
plotly(ticks=:native) # Allow to zoom and adjust the grid

function f(u)
    return u^2/2
end

function predictor(u, Δt, Δx) # FTFS Method
    v = copy(u)
    v[1:end-1] .= u[1:end-1] .- (Δt/Δx) .* (f.(u[2:end]) .- f.(u[1:end-1]))
    return v
end

function corrector(u, u_prev, Δt, Δx)    # BTBS Method
    v = copy(u)
    v[2:end] .= ((u_prev[2:end] .+ u[2:end]) ./ 2) .- (Δt / (2*Δx)) .* (f.(u[2:end]) .- f.(u[1:end-1]))
    return v
end

function MacCormack(u, Δt, Δx)
    u_prev = copy(u)
    u_predicted = predictor(u, Δt, Δx)
    u_corrected = corrector(u_predicted, u_prev, Δt, Δx)
    u_corrected[1]=1.0
    u_corrected[end]=0.0
    return u_corrected
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
plot(xlabel="x", ylabel="Amplitude", title="MacCormack", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = MacCormack(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = MacCormack(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(2*sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = MacCormack(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(3*sim_time) seconds (numerically)")
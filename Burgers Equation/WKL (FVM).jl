using Plots
plotly(ticks=:native) # Allow to zoom and adjust the grid

function f(u)
    return u^2/2
end

function first(u, Δt, Δx) 
    v = copy(u)
    v[2:end-1] .= u[2:end-1] .- (2*Δt/(3*Δx)) .* (f.(u[3:end]) .- f.(u[2:end-1]))
    return v
end

function second(u, u_prev, Δt, Δx)   
    v = copy(u)
    v[2:end-1] .= ((u_prev[2:end-1] .+ u[2:end-1]) ./ 2) .- (2*Δt / (3*Δx)) .* (f.(u[2:end-1]) .- f.(u[1:end-2]))
    return v
end

function third(u_second, u_prev, Δt, Δx)   
    v = copy(u_prev)
    ω = 2
    v[3:end-2] .= u_prev[3:end-2] .- (Δt / (24*Δx)) .* (-2 .* f.(u_prev[5:end]) .+ 7 .* f.(u_prev[4:end-1]) -7 .* f.(u_prev[2:end-3]) + 2 .* f.(u_prev[1:end-4])) .- (3*Δt / (8*Δx)) .* (f.(u_second[4:end-1]) .- f.(u_second[2:end-3])) .- (ω/24).*(u_prev[5:end] .- 4 .* u_prev[4:end-1] .+ 6 .* u_prev[3:end-2] .- 4 .* u[2:end-3] .+ u[1:end-4])
    
    return v
end

function WKL(u, Δt, Δx)
    u_prev = copy(u)
    u_first = first(u, Δt, Δx)
    u_second = second(u_first, u_prev, Δt, Δx)
    u_third=third(u_second, u_prev, Δt, Δx)
    u_third[1]=1.0
    u_third[end]=0.0
    return u_third
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
u[x_values .< 1] .= 1
# u[x_values.>1] .= 1


# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="WKL", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = WKL(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = WKL(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(2*sim_time) seconds (numerically)")


# Run the simulation
for j in 1:num_time_step
    global u = WKL(u, Δt, Δx)
end
# Numerical
plot!(x_values, u, label="After $(3*sim_time) seconds (numerically)")
png("4a WKL")
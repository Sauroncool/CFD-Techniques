using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function ENO(u, Δt, α, Δx)
    v = copy(u)
    v[1] = u[1] - ((Δt * α) * (((u[1] - u[end]) / Δx) + (Δx / 2) * minmod((u[2] - 2 * u[1] + u[end]) / (Δx^2), (u[1] - 2 * u[end] + u[end-1]) / (Δx^2))))
    v[2] = u[2] - ((Δt * α) * (((u[2] - u[1]) / Δx) + (Δx / 2) * minmod((u[3] - 2 * u[2] + u[1]) / (Δx^2), (u[2] - 2 * u[1] + u[end]) / (Δx^2))))
    v[3:end-1] .= u[3:end-1] .- ((Δt * α) .* (((u[3:end-1] .- u[2:end-2]) / Δx) .+ (Δx / 2) * minmod.((u[4:end] - 2 * u[3:end-1] + u[2:end-2]) / (Δx^2), (u[3:end-1] - 2 * u[2:end-2] + u[1:end-3]) / (Δx^2))))
    v[end] = u[end] - ((Δt * α) * (((u[end] - u[end-1]) / Δx) + (Δx / 2) * minmod((u[1] - 2 * u[end] + u[end-1]) / (Δx^2), (u[end] - 2 * u[end-1] + u[end-2]) / (Δx^2))))
    return v
end

# function ENO(u, Δt, α, Δx)
#     n=length(u)
#     v = similar(u)
#     for i = 1:n
#         in1 = mod1(i - 1, n)    # index of i-1 with periodic boundary
#         in2 = mod1(i - 2, n)    # index of i-2 with periodic boundary
#         ip1 = mod1(i + 1, n)    # index of i+1 with periodic boundary
#         v[i] = u[i] - ((Δt * α) * (((u[i] - u[in1]) / Δx) + (Δx / 2) * minmod((u[ip1] - 2 * u[i] + u[in1]) / (Δx^2), (u[i] - 2 * u[in1] + u[in2]) / (Δx^2))))
#     end
#     return v
# end


function minmod(p, q)
    if (p * q > 0)
        return sign(p) * min(abs(p), abs(q))
    end
    return 0
end

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
u = exp.(-4 .* (x_values .- 5) .^ 2)
# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="ENO", legend=:topleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = ENO(u, Δt, α, Δx)
end

# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")

# Define the simulation parameters
sim_time_2 = 6   # Total simulation time 
num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# Run the simulation
for j in 1:num_time_step_2
    global u = ENO(u, Δt, α, Δx)
end

# Numerical
plot!(x_values, u, label="After $(sim_time+sim_time_2) seconds (numerically)")
# png("Second Order ENO")
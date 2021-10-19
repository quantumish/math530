using Printf
using LinearAlgebra
using Plots

# Choose an arbitrary epsilon to define convergence
const EPSILON = 1e-10

verbose = false
if "-v" in ARGS
    global verbose = true
end

function pprint(matrix)
    print("\n")
    display(matrix)
    print("\n\n")
end

n = parse(Int64, ARGS[1])

E = zeros(n)
for i in 1:n
    E[i] = rand()
end
if verbose
    print("E:")
    pprint(E)
end
F = zeros(n, n)
for i in 1:n
    for j in 1:n
        if E[i] == E[j]
            F[i,j] = E[i]# +rand()
        else
            F[i,j] = E[i]+E[j]
        end
    end
end

if verbose
    print("F (original):")
    pprint(F)
end
for i in 1:n
    for j in 1:n-i
        tmp = rand()
	F[i, j+i] += tmp
	F[j+i, i] += tmp
    end
end
if verbose
    print("F (corrected)")
    pprint(F)
end

K = zeros(n)
vals = []
for i in 1:n
    sum = 0
    for j in 1:n
        # @printf("%s %s\n", E[i], F[i,j])
        sum += exp(E[i] - F[i,j])
    end
    # append!(vals, sum)
    K[i] = 1/sum
end
if verbose print("K: ", K, "\n") end

P = zeros(n, n)
for i in 1:n
    for j in 1:n
        P[i,j] = K[i] * exp(E[i] - F[i,j])
    end
end

if verbose
    print("P:")
    pprint(P)
end
x = zeros(n)
for i in 1:n
    x[i] = rand()
end
x /= sum(x)
x_t = zeros(1,n)
transpose!(x_t, x)
if verbose
    print("Initial X:")
    pprint(x_t)
end
whee = x_t*P
display(whee); @printf("\nConverged: \n");
data = Matrix{Float64}[]
counter = 1
while true
    old = whee;
    global whee = whee*P
    push!(data, whee)
    # print(whee)
    if sum(broadcast(abs, whee-old)) < EPSILON
        break
    end
    global counter = counter + 1
end
if verbose @printf("Converged in %s steps. \n", counter) end

converge = 1
for i in data
    if (broadcast(abs, i-whee) .< 0.01*whee) == trues(1,n)
        break
    end
    global converge += 1
end
if verbose @printf("Within 1%% in %s steps.\n", converge) end
plot(reshape(whee, length(whee), 1))
m = maximum(whee)
plot!(reshape(E*m, length(E), 1))
gui()

using Printf
using LinearAlgebra
using Plots

# Choose an arbitrary epsilon to define convergence
const EPSILON = 1e-10

# verbose = false
# if "-v" in ARGS
#     global verbose = true
# end

function pprint(matrix)
    print("\n")
    display(matrix)
    print("\n\n")
end


function simulate_proteins(n)
    E = zeros(n)
    for i in 1:n
        E[i] = 10 + rand()
    end
    E[Int(n/2)] = rand()
    E[Int(n/2)+1] = rand()+rand()
    E[Int(n/2)-1] = rand()+rand()
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
    for i in 1:n
        for j in 1:n-i
            tmp = rand()
            F[i, j+i] += tmp
            F[j+i, i] += tmp
        end
    end
    K = zeros(n)
    vals = []
    for i in 1:n
        sum = 0
        for j in 1:n
            sum += exp(E[i] - F[i,j])
        end
        K[i] = 1/sum
    end

    P = zeros(n, n)
    for i in 1:n
        for j in 1:n
            P[i,j] = K[i] * exp(E[i] - F[i,j])
        end
    end

    x = rand(n)
    x /=  sum(x)
    x_t = zeros(1,n)
    transpose!(x_t, x)

    
    whee = x_t*P
    data = Matrix{Float64}[]
    counter = 1
    while true
        old = whee;
        whee = whee*P
        push!(data, whee)
        # print(whee)
        if sum(broadcast(abs, whee-old)) < EPSILON
            break
        end
        counter = counter + 1
    end

    converge = 1
    for i in data
        if (broadcast(abs, i-whee) .< 0.01*whee) == trues(1,n)
            break
        end
        converge += 1
    end

    plot(reshape(whee, length(whee), 1), label="Probability", color=:red, legend=:bottomleft)
    m = maximum(whee)
    ax2 = twinx()
    plot!(ax2, reshape(E*m, length(E), 1), label="Energy level")    
    xlabel!("State")
    savefig("test.png")

    return (counter, converge)
end
    
    
convergence_times = []
one_percent_times = []
for i in 10:12
    out = simulate_proteins(i)
    push!(convergence_times, out[1])
    push!(one_percent_times, out[2])
end
plot(convergence_times, label = "Convergence")
plot!(one_percent_times, label = "Within 1% of convergence")
xlabel!("# of states")
ylabel!("# of steps")
gui()

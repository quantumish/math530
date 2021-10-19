using Printf
using LinearAlgebra
using Plots

function pprint(matrix)
    print("\n")
    display(matrix)
    print("\n\n")
end

n = parse(Int64, ARGS[1])
#E = [0,1,2.1,3,5,6,9.4,8,9,10,10,12,13,14,15]
E = zeros(n)
for i in 1:n
    E[i] = rand()
end
#pprint(E)

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
print("F (original):")
#pprint(F)
for i in 1:n
    for j in 1:n-i
        tmp = rand()
	    #F[i, j+i] += tmp
	    #F[j+i, i] += tmp
    end
end
print("F (corrected)")
#pprint(F)
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
print("K: ", K, "\n")

P = zeros(n, n)
for i in 1:n
    for j in 1:n
        P[i,j] = K[i] * exp(E[i] - F[i,j])
    end
end

print("P:")
#pprint(P)
# softmax!(P)
# pprint(P)
print("Init:")
x = zeros(n)
for i in 1:n
    x[i] = rand()
end
x /= sum(x)
x_t = zeros(1,n)
transpose!(x_t, x)
#pprint(x)
whee = x_t*P
display(whee); @printf("\nConverged: \n");
for i in 1:10000
    # pprint(whee);
    global whee = whee*P
end
#pprint(whee)
plot(reshape(whee, length(whee), 1))
m = maximum(whee)
plot!(reshape(E*m, length(E), 1))
gui()

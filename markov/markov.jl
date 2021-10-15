using Printf
E = [rand()*100, rand()*100, rand()*100j]
display(E)

F = zeros(size(E,1), size(E,1))
for i in 1:size(E,1)
    for j in 1:size(E,1)
        if E[i] == E[j]
            F[i,j] = E[i]
        else
            F[i,j] = E[i]+E[j]
        end
    end
end
for i in 1:size(E,1)
	for j in 1:size(E,1)-i
        tmp = rand()
	    F[i, j+i] += tmp
	    F[j+i, i] += tmp
    end
end
@printf("\nF:\n")
display(F)
@printf("\n")

K = 0

vals = []
for i in 1:size(E,1)
    sum = 0
    for j in 1:size(E,1)
        # @printf("%s %s\n", E[i], F[i,j])
        sum += exp(E[i] - F[i,j])
    end
    append!(vals, sum)
end
K = rand() * 1/maximum(vals)
@printf("K:\n")
display(K)

@printf("\n");

P = zeros(size(F,1), size(F,2))
for i in 1:size(P,1)
    for j in 1:size(P,2)
        # @printf("i: %s j: %s\n",i,j)
        # @printf("E[i]: %s, F[i,j]: %s, diff: %s\n", E[i], F[i,j], E[i]-F[i,j])       
        P[i,j] = K * exp(E[i] - F[i,j])
    end
end
@printf("P:\n")
display(P)
@printf("\n")

x = [1,2,3]
x = transpose(x)
whee = x*P
display(whee); @printf("\n");
for i in 1:10000
    global whee = whee*P
end
display(whee)
@printf("\n")

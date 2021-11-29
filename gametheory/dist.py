import random
import numpy as np
import matplotlib.pyplot as plt

def play_game():
    x_1 = random.random()
    x = np.array([x_1, 1-x_1])
    
    y_1 = random.random()
    y = np.array([y_1, 1-y_1]).transpose()
    
    A = np.array([[5, 3], [-1, 2]])
    B = np.array([[7, 8], [-4, -5]])

    mystical = np.array([[(2/(x_1*y_1) * (x @ A @ y)) + -(x @ B @ y)/y_1],
                         [-(x @ A @ y)/x_1 +  x@B@y]])
    print(np.array([[x_1*y_1, x_1],[y_1, 2]]) @ mystical, x @ A @ y, x @ B @ y)
    
    a_hist = [0]
    b_hist = [0]
    for i in range(10000):
        r = random.random()
        if r < x[0]:
            a_choice = 0
        else:
            a_choice = 1
        r = random.random()
        if r < y[0]:
            b_choice = 0
        else:
            b_choice = 1
        # print([A[a_choice, b_choice], B[a_choice, b_choice]], x, y)
        scores_a = x @ A
        scores_b = B @ y
        a_hist.append(scores_a[b_choice]+a_hist[i-1])
        b_hist.append(scores_b[a_choice]+b_hist[i-1])
        #print(scores_a[b_choice]+scores_b[a_choice], (x@A@y + x@B@y))

        
    plt.plot(a_hist, label="A")
    plt.plot(b_hist, label="B")
    plt.legend()
    plt.show()
    sum = 0
    for i in range(10000):
        sum += (x@A@y + x@B@y)
    print(a_hist[-1] + b_hist[-1], sum)
    if (a_hist[-1] > b_hist[-1]):
        return "A"
    else:
        return "B"


play_game()
    
# a_count, b_count = 0, 0
# for i in range(1000):
#     out = play_game()
#     if out == "A":
#         a_count+=1
#     else:
#         b_count+=1
#     print(i, end="\r")
# print()
# print(a_count, b_count)

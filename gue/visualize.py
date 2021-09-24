
import matplotlib.pyplot as plt
import numpy as np
import gue

for i in range(1, 10):
    data = gue.generate_gue_dets(i, 100000)
    plt.hist(data, bins=np.arange(min(data), max(data)+0.01, 0.01))
    plt.title("GUE where N = %s" % i)
    plt.show()

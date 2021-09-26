
import matplotlib.pyplot as plt
import numpy as np
import gue
import sys

i = int(sys.argv[1])

data = gue.generate_gue_dets(i, 100000)
print("Mean: %s. StdDev: %s." % (np.mean(data), np.std(data)))
plt.hist(data, bins=np.arange(min(data), max(data)+0.01, 0.01))
plt.title("GUE where N = %s" % i)
plt.show()


data = gue.generate_gue_traces(i, 100000)
print("Mean: %s. StdDev: %s." % (np.mean(data), np.std(data)))
plt.hist(data, bins=np.arange(min(data), max(data)+0.01, 0.01))
plt.title("trace where N = %s" % i)
plt.show()

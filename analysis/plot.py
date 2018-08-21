import matplotlib.pyplot as plt

files = ['legacy_multifit_cpu', 'legacy_multifit_gpu', 'multifit_cpu']
channels = [2 ** x for x in range(10, 17)]

metrics = {}

for file in files:
    with open(file + '.txt', 'r') as f:
        values = [float(x.split(' ')[-1][:-1]) for x in f.readlines()]
        metrics[file] = values

fig = plt.figure()
ax = plt.axes()

# for file in files:
#     ax.plot(channels, metrics[file], label=file)

# ax.set_xscale('log')
# ax.set_xticks(channels)
# ax.set_xticklabels([str(x) for x in channels])
ax.set_xlabel('channels')
# ax.set_ylabel('time (ms)')
ax.set_ylabel('speed-up')
# plt.show()

ax = plt.subplot(111)
w = 0.3
x = list(range(len(channels)))
# ax.set_xticks(x)
for file in files:
    ax.bar(x, [(a/b) for a, b in zip(metrics[files[0]],
                                     metrics[file])], width=w, label=file, align='center')
    x = [x + w for x in x]
ax.set_xticks([x - 2*w for x in x])
# ax.set_yticklabels(['1/2'] + list(range(4)))
ax.set_xticklabels(channels)
ax.autoscale(tight=True)
ax.legend()
plt.show()

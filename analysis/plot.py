import matplotlib.pyplot as plt
import pandas as pd

files = ['legacy_multifit_cpu', 'legacy_multifit_gpu', 'multifit_cpu',
         'multifit_gpu', 'multifit_gpu_swap', 'multifit_cpu_swap']
channels = [2 ** x for x in range(10, 17)]

metrics = {}

for file in files:
    with open(file + '.txt', 'r') as f:
        values = [float(x.split(' ')[-1][:-1]) for x in f.readlines()]
        metrics[file] = values
        print(file, values)

format = 'pdf'


def log_line_plot():
    fig = plt.figure()
    ax = plt.axes()

    translation = 0.
    for file in files:
        if 'gpu' in file:
            ax.plot(
                channels, [x + translation*x for x in metrics[file]], label=file)
            translation += 0.075
        else:
            ax.plot(channels, metrics[file], label=file)

    ax.set_xscale('log')
    ax.set_xticks(channels)
    ax.set_xticklabels([str(x) for x in channels])
    ax.set_xlabel('channels (log-scale)')
    ax.set_ylabel('time (ms)')
    ax.set_title = ('Time to complete 10 iterations')

    ax.legend()
    fig.savefig('log_line_plot'+'.'+format, format=format)
    plt.show()


def line_plot():
    fig = plt.figure()
    ax = plt.axes()

    translation = 0.
    for file in files:
        if 'gpu' in file:
            ax.plot(
                channels, [x + translation*x for x in metrics[file]], label=file)
            translation += 0.075
        else:
            ax.plot(channels, metrics[file], label=file)

    ax.set_xlabel('channels')
    ax.set_ylabel('time (ms)')
    ax.set_title('Time to complete 10 iterations')

    ax.legend()

    fig.savefig('line_plot.'+format, format=format)
    plt.show()


def bar_plot():
    fig = plt.figure()
    ax = plt.axes()
    ax = plt.subplot(111)
    w = 0.1
    x = list(range(len(channels)))
    # ax.set_xticks(x)
    for file in files:
        ax.bar(x, [(a/b) for a, b in zip(metrics[files[0]],
                                         metrics[file])], width=w, label=file, align='center')
        x = [x + w for x in x]
    ax.set_ylabel('speed-up')
    ax.set_xlabel('channels')
    ax.set_xticks([x-(len(channels)/2 * w) for x in x])
    ax.set_xticklabels(channels)
    ax.autoscale(tight=True)
    ax.set_title('Speed-up using legacy_multifit_cpu as reference value')
    ax.legend(loc='upper center', bbox_to_anchor=(0.75, 0.75))
    # ax.legend(loc='upper left')
    fig.savefig('bar_plot.'+format, format=format)
    plt.show()


def latex_table():
    frame = pd.DataFrame(columns=files)
    # frame.columns = files
    for file in files:
        speedup = [round(a/b, 2)
                   for a, b in zip(metrics[files[0]], metrics[file])]
        frame[file] = speedup
    frame['channels'] = channels
    frame = frame.set_index('channels')
    print(frame.T.to_latex())
    # print(frame)


# log_line_plot()
# line_plot()
bar_plot()
# latex_table()

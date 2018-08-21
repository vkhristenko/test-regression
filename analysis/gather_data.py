from subprocess import Popen, PIPE

iterations = 10
filename = '../data/mysample_1000_-13.000_0.000_10_25.00_10.00_0.00_1.000_1.00_0.00_slew_1.00.root'
versions = ['legacy_multifit_cpu', 'legacy_multifit_gpu', 'multifit_cpu']

for version in versions:
  with open(version + '.txt', 'w') as f:
    for channels in [2 ** x for x in range(10, 17)]:
      process = Popen(['../build/' + version + '/' + version, filename, str(iterations), str(channels)], stdout=PIPE)
      print(*[version, str(iterations), str(channels)])
      while True:
        line =  str(process.stdout.readline(), encoding='UTF-8')
        if 'Mean Duration' in line:
          print(channels,line.split(' ')[-1][:-1], file=f)
          break
from subprocess import Popen, PIPE
import argparse
import json
import sys,os
from time import sleep

iterations = 10

def parse_stdout(stream):
    for line in stream:
        if "Mean Duration" in line:
            print line
            duration = float(line.split(" ")[-1].rstrip())
            print duration
            return duration

def run(args):
    print args
    values = []
    iterations = args.iterations
    for num_channels in [2 ** x for x in range(10, 17)]:
        process = Popen([args.exe, args.inp, str(iterations), str(num_channels)], stdout=PIPE)
        duration = parse_stdout(process.stdout)
        values.append(duration)
    return values

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "arg parser")
    parser.add_argument("--exe", dest="exe", type=str, help="executable to launch repeatedly")
    parser.add_argument("--label", dest="label", type=str, help="lable to use for output and as a description")
    parser.add_argument("--outdir", dest="outdir", type=str, help="output directory where to put <lable>.json file")
    parser.add_argument("--inp", dest="inp", type=str, help="root input file")
    parser.add_argument("--iterations", dest="iterations", type=int, default=10, help="number of iterations for each executable invocation")
    args = parser.parse_args()
    values = run(args)
    
    with open(os.path.join(args.outdir, args.label + ".csv"), "w") as f:
        f.write(",".join(map(str, values)) + "\n")

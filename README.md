# test-regression
testing cms hcal/ecal regression 

## to build
- `git clone <repo>` and `cd <repo>`
- `mkdir build` and `cd build`
- `cmake ../ -DEIGEN_HOME=<path to eigen root dir>` 
- `cmake ../ -DDOpenCL_INCLUDE_DIR=<path to opencl root dir>`
- `cmake ../ -DDEBUG=ON to compile in debug mode>`
- `cmake ../ -DTURNOFF_CUDA=ON to disable cuda>`
- `cmake ../ -DTURNOFF_OPENCL=ON to disable opencl>`
- if u r @vinavx2 use: `cmake ../ -DEIGEN_HOME=/data/user/vkhriste/eigen/eigen -DOpenCL_INCLUDE_DIR=/usr/local/cuda-9.2/include`
- if u r @olsky03 use: `cmake ../ -DEIGEN_HOME=/data/vkhriste/eigen/ -DTURNOFF_CUDA=ON -DOpenCL_INCLUDE_DIR=/data/PAC/inteldevstack/intelFPGA_pro/hld/host/include -DOpenCL_LIBRARY=/data/PAC/inteldevstack/intelFPGA_pro/hld/host/linux64/lib/libOpenCL.so`

## to run
- generate pulses `./gen/gen_data -13`
- run multifit cpu `./multifit_cpu/multifit_cpu ../data/<filename> <num_iterations> <num_channels_per_iteration>`
- run multifit gpu `./multifit_gpu/multifit_gpu ../data/<filename> <num_iterations> <num_channels_per_iteration>`

## to profile cache utilization
- compile with -g and optimizations
- run `valgrind --tool=cachegrind <program>` specifying the program to be profiled
- run `KCachegrind` with on the file produced by `valgrind` to visualize the results

## Structure

- `gen`: test data generator.
- `io`: input data parser.
- `legacy_multifit_cpu`: old `cms_sw` hcal/ecal code.
- `legacy_multifit_cpu`: gpu porting of old `cms_sw` hcal/ecal code.
- `multifit_cpu`: `cms_sw` hcal/ecal code updated with the new version of nnls/fnnls.
- `multifit_gpu`: gpu porting of `multifit_cpu`
- `nnls`: CPU/GPU version of nnls/fnnls and inplace fnnls by Marco. 
- `test_nnls_cpu`: tests for nnls and io.

## on vinavx2 machine
- `source /data/user/vkhriste/setup.sh`
- proceed to _build_ and _run_

## Current Work

### Lin Algebra Reimpl Roadmap
- _DONE:_ implement cholesky and forward/backward solvers + tests
- Verify that we can skip full recomputation of cholesky/solvers when adding rows/columns.
 - _Only in-between removal of row/column is left to test_

### OpenCL with fpga
- _DONE:_ outline the fnnls algorithm
- finalize the fnnls kernel + lin algebra stuff + input for the kernel
- test compilation/running on a cpu/gpu
 - use predefined matrices/vectors
- compile the bitstream for the fpga and test varying the multiplicity of channels 
 - _note_: this is just a single fnnls.
 - do a similar test with eigen based impl
 - compare ballpark wall clock
- decide how to deal with the rest of the __legacy impl (PulseChiSqSNNLS.cpp)__

### GPU/CPU 
- test if lin algebra primitives reimpls could be beneficial for gpu/cpu eigen impls

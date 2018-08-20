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

## to run
- generate pulses `./gen/gen_data -13`
- run multifit cpu `./multifit_cpu/multifit_cpu ../data/<filename> <num_iterations> <num_channels_per_iteration>`
- run multifit gpu `./multifit_gpu/multifit_gpu ../data/<filename> <num_iterations> <num_channels_per_iteration>`

## Structure

- `gen`: test data generator.
- `io`: input data parser.
- `legacy_multifit_cpu`: old cms_sw hcal/ecal code.
- `legacy_multifit_cpu`: gpu porting og old cms_sw hcal/ecal code.
- `multifit_cpu`: cms_sw hcal/ecal code updated with the new version of nnls/fnnls.
- `multifit_gpu`: gpu porting of `multifit_cpu` (WIP).
- `nnls_cpu`: new version of nnls/fnnls and inplace fnnls by Marco. 
- `nnls_gpu`: gpu wrappers of `nnls_cpu`.
- `test_nnls_cpu`: tests for nnls and io.

## on vinavx2 machine
- `source /data/user/vkhriste/setup.sh`
- proceed to _build_ and _run_

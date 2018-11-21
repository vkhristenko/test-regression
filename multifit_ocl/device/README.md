# collection of kernels description

- `regression_inplace_fnnls.cl` - original implmeentation. no channels. single kernel. no attempt to map to data flow
- `regression_inplace_fnnls_v1.cl` - blocking channels, multiple kernels (some are autorun). 


__global__ void kernel_test() {
    return;
}

void test_on_cpu() {
    kernel_test<<<1,1>>>();
}


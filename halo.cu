#include <stdio.h>
#include <assert.h>

#define N 1024

int A_arr[N];
int B_arr[N];
int C_arr[N];

extern __device__ int
add1(int a, int b);

__global__ void add(const int *A, const int *B, int *C, size_t n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
	C[i] = add1(A[i], B[i]);
	printf("i = %d, A[%d] = %d, B[%d] = %d, C[%d] = %d, blockIdx.x = %d, blockDim.x = %d, threadIdx.x = %d\n", i, i, A[i], i,
	B[i], i, C[i], blockIdx.x, blockDim.x, threadIdx.x);
    }
}

int main(void) {
    for (size_t i = 0; i < N; i++)
	A_arr[i] = i, B_arr[i] = 1;

    int *dev_A, *dev_B, *dev_C;
    assert(cudaSuccess == cudaMalloc(&dev_A, N * sizeof(int)));
    assert(cudaSuccess == cudaMalloc(&dev_B, N * sizeof(int)));
    assert(cudaSuccess == cudaMalloc(&dev_C, N * sizeof(int)));
    assert(cudaSuccess == cudaMemcpy(dev_A, A_arr, N * sizeof(int), cudaMemcpyHostToDevice));
    assert(cudaSuccess == cudaMemcpy(dev_B, B_arr, N * sizeof(int), cudaMemcpyHostToDevice));

    size_t blockDim_x = 512;
    size_t nr_block = (N + blockDim_x - 1) / blockDim_x;

    add<<<nr_block, blockDim_x>>>(dev_A, dev_B, dev_C, N);
    assert(cudaSuccess == cudaMemcpy(C_arr, dev_C, N * sizeof(int), cudaMemcpyDeviceToHost));

    cudaFree(dev_A);
    cudaFree(dev_B);
    cudaFree(dev_C);

    printf("C = {");
    for (size_t i = 0; i < N; i++)
	printf("%d,", C_arr[i]);
    printf("}\n");

    return 0;
}

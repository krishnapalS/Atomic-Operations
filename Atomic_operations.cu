// By: Krishna Pal Deora , 18JE0425. , Integrated M.Tech. Mathematics & Computing (6th semester)


#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <math.h>

/**
 * This example illustrates implementation of custom atomic operations using
 * CUDA's built-in atomicCAS function to implement atomic signed 32-bit integer
 * atomicAdd,atomicSub,atomicMax,atomicMin.
 **/

 // atomicAdd()
 
__device__ int myAtomicAdd(int *address, int incr)
{
    // Create an initial guess for the value stored at *address.
    int guess = *address;
    int oldValue = atomicCAS(address, guess, guess + incr);

    // Loop while the guess is incorrect.
    while (oldValue != guess)
    {
        guess = oldValue;
        oldValue = atomicCAS(address, guess, guess + incr);
    }

    return oldValue;
}

//atomicSub()

__device__ int atomicSub(int* address, int val);
unsigned int atomicSub(unsigned int* address,unsigned int val);

 atomicMax()

__device__ int atomicMax(int* address, int val);
unsigned int atomicMax(unsigned int* address,unsigned int val);
unsigned long long int atomicMax(unsigned long long int* address,unsigned long long int val);

// atomicMin()
__device__ int atomicMin(int* address, int val);
unsigned int atomicMin(unsigned int* address,unsigned int val);
unsigned long long int atomicMin(unsigned long long int* address,unsigned long long int val);



__global__ void kernel(int *sharedInteger)
{
    myAtomicAdd(sharedInteger, 1);
}

int main(int argc, char **argv)
{
    int h_sharedInteger;
    int *d_sharedInteger;
    CHECK(cudaMalloc((void **)&d_sharedInteger, sizeof(int)));
    CHECK(cudaMemset(d_sharedInteger, 0x00, sizeof(int)));

    kernel<<<4, 128>>>(d_sharedInteger);

    CHECK(cudaMemcpy(&h_sharedInteger, d_sharedInteger, sizeof(int),
                     cudaMemcpyDeviceToHost));
    printf("4 x 128 increments led to value of %d\n", h_sharedInteger);

    return 0;
}


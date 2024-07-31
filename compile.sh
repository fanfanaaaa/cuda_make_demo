#!/bin/bash -x
CUDA_PATH=/usr/local/cuda-11.7
nvcc add.cu -dc -o add.o
nvcc halo.cu -dc -o halo.o
nvcc halo.o add.o -dlink -o a_dlink.o
g++ halo.o add.o a_dlink.o \
	-L${CUDA_PATH}/bin/../targets/x86_64-linux/lib/stubs \
	-L${CUDA_PATH}/bin/../targets/x86_64-linux/lib  \
	-lcudadevrt  \
	-lcudart_static  \
	-lrt \
	-lpthread  \
	-ldl  \
	-o a.out

/usr/local/cuda-12.3/bin/nvcc \
    --threads=0  -rdc=true -t=0 --use_fast_math -std=c++17 -O3 -DUSE_MPI -DENABLE_BF16 --generate-code code=sm_80,arch=compute_80 \
    train_gpt2_gpufs.cu -o train_gpt2_gpufscu \
    -L/usr/lib/x86_64-linux-gnu/openmpi/lib/ -lmpi \
    -I /usr/local/cuda/targets/x86_64-linux/include/ \
    -I/usr/lib/x86_64-linux-gnu/openmpi/include/ \
    -I /home/hyf/Ganymede/Comparision/gpufs/include/ \
    -L/home/hyf/Ganymede/Comparision/gpufs/lib/ -lgpufs \
    -I/usr/local/cuda/include \
    -L/usr/local/cuda/lib64 -lcudart -lcublas -lcublasLt -lnvidia-ml 

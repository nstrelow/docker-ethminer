FROM nvidia/cuda:10.2-devel-ubuntu18.04

MAINTAINER Nils Strelow
#Original MAINTAINER Anthony Tatowicz

WORKDIR /

# Package and dependency setup
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get update \
    && apt-get install -y git \
     cmake \
     opencl-headers \
     mesa-common-dev \
     build-essential \
     libdbus-1-dev \
     perl

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer.git; \
    cd ethminer; \
    git checkout tags/v0.18.0; \
    git submodule update --init --recursive

# Build
RUN cd ethminer; \
    mkdir build; \
    cd build; \
    cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON; \
    cmake --build .; \
    make install;

# Env setup
ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100

ENTRYPOINT ["/usr/local/bin/ethminer", "-U"]

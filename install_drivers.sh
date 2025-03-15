#!/bin/bash

# Exit on error
set -e

echo "Updating package lists..."
#sudo apt update

echo "Installing required dependencies..."
sudo apt install -y software-properties-common wget curl

# Check if NVIDIA driver 535 is installed
echo "Checking NVIDIA driver version..."
if nvidia-smi | grep -q "Driver Version: 535"; then
    echo "NVIDIA Driver 535 is installed."
else
    echo "NVIDIA Driver 535 not found. Please install it first."
    exit 1
fi

# Install CUDA 12.2 if not installed
echo "Checking CUDA version..."
if ! nvcc --version | grep -q "release 12.2"; then
    echo "CUDA 12.2 not found. Installing CUDA 12.2..."
    wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run
    sudo sh cuda_12.2.0_535.54.03_linux.run --silent --toolkit
    echo "export PATH=/usr/local/cuda-12.2/bin:$PATH" >> ~/.bashrc
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc
    source ~/.bashrc
else
    echo "CUDA 12.2 is already installed."
fi

# Install TensorRT 8.6.1
echo "Installing TensorRT 8.6.1..."
TENSORRT_URL="https://developer.download.nvidia.com/compute/machine-learning/tensorrt/secure/8.6.1/local_repos/ubuntu2204-x86_64/tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.2_1.0-1_amd64.deb"
wget --content-disposition "$TENSORRT_URL"
sudo dpkg -i tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.2_1.0-1_amd64.deb
sudo cp /var/tensorrt-local-repo-*/7fa2af80.pub /usr/share/keyrings/
sudo apt update
sudo apt install -y tensorrt

# Verify installation
echo "Verifying TensorRT installation..."
if command -v trtexec &> /dev/null; then
    echo "TensorRT installed successfully!"
    trtexec --version
else
    echo "TensorRT installation failed."
    exit 1
fi

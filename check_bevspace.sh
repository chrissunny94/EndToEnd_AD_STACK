#!/bin/bash

echo "=============================="
echo "  BEVFusion Environment Check "
echo "=============================="

# Function to check if a package is installed
check_package() {
    dpkg -l | grep -i "$1" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "[✔] $1 is installed"
    else
        echo "[✖] $1 is NOT installed"
    fi
}

# Function to check environment variables
check_env_var() {
    if [ -z "${!1}" ]; then
        echo "[✖] $1 is NOT set"
    else
        echo "[✔] $1 is set to ${!1}"
    fi
}

echo ""
echo "Checking system dependencies..."
check_package "cuda-toolkit"
check_package "libcudnn8"
check_package "tensorrt"
check_package "ros-humble-desktop"
check_package "python3-pip"

echo ""
echo "Checking CUDA and GPU..."
if command -v nvcc &> /dev/null; then
    echo "[✔] CUDA is installed"
    nvcc --version
else
    echo "[✖] CUDA is NOT installed"
fi

if command -v nvidia-smi &> /dev/null; then
    echo "[✔] NVIDIA driver is installed"
    nvidia-smi
else
    echo "[✖] NVIDIA driver is NOT installed"
fi

echo ""
echo "Checking cuDNN..."
if ls /usr/lib/x86_64-linux-gnu/ | grep -q "libcudnn"; then
    echo "[✔] cuDNN is installed"
    ls -l /usr/lib/x86_64-linux-gnu/ | grep "libcudnn"
else
    echo "[✖] cuDNN is NOT installed"
fi

echo ""
echo "Checking TensorRT..."
if dpkg -l | grep -q "libnvinfer"; then
    echo "[✔] TensorRT is installed"
else
    echo "[✖] TensorRT is NOT installed"
fi

echo ""
echo "Checking ROS 2..."
if command -v ros2 &> /dev/null; then
    echo "[✔] ROS 2 is installed"
else
    echo "[✖] ROS 2 is NOT installed"
fi

echo ""
echo "Checking Python dependencies..."
if python3 -c "import torch; print(torch.__version__)" &> /dev/null; then
    echo "[✔] PyTorch is installed"
    python3 -c "import torch; print(torch.__version__)"
else
    echo "[✖] PyTorch is NOT installed"
fi

if python3 -c "import tensorrt" &> /dev/null; then
    echo "[✔] TensorRT Python bindings are installed"
else
    echo "[✖] TensorRT Python bindings are NOT installed"
fi

echo ""
echo "Checking Environment Variables..."
check_env_var "CUDA_HOME"
check_env_var "LD_LIBRARY_PATH"
check_env_var "PYTHONPATH"

echo ""
echo "=============================="
echo "  Verification Complete!  "
echo "=============================="

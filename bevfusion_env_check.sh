#!/bin/bash

echo "=============================="
echo "  BEVFusion Environment Check  "
echo "=============================="

check_installed() {
    if command -v "$1" &>/dev/null; then
        echo "[✔] $1 is installed"
    else
        echo "[✘] $1 is missing"
    fi
}

check_env_var() {
    if [[ -z "${!1}" ]]; then
        echo "[✘] $1 is not set"
    else
        echo "[✔] $1 is set to ${!1}"
    fi
}

echo -e "\nChecking system dependencies..."
check_installed nvcc
check_installed nvidia-smi
check_installed python3
check_installed pip3
check_installed ros2

echo -e "\nChecking CUDA and GPU..."
if command -v nvcc &>/dev/null; then
    nvcc --version
fi
if command -v nvidia-smi &>/dev/null; then
    nvidia-smi
fi

echo -e "\nChecking cuDNN..."
if ldconfig -p | grep -q libcudnn; then
    echo "[✔] cuDNN is installed"
else
    echo "[✘] cuDNN is missing"
fi

echo -e "\nChecking TensorRT..."
if ldconfig -p | grep -q libnvinfer; then
    echo "[✔] TensorRT is installed"
else
    echo "[✘] TensorRT is missing"
fi

echo -e "\nChecking ROS 2..."
if command -v ros2 &>/dev/null; then
    echo "[✔] ROS 2 is installed"
else
    echo "[✘] ROS 2 is missing"
fi

echo -e "\nChecking Python dependencies..."
if python3 -c "import torch; print(torch.__version__)" &>/dev/null; then
    echo "[✔] PyTorch is installed"
    python3 -c "import torch; print(torch.__version__)"
else
    echo "[✘] PyTorch is missing"
fi

if python3 -c "import tensorrt" &>/dev/null; then
    echo "[✔] TensorRT Python bindings are installed"
else
    echo "[✘] TensorRT Python bindings are missing"
fi

echo -e "\nChecking Environment Variables..."
check_env_var CUDA_HOME
check_env_var LD_LIBRARY_PATH
check_env_var PYTHONPATH

echo -e "\n=============================="
echo "  Verification Complete!  "
echo "=============================="

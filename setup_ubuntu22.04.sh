#!/bin/bash

# Stop on errors
set -e

echo "🔄 Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "🛠️ Installing essential build tools..."
sudo apt install -y build-essential cmake git unzip wget curl \
    software-properties-common apt-transport-https ca-certificates \
    gnupg lsb-release

echo "🧹 Removing broken PPAs..."
sudo add-apt-repository --remove ppa:plushuang-tw/uget-stable || true

echo "🔑 Fixing deprecated apt-key usage..."
sudo mkdir -p /etc/apt/keyrings
sudo rm -rf /etc/apt/trusted.gpg

echo "📦 Installing NVIDIA GPU Drivers and CUDA..."
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers install
sudo apt install -y nvidia-driver-535 nvidia-utils-535

echo "🔧 Installing CUDA 11.8 and cuDNN..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y cuda-11-8 libcudnn8

echo "🔍 Verifying CUDA installation..."
echo 'export PATH=/usr/local/cuda-11.8/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
nvcc --version

echo "🐳 Installing Docker and NVIDIA Container Toolkit..."
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-container-runtime.gpg
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker

echo "🤖 Installing PyTorch with CUDA support..."
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

echo "🛠️ Installing TensorFlow (GPU)..."
pip3 install tensorflow==2.8.0 keras

echo "🚀 Installing TensorRT for optimized inference..."
sudo apt install -y tensorrt libnvinfer8 libnvinfer-plugin8

echo "🤖 Installing ROS2 (Humble)..."
sudo apt install -y ros-humble-desktop
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "🚘 Setting up CARLA simulator..."
mkdir -p ~/carla
cd ~/carla
wget https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/CARLA_0.9.14.tar.gz
tar -xvzf CARLA_0.9.14.tar.gz

echo "🎉 Installation complete!"
echo "🚀 Reboot your system for all changes to take effect!"

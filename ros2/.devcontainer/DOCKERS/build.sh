# Base Image
docker build -t christhaliyath/base:latest -f Dockerfile.base .

# ROS 2 Image
docker build -t christhaliyath/ros:latest -f Dockerfile.ros .

# TensorRT Image
docker build -t christhaliyath/tensorrt:latest -f Dockerfile.tensorrt .

# PyTorch Image
docker build -t christhaliyath/pytorch:latest -f Dockerfile.pytorch .

# Final Image
docker build -t christhaliyath/final:latest -f Dockerfile.final .

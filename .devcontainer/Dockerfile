
ARG DOCKER_REPO
ARG ROS_DISTRO
ARG IMAGE_SUFFIX
# FROM $DOCKER_REPO:$ROS_DISTRO$IMAGE_SUFFIX
ARG USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# Use NVIDIA CUDA 11.8 base image with Ubuntu 22.04
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install basic utilities and dependencies
RUN apt update && apt install -y \
    curl gnupg2 lsb-release \
    git cmake build-essential \
    python3-pip python3-venv python3-dev \
    libglfw3-dev libglew-dev libeigen3-dev \
    libjsoncpp-dev libtbb-dev libgtest-dev \
    && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y software-properties-common

# RUN apt update && apt install -y curl gnupg2 lsb-release \
#     && curl -sSL 'http://repo.ros2.org/repos.key' | apt-key add - \
#     && sh -c 'echo "deb http://packages.ros2.org/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list' \
#     && apt update

# Properly add ROS 2 repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | tee /usr/share/keyrings/ros-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Update package lists
RUN apt update

# Install ROS 2 Humble and dependencies
RUN apt install -y ros-humble-ros-base

# Now install colcon
RUN apt install -y python3-colcon-common-extensions

# Ensure CUDA paths are set correctly
ENV CUDA_HOME=/usr/local/cuda
ENV PATH="${CUDA_HOME}/bin:${PATH}"
ENV LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"

# Verify CUDA installation
RUN echo "Checking CUDA installation..." && nvcc --version

# Set up ROS 2 Humble sources (Fixed: Replaced deprecated `apt-key`)
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | tee /usr/share/keyrings/ros-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 Humble
RUN apt update && apt install -y \
    ros-humble-ros-base \
    && rm -rf /var/lib/apt/lists/*

# Source ROS setup
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Install Python dependencies
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    /opt/venv/bin/pip install numpy pyyaml scipy tensorboard matplotlib tqdm opencv-python && \
    /opt/venv/bin/pip install sympy pandas scikit-learn

# Remove existing TensorRT if present
RUN dpkg -l | grep -E 'libnvinfer|tensorrt' && \
    apt remove --purge -y $(dpkg -l | awk '/libnvinfer|tensorrt/ {print $2}') || \
    echo "TensorRT not installed, skipping removal"

# Clean up unnecessary dependencies
RUN apt autoremove -y

# Install TensorRT (pinned to CUDA 11.8)
RUN apt update && apt install -y \
    tensorrt \
    python3-libnvinfer \
    libnvinfer-dev \
    software-properties-common \
    wget
RUN rm -rf /var/lib/apt/lists/*
#RUN apt install -y cuda-toolkit-11-8
RUN rm -f /usr/share/keyrings/cuda-keyring.gpg /usr/share/keyrings/cuda-archive-keyring.gpg
RUN  add-apt-repository -y ppa:graphics-drivers/ppa 
#RUN wget -qO - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | tee /usr/share/keyrings/cuda-keyring.gpg > /dev/null 
RUN wget -qO - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring.gpg | tee /usr/share/keyrings/cuda-archive-keyring.gpg > /dev/null


# RUN echo "deb [signed-by=/usr/share/keyrings/cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | tee /etc/apt/sources.list.d/cuda.list && 
# RUN apt update 
#RUN     apt install -y cuda-toolkit-11-8


# Set working directory
WORKDIR /workspace
# RUN nvcc --version
# RUN nvidia-smi
# RUN colcon build


# Copy project files into the container
COPY . /workspace

# Default command
CMD ["/bin/bash"]
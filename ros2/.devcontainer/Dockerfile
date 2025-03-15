ARG DOCKER_REPO=osrf/ros
ARG ROS_DISTRO=humble
ARG IMAGE_SUFFIX=-desktop



# Base image from ROS + CUDA (official NVIDIA CUDA images)
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS base
# ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata


# Install ROS 2 Humble
ARG ROS_DISTRO=humble
ARG USERNAME=rosuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create user
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y sudo python3-pip python-is-python3 ssh neovim git \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install CUDA, cuDNN, TensorRT, and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake unzip wget curl ca-certificates \
    libprotobuf-dev protobuf-compiler libopencv-dev \
    python3-opencv libgoogle-glog-dev libgflags-dev \
    libeigen3-dev libhdf5-dev && \
    rm -rf /var/lib/apt/lists/*

# Install TensorRT (from NVIDIA repo)
# RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2204/x86_64/nvidia-machine-learning-repo-ubuntu2204_1.0.0-1_all.deb 
# RUN dpkg -i nvidia-machine-learning-repo-ubuntu2204_1.0.0-1_all.deb 
# RUN apt-get update 

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     software-properties-common && \
#     add-apt-repository -y "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2204/x86_64/ /" && \
#     apt-get update
# Add NVIDIA CUDA & TensorRT Repositories
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update


RUN apt-get install -y \
    tensorrt \
    python3-libnvinfer \
    libnvinfer-bin \
    libnvinfer-dev \
    libnvinfer-plugin-dev

RUN rm -rf /var/lib/apt/lists/*

# Install PyTorch (with CUDA support)
RUN pip3 install --upgrade pip && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Set up ROS 2 Humble repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - && \
    sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list' && \
    apt-get update && apt-get install -y \
    ros-humble-desktop \
    && rm -rf /var/lib/apt/lists/*

# Source ROS environment automatically
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
RUN echo "source /home/ws/install/setup.bash" >> /etc/bash.bashrc

# Set default user and shell
USER $USERNAME
ENV SHELL /bin/bash
CMD ["/bin/bash"]

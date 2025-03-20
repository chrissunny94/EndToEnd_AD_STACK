# Base image from ROS + CUDA (official NVIDIA CUDA images)
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    ROS_DISTRO=humble \
    CUDA_HOME=/usr/local/cuda-11.8 \
    PATH=/usr/local/cuda-11.8/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:${LD_LIBRARY_PATH} \
    USERNAME=rosuser \
    USER_UID=1000 \
    USER_GID=1000

# Update & install essential dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata sudo python3-pip python-is-python3 ssh neovim git \
        build-essential cmake unzip wget curl ca-certificates \
        libprotobuf-dev protobuf-compiler libopencv-dev \
        python3-opencv libgoogle-glog-dev libgflags-dev \
        libeigen3-dev libhdf5-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user if not already present
RUN if ! getent group ${USER_GID} > /dev/null; then groupadd --gid ${USER_GID} ${USERNAME}; fi && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Create symbolic links for CUDA
RUN ln -s /usr/local/cuda-11.8 /usr/local/cuda && \
    ln -s /usr/local/cuda-11.8/lib64/libcudart.so /usr/lib/x86_64-linux-gnu/libcudart.so && \
    ln -s /usr/local/cuda-11.8/include/cuda_runtime.h /usr/include/cuda_runtime.h

# Add NVIDIA CUDA & TensorRT Repositories
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && \
    wget https://developer.nvidia.com/compute/machine-learning/tensorrt/secure/8.5.3/local_repos/nv-tensorrt-local-repo-ubuntu2204-8.5.3_1.0-1_amd64.deb && \
    dpkg -i nv-tensorrt-local-repo-ubuntu2204-8.5.3_1.0-1_amd64.deb && \
    apt-get update && \
    apt-get install -y tensorrt libnvinfer8 libnvinfer-plugin8 libnvinfer-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PyTorch (with CUDA support)
RUN pip3 install --upgrade pip && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Set up ROS 2 Humble repository securely
RUN set -e; \
    apt-get update && apt-get install -y curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list && \
    apt-get update && \
    apt-get install -y ros-humble-desktop ros-humble-pcl-ros && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Source ROS environment automatically
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
RUN echo "[ -f /home/${USERNAME}/ws/install/setup.bash ] && source /home/${USERNAME}/ws/install/setup.bash" >> /etc/bash.bashrc

# Set default user and shell
USER $USERNAME
ENV SHELL=/bin/bash
CMD ["/bin/bash"]

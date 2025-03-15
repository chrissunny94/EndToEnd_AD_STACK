#!/bin/bash

set -e  # Exit on error

echo "Setting up ROS 2 Humble on Debian 12 (Bookworm)..."

# Step 1: Add ROS 2 sources
sudo apt update && sudo apt install -y curl gnupg2 lsb-release

# Set up the sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2.list'

# Add the key
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -

# Step 2: Install dependencies
sudo apt update && sudo apt install -y \
    locales \
    software-properties-common \
    build-essential \
    cmake \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    python3-pip \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    libbullet-dev \
    libasio-dev \
    libtinyxml2-dev \
    libcunit1-dev \
    ros-dev-tools

# Step 3: Install ROS 2 Humble Desktop
sudo apt install -y ros-humble-desktop

# Step 4: Initialize rosdep
sudo rosdep init
rosdep update

# Step 5: Setup environment
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "ROS 2 Humble installation complete! Test with:"
echo "source /opt/ros/humble/setup.bash && ros2 run demo_nodes_cpp talker"

cmake_minimum_required(VERSION 3.0.2)
project(bev_image)

# Find dependencies
find_package(catkin REQUIRED COMPONENTS
  roscpp
  sensor_msgs
  cv_bridge
  pcl_conversions
  pcl_ros
)

find_package(OpenCV REQUIRED)

# Declare a catkin package
catkin_package(
  CATKIN_DEPENDS roscpp sensor_msgs cv_bridge pcl_conversions pcl_ros
)

# Include directories
include_directories(
  ${catkin_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
)

# Declare the executable
add_executable(bev_image_from_pointcloud src/bev_image_from_pointcloud.cpp)

# Link the libraries
target_link_libraries(bev_image_from_pointcloud
  ${catkin_LIBRARIES}
  ${OpenCV_LIBRARIES}
)

cmake_minimum_required(VERSION 3.8)
project(bev_image)

# Find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(cv_bridge REQUIRED)
find_package(PCL REQUIRED)
find_package(OpenCV REQUIRED)
find_package(pcl_conversions REQUIRED)

# Include directories
include_directories(
  ${PCL_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
)

# Add the executable
add_executable(bev_image_from_pointcloud src/bev_image_from_pointcloud.cpp)

# Link the libraries
target_link_libraries(bev_image_from_pointcloud
  ${PCL_LIBRARIES}
  ${OpenCV_LIBRARIES}
)

# Specify dependencies for ament
ament_target_dependencies(bev_image_from_pointcloud
  rclcpp
  sensor_msgs
  cv_bridge
  OpenCV
  PCL
  pcl_conversions
)

# Install targets
install(TARGETS bev_image_from_pointcloud
  DESTINATION lib/${PROJECT_NAME}
)

# Export the package
ament_package()

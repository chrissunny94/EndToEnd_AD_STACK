#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <opencv2/opencv.hpp>
#include <cv_bridge/cv_bridge.h>

ros::Publisher bev_pub;

void pointCloudCallback(const sensor_msgs::PointCloud2ConstPtr& cloud_msg) {
    // Convert ROS PointCloud2 message to PCL format
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>());
    pcl::fromROSMsg(*cloud_msg, *cloud);

    // Define BEV parameters
    const float grid_size = 70.0; // Size of the grid (meters)
    const float resolution = 0.1; // Resolution (meters per pixel)
    const float height = 10.0;    // Default height (meters above the Z-axis)
    int grid_dim = static_cast<int>(grid_size / resolution);

    // Create an empty image
    cv::Mat bev_image = cv::Mat::zeros(grid_dim, grid_dim, CV_8UC1);

    // Convert points to BEV
    for (const auto& point : cloud->points) {
        if (point.z > height) continue; // Ignore points above the height
        int x_idx = static_cast<int>((point.x + grid_size / 2.0) / resolution);
        int y_idx = static_cast<int>((point.y + grid_size / 2.0) / resolution);

        if (x_idx >= 0 && x_idx < grid_dim && y_idx >= 0 && y_idx < grid_dim) {
            bev_image.at<uchar>(grid_dim - y_idx - 1, x_idx) = 255; // Set pixel value
        }
    }

    // Convert to ROS image message and publish
    sensor_msgs::ImagePtr bev_msg = cv_bridge::CvImage(std_msgs::Header(), "mono8", bev_image).toImageMsg();
    bev_msg->header = cloud_msg->header; // Maintain original timestamp and frame
    bev_pub.publish(bev_msg);
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "pointcloud_to_bev");
    ros::NodeHandle nh;

    // Subscribe to point cloud topic
    ros::Subscriber pcl_sub = nh.subscribe("/velodyne_points", 1, pointCloudCallback);

    // Advertise BEV image topic
    bev_pub = nh.advertise<sensor_msgs::Image>("/bev_image", 1);

    ros::spin();
    return 0;
}

#!/usr/bin/env python

import rospy
from sensor_msgs.msg import PointCloud2

class PointCloudRepublisher:
    def __init__(self):
        # Initialize the ROS node
        rospy.init_node('pointcloud_republisher', anonymous=True)

        # Subscriber to the /velodyne_points topic
        self.subscriber = rospy.Subscriber('/velodyne_points', PointCloud2, self.pointcloud_callback)

        # Publisher to the /velodyne_points/repub topic
        self.publisher = rospy.Publisher('/velodyne_points/repub', PointCloud2, queue_size=10)

    def pointcloud_callback(self, msg):
        # Modify the frame_id
        msg.header.frame_id = 'lidar'

        # Log the change for debugging
        rospy.loginfo(f'Republishing PointCloud2 message with frame_id: {msg.header.frame_id}')

        # Republishing the message
        self.publisher.publish(msg)

if __name__ == '__main__':
    try:
        republisher = PointCloudRepublisher()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass

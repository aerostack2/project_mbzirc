#!/bin/bash
# ros2 run ros_ign_bridge parameter_bridge /world/coast/model/drone_sim_miguel_0/model/front_camera/link/sensor_link/sensor/semantic_segmentation_camera/segmentation/colored_map@sensor_msgs/msg/Image@ignition.msgs.Image &
ros2 run ros_ign_bridge parameter_bridge /world/coast/model/drone_sim_miguel_0/model/front_camera/link/sensor_link/sensor/camera/image@sensor_msgs/msg/Image@ignition.msgs.Image

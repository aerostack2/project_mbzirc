#!/bin/bash

IMAGE_TOPIC=/world/coast/model/drone_sim_miguel_0/model/front_camera/link/sensor_link/sensor/camera/image

# ros2 run openrobotics_darknet_ros detector_node --ros-args --params-file ./darknet_params.yaml
# ros2 run openrobotics_darknet_ros detector_node --ros-args --params-file ./darknet_params.yaml --remap  __ns:=/$AEROSTACK2_SIMULATION_DRONE_ID --remap detector_node/images:=$IMAGE_TOPIC
ros2 run openrobotics_darknet_ros detector_node --ros-args --params-file ./darknet_params.yaml  --remap detector_node/images:=$IMAGE_TOPIC &
ros2 run detection_visualizer detection_visualizer --ros-args --remap detection_visualizer/images:=$IMAGE_TOPIC --remap detection_visualizer/detections:=/detector_node/detections 


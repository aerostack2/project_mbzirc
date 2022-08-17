#!/bin/bash

drone_namespace="quadrotor_1"


mkdir rosbags 2>/dev/null
cd rosbags &&\
ros2 bag record \
"/$drone_namespace/ground_truth/pose" \
"/$drone_namespace/ground_truth/twist" \
"/$drone_namespace/visual_odometry/odom" \
"/$drone_namespace/slot6/scan"

--qos-profile-overrides-path $(pwd)/../reliability_override.yaml 


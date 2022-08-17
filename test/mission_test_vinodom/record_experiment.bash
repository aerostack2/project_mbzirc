#!/bin/bash

drone_namespace="quadrotor_1"


mkdir rosbags 2>/dev/null
cd rosbags &&\
ros2 bag record \
"/$drone_namespace/ground_truth/pose" \
"/$drone_namespace/ground_truth/twist" \
"/$drone_namespace/slot3/image_raw" \
"/$drone_namespace/slot3/camera_info" \
"/$drone_namespace/slot6/scan" \
"/$drone_namespace/air_pressure" \
"/$drone_namespace/imu/data" \
"/tf" \
"/tf_static"

--qos-profile-overrides-path $(pwd)/../reliability_override_exp.yaml 


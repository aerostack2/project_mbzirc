#!/bin/bash

drone_namespace="quadrotor_1"


mkdir rosbags 2>/dev/null
cd rosbags &&\
ros2 bag record \
"/$drone_namespace/ground_truth/pose" \
"/$drone_namespace/ground_truth/twist" \
"/$drone_namespace/slot0/camera_info" \
"/$drone_namespace/slot0/depth" \
"/$drone_namespace/slot0/image_raw" \
"/$drone_namespace/slot0/points" \
"/$drone_namespace/slot1/rfsensor" \
"/$drone_namespace/slot2/points" \
"/$drone_namespace/slot2/scan" \
"/$drone_namespace/slot6/camera_info" \
"/$drone_namespace/slot6/depth" \
"/$drone_namespace/slot6/image_raw" \
"/$drone_namespace/slot6/points" \
"/$drone_namespace/slot6/scan" \
"/$drone_namespace/slot7/points" \
"/$drone_namespace/slot7/scan" \
"/tf" \
"/tf_static" \
--qos-profile-overrides-path $(pwd)/../reliability_override_sensors.yaml 


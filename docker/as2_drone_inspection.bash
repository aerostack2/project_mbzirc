#!/bin/bash

if [ "$#" -le 0 ]; then
	echo "usage: $0 [drone_namespace] "
	exit 1
fi

# Arguments
drone_namespace=$1

source ./launch/launch_tools.bash

declare -r COMPRESSED_IMAGE_TOPIC='stream/compressed_image'
declare -r REPORT_TOPIC='report'

new_session $drone_namespace  

new_window 'ignition_interface' "ros2 launch ignition_platform ignition_platform_launch.py \
    drone_id:=$drone_namespace"

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    ground_truth:=false \
    odom_only:=true \
    base_frame:='\"\"'"

new_window 'visual_inertial_odometry' "ros2 launch vinodom vinodom_launch.py \
    namespace:=$drone_namespace \
    base_frame:=$drone_namespace \
    show_matching:=false"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace \
    config:=robot_config/controller_manager.yaml"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace  \
    config_takeoff:=robot_config/takeoff.yaml"

new_window 'comms' "ros2 launch mbzirc_comms mbzirc_comms_launch.py \
    robot_id:=$drone_namespace \
    n_drones:=10 \
    pose_topic:=/self_localization/pose \
    tree_topic:=/tree \
    camera_topic:=/$COMPRESSED_IMAGE_TOPIC\
    loc_hist_topic:=/loc_hist \
    report_topic:=/$REPORT_TOPIC "

new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc_bt.launch.py \
    drone_id:=$drone_namespace \
    tree:=drone_roles/anchor_$drone_namespace.xml \
    groot_logger:=false"

new_window 'yolo_detector' " ros2 launch yolo_object_detector yolo_object_detector_launch.py \
  drone_id:=$drone_namespace \
  camera_topic:=slot0/image_raw"

new_window 'stream_compressor' "ros2 launch mbzirc_sim_interface stream_compressor_launch.py \
    namespace:=$drone_namespace \
    rgb_image_topic:=slot0/image_raw \
    detection_topic:=detector_node/detections \
    compressed_image_topic:=/drone_1/$COMPRESSED_IMAGE_TOPIC \
    report_topic:=/drone_1/$REPORT_TOPIC"

echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"
#!/bin/bash

if [ "$#" -le 0 ]; then
	echo "usage: $0 [drone_namespace] "
	exit 1
fi

# Arguments
drone_namespace=$1

source ./launch/launch_tools.bash

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
    show_matching:=false"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace \
    config:=config/controller_manager.yaml"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace  \
    config_takeoff:=config/takeoff.yaml"

new_window 'comms' "ros2 launch mbzirc_comms mbzirc_comms_launch.py \
    robot_id:=$drone_namespace \
    n_drones:=10 \
    pose_topic:=/self_localization/pose \
    tree_topic:=/tree \
    loc_hist_topic:=/loc_hist \
    report_topic:=/report "

new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc.launch.py \
    drone_id:=$drone_namespace \
    tree:=anchor_v2.xml \
    groot_logger:=false"

echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"

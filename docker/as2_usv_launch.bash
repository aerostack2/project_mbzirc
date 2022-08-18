#!/bin/bash

if [ "$#" -le 0 ]; then
	echo "usage: $0 [drone_namespace] "
	exit 1
fi

# Arguments
drone_namespace=$1

source launch/launch_tools.bash

new_session $drone_namespace

new_window 'ignition_interface' "ros2 launch usv_ign_platform usv_ign_platform.py \
    drone_id:=$drone_namespace "

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    ground_truth:=true \
    base_frame:='\"\"' "

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace "

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace "

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace \
    config_takeoff:=usv/takeoff.yaml \
    config_goto:=usv/goto.yaml"

new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc_bt.launch.py \
    drone_id:=$drone_namespace \
    tree:=usv/usv.xml \
    groot_logger:=true \
    groot_client_port:=1668 \
    groot_server_port:=1669"

tmux a -t $drone_namespace
sleep 5000

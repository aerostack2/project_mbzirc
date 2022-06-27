#!/bin/bash

# Arguments
drone_namespace=$1

source ./launch_tools.bash

new_session $drone_namespace

new_window 'ignition_interface' "ros2 launch ignition_platform ignition_platform_launch.py \
    drone_id:=$drone_namespace"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace"

new_window 'static_transform_publisher' "ros2 launch basic_tf_tree_generator basic_tf_tree_generator_launch.py \
    drone_id:=$drone_namespace"

#!/bin/bash

if [ "$#" -le 0 ]; then
	echo "usage: $0 [drone_namespace] "
	exit 1
fi

# Arguments
drone_namespace=$1
tree=$2  #TODO: temporal
tree=${tree:=""}

source ./tools.bash

new_session $drone_namespace

new_window 'ignition_interface' "ros2 launch ignition_platform ignition_platform_launch.py \
    drone_id:=$drone_namespace"

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    ground_truth:=false \
    odom_only:=true \
    base_frame:='\"\"'"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace \
    config:=config/controller_manager.yaml"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace  \
    config_takeoff:=config/takeoff.yaml"

new_window 'visual_inertial_odometry' "ros2 launch vinodom vinodom_launch.py \
    namespace:=$drone_namespace \
    show_matching:=false"

if [[ -n $tree ]]; then
    new_window 'mission_planner' "ros2 launch behaviour_trees behaviour_trees.launch.py \
        drone_id:=$drone_namespace \
        tree:=$tree \
        groot_logger:=false"
fi

echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"

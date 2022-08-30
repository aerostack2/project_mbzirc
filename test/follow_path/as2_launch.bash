#!/bin/bash

# Arguments
drone_namespace=$1
drone_namespace=${drone_namespace:='drone_1'}
init_x=$2
init_x=${init_x:=0.0}
init_y=$3
init_y=${init_y:=0.0}
init_z=$4
init_z=${init_z:=0.0}

source ../../launch/launch_tools.bash

new_session $drone_namespace  

new_window 'ignition_interface' "ros2 launch ignition_platform ignition_platform_launch.py \
    use_sim_time:=true \
    drone_id:=$drone_namespace"

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    ground_truth:=true \
    odom_only:=false \
    base_frame:='\"\"'"

# new_window 'visual_inertial_odometry' "ros2 launch vinodom vinodom_launch.py \
#     namespace:=$drone_namespace \
#     use_sim_time:=true \
#     base_frame:=$drone_namespace \
#     show_matching:=false \
#     init_x:=$init_x \
#     init_y:=$init_y \
#     init_z:=$init_z"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    config:=../../robot_config/controller_manager.yaml"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    use_sim_time:=false \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace  \
    use_sim_time:=true \
    config_takeoff:=../../robot_config/takeoff.yaml"

new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc_bt.launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    tree:=./follow_path_test_real.xml \
    groot_logger:=true "

echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        send_ctrl_c_tmux_session "$drone_namespace"
}

# sleep 10000
tmux a

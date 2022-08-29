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

use_sim_time=false

source ../../launch/launch_tools.bash

declare -r COMPRESSED_IMAGE_TOPIC='stream/compressed_image'
declare -r REPORT_TOPIC='report'

new_session $drone_namespace  
new_window 'ignition_interface' "ros2 launch ignition_platform ignition_platform_launch.py \
    use_sim_time:=$use_sim_time \
    drone_id:=$drone_namespace"

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=$use_sim_time \
    ground_truth:=true \
    odom_only:=false \
    base_frame:='\"\"'"

# new_window 'visual_inertial_odometry' "ros2 launch vinodom vinodom_launch.py \
#     namespace:=$drone_namespace \
#     use_sim_time:=$use_sim_time \
#     base_frame:=$drone_namespace \
#     show_matching:=false \
#     init_x:=$init_x \
#     init_y:=$init_y \
#     init_z:=$init_z"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=$use_sim_time \
    config:=../../robot_config/controller_manager.yaml"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    use_sim_time:=$use_sim_time \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace  \
    use_sim_time:=$use_sim_time"

# new_window 'comms' "ros2 launch mbzirc_comms mbzirc_comms_launch.py \
#     robot_id:=$drone_namespace \
#     use_sim_time:=$use_sim_time \
#     n_drones:=10 \
#     pose_topic:=/self_localization/pose \
#     tree_topic:=/tree \
#     camera_topic:=/$COMPRESSED_IMAGE_TOPIC\
#     loc_hist_topic:=/loc_hist \
#     report_topic:=/$REPORT_TOPIC "

# new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc_bt.launch.py \
#     drone_id:=$drone_namespace \
#     use_sim_time:=$use_sim_time \
#     tree:=./takeoff_test.xml \
#     groot_logger:=false \
#     bt_loop_duration:=100"

echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"
tmux a

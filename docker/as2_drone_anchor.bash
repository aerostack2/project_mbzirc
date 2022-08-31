#!/bin/bash

if [ "$#" -le 0 ]; then
	echo "usage: $0 [drone_namespace] "
	exit 1
fi

# Arguments
drone_namespace=$1
init_x=$2
init_x=${init_x:=0.0}
init_y=$3
init_y=${init_y:=0.0}
init_z=$4
init_z=${init_z:=0.0}
uav_type=$5
uav_type=${uav_type:=0}

source ./launch/launch_tools.bash

# declare -r COMPRESSED_IMAGE_TOPIC='stream/compressed_image'
declare -r COMPRESSED_IMAGE_TOPIC='/image'
declare -r REPORT_TOPIC='report'

new_session $drone_namespace  
new_window 'ignition_interface' "ros2 launch ignition_platform ignition_platform_launch.py \
    use_sim_time:=true \
    drone_id:=$drone_namespace"

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    ground_truth:=false \
    odom_only:=true \
    base_frame:='\"\"'"

new_window 'visual_inertial_odometry' "ros2 launch vinodom vinodom_launch.py \
    namespace:=$drone_namespace \
    use_sim_time:=true \
    base_frame:=$drone_namespace \
    show_matching:=false \
    init_x:=$init_x \
    init_y:=$init_y \
    init_z:=$init_z" 

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    config:=robot_config/controller_manager.yaml"

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    use_sim_time:=true \
    drone_id:=$drone_namespace"

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace  \
    use_sim_time:=true \
    config_takeoff:=robot_config/takeoff.yaml"

new_window 'comms' "ros2 launch mbzirc_comms mbzirc_comms_launch.py \
    robot_id:=$drone_namespace \
    use_sim_time:=true \
    n_drones:=6 \
    pose_topic:=pose2 \
    tree_topic:=/tree \
    image_topic:=$COMPRESSED_IMAGE_TOPIC\
    image_destination:=drone_1 \
    loc_hist_topic:=/loc_hist \
    send_times:=3 \
    report_topic:=/$REPORT_TOPIC \
    event_topic:=/event \
    phase_topic:=/phase "

new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc_bt.launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    tree:=drone_roles/anchor_$drone_namespace.xml \
    groot_logger:=false"

# new_window 'localization' "ros2 launch mbzirc_loc mbzirc_loc_launch.py \
#     robot_id:=$drone_namespace \
#     odom_topic:=sensor_measurements/odom \
#     range_topic:=slot1/rfsensor \
#     pose_topic:=global_localization/pose \
#     globloc_topic:=/loc_hist \
#     pose_type:=$uav_type \
#     global_frame:=earth_rectified \
#     use_sim_time:=true"


echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"


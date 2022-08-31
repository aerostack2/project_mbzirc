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

source launch/launch_tools.bash

new_session $drone_namespace

new_window 'ignition_interface' "ros2 launch usv_ign_platform usv_ign_platform.py \
    use_sim_time:=true \
    drone_id:=$drone_namespace "

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    ground_truth:=false \
    odom_only:=true \
    base_frame:='\"\"' "

new_window '2d_odom' "ros2 launch usv_2d_odom usv_2d_odom_launch.py \
    use_sim_time:=true \
    namespace:=$drone_namespace \
    odom_topic:=sensor_measurements/odom \
    init_x:=$init_x \
    init_y:=$init_y \
    init_z:=$init_z"

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    use_sim_time:=true \
    drone_id:=$drone_namespace "

new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    use_sim_time:=true \
    drone_id:=$drone_namespace "

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    use_sim_time:=true \
    drone_id:=$drone_namespace \
    config_takeoff:=usv/takeoff.yaml \
    config_goto:=usv/goto.yaml"

new_window 'mission_planner' "ros2 launch mbzirc_bt mbzirc_bt.launch.py \
    use_sim_time:=true \
    drone_id:=$drone_namespace \
    tree:=drone_roles/usv_dummy.xml \
    groot_logger:=false\
    groot_client_port:=1668 \
    groot_server_port:=1669"

new_window 'usv_radar' " ros2 launch usv_radar radar_vessel_detection_launch.py \
    namespace:=$drone_namespace \
    use_sim_time:=true \
    radar_topic:=slot0/radar/scan \
    service_name:=detect_radar \
    dbscan_minnumberpoints:=2 \
    dbscan_epsilon:=900.0 \
    min_radar_amplitude:=-10.0 \
    min_radar_range:=10.0 \
    loc_topic:=ground_truth/pose \
    loc_frame:=usv/map \
    base_frame:=usv/base_link \
    top_limit_x:=-1300.0 \
    marker_topic:=radar_marker \
    objects_marker_topic:=radar_objects_array \
    mahalanobis_threshold:=10.0 \
    radar_error:=30.0 \
    object_timeout:=60.0"

new_window 'comms' "ros2 launch mbzirc_comms mbzirc_comms_launch.py \
    robot_id:=$drone_namespace \
    use_sim_time:=true \
    n_drones:=12 \
    pose_topic:=pose \
    tree_topic:=/tree \
    image_topic:=$COMPRESSED_IMAGE_TOPIC\
    image_destination:=drone_4 \
    loc_hist_topic:=/loc_hist \
    send_times:=3 \
    report_topic:=/$REPORT_TOPIC "



echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"



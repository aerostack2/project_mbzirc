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
    init_z:=$init_z \
    pure_inertial:=true"

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
    config_takeoff:=robot_config/takeoff_speed.yaml"

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
    tree:=drone_roles/inspection_$drone_namespace.xml"

new_window 'area2path' "ros2 launch area2path area_to_path_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    fov_h:=1.0472 \
    altitude:=20.0 \
    pitch:=0.43"

new_window 'stream_compressor' "ros2 launch mbzirc_sim_interface stream_compressor_launch.py \
    namespace:=$drone_namespace \
    use_sim_time:=true \
    rgb_image_topic:=slot0/image_raw \
    detection_topic:=detector_node/detections \
    compressed_image_topic:=$COMPRESSED_IMAGE_TOPIC \
    resize_image:=true \
    resize_image_factor:=0.1 \
    pub_rate:=0.5 \
    report_topic:=/drone_1/$REPORT_TOPIC \
    vessel_detection_topic:=detector_node/vessel_detections \
    object_detection_topic:=detector_node/object_detections \
    target_vessel:=vessel_E"

# new_window 'localization' "ros2 launch mbzirc_loc mbzirc_loc_launch.py \
#     robot_id:=$drone_namespace \
#     odom_topic:=sensor_measurements/odom \
#     range_topic:=slot1/rfsensor \
#     pose_topic:=global_localization/pose \
#     globloc_topic:=/loc_hist \
#     pose_type:=$uav_type \
#     global_frame:=earth_rectified \
#     use_sim_time:=true"

new_window 'yolo_detector_vessel' " ros2 launch yolo_object_detector yolo_object_detector_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    config:=./yolo_config/vessel_detector.yaml \
    camera_topic:=slot0/image_raw \
    detections_topic:=detector_node/vessel_detections"

new_window 'naive_position_estimator' "ros2 launch naive_position_estimator naive_position_estimator_launch.py \
    namespace:=$drone_namespace \
    base_frame:=$drone_namespace \
    show_detections:=false \
    computed_pose_topic:=vessel_target/computed \
    camera_topic:=slot0 \
    z_offset:=-0.0 \
    pointcloud_topic:=slot3/points \
    target_class:=vessel_E \
    detection_topic:=detector_node/vessel_detections \
    use_sim_time:=true"

new_window 'yolo_detector_object' " ros2 launch yolo_object_detector yolo_object_detector_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    config:=./yolo_config/object_detector.yaml \
    camera_topic:=slot6/image_raw \
    detections_topic:=detector_node/object_detections"

new_window 'depthtection' " ros2 launch depthtection depthtection_launch.py \
    namespace:=$drone_namespace \
    camera_topic:=slot6 \
    base_frame:=$drone_namespace \
    show_detection:=false \
    target_object:=small_blue_box \
    computed_pose_topic:=object_pose \
    detection_topic:=detector_node/object_detections \
    use_sim_time:=true"

new_window 'follow_target' "ros2 launch follow_target follow_target_launch.py \
    drone_id:=$drone_namespace \
    target_topic:=target_pose \
    use_sim_time:=true"

echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"

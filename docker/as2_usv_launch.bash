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
    use_sim_time:=true \
    drone_id:=$drone_namespace "

new_window 'state_estimator' "ros2 launch basic_state_estimator basic_state_estimator_launch.py \
    drone_id:=$drone_namespace \
    use_sim_time:=true \
    ground_truth:=true \
    base_frame:='\"\"' "

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
    tree:=usv/usv.xml \
    groot_logger:=false\
    groot_client_port:=1668 \
    groot_server_port:=1669"


echo -e "Launched drone $drone_namespace. For attaching to the session, run: \n  \t $ tmux a -t $drone_namespace"

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        send_ctrl_c_tmux_session "$drone_namespace"
}

sleep 10000



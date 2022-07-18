#!/bin/bash

N=$1
# if it's not a number N=0
if [ -z "$N" ]
then
  N=0
fi

drone_namespace="usv"

session=${USER}_USV_${N}

sensor=$(ign topic -l | grep ${drone_namespace}/model | sed 's/\// /g' | awk '{print $2, $4, $6, $8, $10}' | sort -u | sed 's/ /,/g')
sensor=$(echo $sensor | sed 's/ /:/g')
if [ ! -z $sensor ]; then
    sensors="sensors:=$sensor"
fi

# Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
tmux -2 new-session -d -s $session

# Create roscore 
# send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)
tmux new-window -t $session:0 -n 'ignition_interface'
tmux send-keys -t $session:0 "ros2 launch usv_ign_platform usv_ign_platform.py \
    drone_id:=$drone_namespace \
    $sensors " C-m

tmux new-window -t $session:1 -n 'controller_manager'
tmux send-keys -t $session:1 "ros2 launch controller_manager controller_manager_launch.py \
    drone_id:=$drone_namespace " C-m

tmux new-window -t $session:2 -n 'traj_generator'
tmux send-keys -t $session:2 "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace " C-m

tmux new-window -t $session:3 -n 'basic_behaviours'
tmux send-keys -t $session:3 "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace " C-m

tmux new-window -t $session:4 -n 'static_transform_publisher'
tmux send-keys -t $session:4 "ros2 launch basic_tf_tree_generator basic_tf_tree_generator_launch.py \
    drone_id:=$drone_namespace" C-m

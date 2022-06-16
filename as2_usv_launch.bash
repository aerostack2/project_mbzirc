#!/bin/bash

N=$1

drone_namespace=$2

session=${USER}_$N

WINDOW_ID=0
function new_window() {
  if [ $WINDOW_ID -eq 0 ]; then
    # Kill any previous session (-t -> target session, -a -> all other sessions )
    tmux kill-session -t $session
    # Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
    tmux -2 new-session -d -s $session

    # send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)
    tmux rename-window -t $session:0 "$1"
    tmux send-keys -t $session:0 "$2" C-m

  else
    tmux new-window -t $session:$WINDOW_ID -n "$1"
    tmux send-keys -t $session:$WINDOW_ID "$2" C-m
  fi
  WINDOW_ID=$((WINDOW_ID+1))
}

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

tmux new-window -t $SESSION:4 -n 'static_transform_publisher'
tmux send-keys -t $SESSION:4 "ros2 launch basic_tf_tree_generator basic_tf_tree_generator_launch.py \
    drone_id:=$drone_namespace" C-m
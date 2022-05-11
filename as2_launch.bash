#!/bin/bash

N=$1

drone_namespace=${AEROSTACK2_SIMULATION_DRONE_ID::-1}$N

session=${USER}_$N

# Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
tmux -2 new-session -d -s $session

# Create roscore 
# send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)

tmux new-window -t $session:1 -n 'basic_behaviours'
tmux send-keys "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace " C-m

tmux new-window -t $SESSION:2 -n 'gps_translator'
tmux send-keys "ros2 launch gps_utils gps_translator_launch.py" C-m

# tmux new-window -t $session:3 -n 'ignition interface'
# tmux send-keys "ros2 launch ignition_platform ignition_platform_launch.py \
#     drone_id:=$drone_namespace " C-m

# tmux new-window -t $session:4 -n 'controller_manager'
# tmux send-keys "ros2 launch controller_manager controller_manager_launch.py \
#     drone_id:=$drone_namespace " C-m


# tmux attach-session -t $session:2 C-m

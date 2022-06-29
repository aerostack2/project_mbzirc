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

new_window 'YOLO' "ros2 launch yolo_object_detector yolo_object_detector_launch.py config:=./darknet_params.yaml \
    drone_id:=$drone_namespace"
    
new_window 'visualizer' "ros2 run detection_visualizer detection_visualizer --ros-args --remap __ns:=/$drone_namespace --remap detection_visualizer/detections:=detector_node/detections  --remap detection_visualizer/images:=sensor_measurements/front_camera "

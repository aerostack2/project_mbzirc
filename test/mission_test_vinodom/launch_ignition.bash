#!/bin/bash

world="$1"
world=${world:="coast"}

config_path="$2"
config_path=${config_path:="./one_drone.yaml"}

ros2 launch mbzirc_ign competition.launch.py world:=${world} config_file:=${config_path}

# config_path="$1"
# config_path=${config_path:="./one_drone.yaml"}

# export RUN_ON_START=1

# SCRIPT_PATH="${AEROSTACK2_PATH}/simulation/ignition_assets/scripts"
# $SCRIPT_PATH/run_ign.sh ${config_path}

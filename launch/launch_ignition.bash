#!/bin/bash

world="$1"
world=${world:=default}

config_path="$2"
config_path=${config_path:="config/one_drone.yaml"}

ros2 launch mbzirc_ign competition.launch.py world:=${world} config_file:=${config_path}

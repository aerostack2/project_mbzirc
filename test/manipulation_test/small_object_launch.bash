#!/bin/bash

config_path="$1"
config_path=${config_path:="quadrotor.yaml"}

DIR_SCRIPT="${0%/*}"
${DIR_SCRIPT}/../../launch/launch_ignition.bash test/simple_demo_manip ${config_path}
#!/bin/bash

config_path="$1"
config_path=${config_path:="config/demo_mbzirc.json"}

DIR_SCRIPT="${0%/*}"

AS2_WORLDS="${DIR_SCRIPT}/assets/ignition/worlds"

export IGN_GAZEBO_RESOURCE_PATH=$IGN_GAZEBO_RESOURCE_PATH:$AS2_WORLDS

export RUN_ON_START=0

SCRIPT_PATH="${AEROSTACK2_PATH}/simulation/ignition_assets/scripts"
$SCRIPT_PATH/run_ign.sh ${config_path}

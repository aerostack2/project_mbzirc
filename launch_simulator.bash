#!/bin/bash

AEROSTACK_PROJECT=$(pwd)
SCRIPT_PATH="${AEROSTACK2_STACK}/simulation/ignition_assets/scripts"
ASSETS_FOLDER="${AEROSTACK2_STACK}/simulation/ignition_assets/models/"

export IGN_GAZEBO_RESOURCE_PATH=$GAZEBO_RESOURCE_PATH:$ASSETS_FOLDER

$SCRIPT_PATH/run_ign.sh "config.json"

#!/bin/bash

config_path="$1"
config_path=${config_path:="config.json"}

export RUN_ON_START=1

SCRIPT_PATH="${AEROSTACK2_STACK}/simulation/ignition_assets/scripts"
$SCRIPT_PATH/run_ign.sh ${config_path}

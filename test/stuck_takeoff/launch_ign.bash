#!/bin/bash

config_path="$1"
config_path=${config_path:="../../config/simple_demo.yaml"}

DIR_SCRIPT="${0%/*}"
${DIR_SCRIPT}/../../launch/launch_ignition.bash simple_demo ${config_path}

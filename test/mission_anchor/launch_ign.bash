#!/bin/bash

config_path="$1"
config_path=${config_path:="config_team_anchor.yaml"}

DIR_SCRIPT="${0%/*}"
${DIR_SCRIPT}/../../launch/launch_ignition.bash coast ${config_path}

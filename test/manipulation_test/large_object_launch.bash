#!/bin/bash

config_path="$1"
config_path=${config_path:="hexrotor.yaml"}

# test/multi_drone_drag  test/simple_arm_demo    test/suction_gripper
# test/multi_drone_lift  test/simple_demo_manip  test/usv_max_speed


DIR_SCRIPT="${0%/*}"
${DIR_SCRIPT}/../../launch/launch_ignition.bash test/multi_drone_drag ${config_path}
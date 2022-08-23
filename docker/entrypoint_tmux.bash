#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage: $0 [vehicle_name] "
	exit 1
fi


source launch/launch_tools.bash

vehicle_name="$1"

trap ctrl_c INT SIGINT TERM SIGTERM 

function ctrl_c() {
  echo "** Trapped CTRL-C"
  send_ctrl_c_tmux_session $vehicle_name
  exit 0
}


if [[ $vehicle_name == "usv" ]]; then
    ./docker/as2_usv_launch.bash $vehicle_name
elif [[ $vehicle_name =~ ^drone_[0-4]+$ ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name
# elif [[ $vehicle_name == "drone_2" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 2"
# elif [[ $vehicle_name == "drone_3" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 3"
# elif [[ $vehicle_name == "drone_4" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 4"
elif [[ $vehicle_name == "drone_5" ]]; then
    ./docker/as2_drone_inspection.bash $vehicle_name
elif [[ $vehicle_name == "drone_6" ]]; then
    ./docker/as2_drone_inspection.bash $vehicle_name
# elif [[ $vehicle_name == "drone_7" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 7"
# elif [[ $vehicle_name == "drone_8" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 8"
else
    echo "Vehicle not recognised."
fi

echo "Waiting"
for i in {1..10000}; do
  sleep 1
done

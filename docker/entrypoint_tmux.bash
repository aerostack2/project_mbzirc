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
    ./docker/as2_usv_launch.bash $vehicle_name -1462.0 -16.5 0.3 2
elif [[ $vehicle_name == "drone_1" ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name -1495.0 20.0 4.18 0
elif [[ $vehicle_name == "drone_2" ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name -1495.0 0.0 4.18 0
elif [[ $vehicle_name == "drone_3" ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name -1495.0 -20.0 4.18 0
elif [[ $vehicle_name == "drone_4" ]]; then
    ./docker/as2_drone_master_anchor.bash $vehicle_name -1488.0 0.0 4.18 1
elif [[ $vehicle_name == "drone_5" ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name -1480.0 20.0 4.18 1
elif [[ $vehicle_name == "drone_6" ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name -1480.0 7.0 4.18 1
elif [[ $vehicle_name == "drone_7" ]]; then
    ./docker/as2_drone_anchor.bash $vehicle_name -1480.0 -5.0 4.18 1
elif [[ $vehicle_name == "drone_8" ]]; then
    ./docker/as2_drone_inspection.bash $vehicle_name -1460.2 -17.3 1.1 2
elif [[ $vehicle_name == "drone_9" ]]; then
    ./docker/as2_drone_inspection.bash $vehicle_name -1460.2 -15.7 1.1 2
elif [[ $vehicle_name == "drone_10" ]]; then
    ./docker/as2_drone_inspection.bash $vehicle_name -1463.8 -17.3 1.1 2
elif [[ $vehicle_name == "drone_11" ]]; then
    ./docker/as2_drone_inspection.bash $vehicle_name -1463.8 -15.7 1.1 2
else
    echo "Vehicle not recognised."
fi

echo "Waiting"
for i in {1..10000}; do
  sleep 1
done

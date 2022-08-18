#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage: $0 [vehicle_name] "
	exit 1
fi

vehicle_name="$1"

DIR_SCRIPT="${0%/*}"

if [[ $vehicle_name == "usv" ]]; then
    ${DIR_SCRIPT}/as2_usv_launch.bash $vehicle_name
elif [[ $vehicle_name =~ ^drone_[0-9]+$ ]]; then
    ${DIR_SCRIPT}/as2_drone_anchor.bash $vehicle_name
# elif [[ $vehicle_name == "drone_2" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 2"
# elif [[ $vehicle_name == "drone_3" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 3"
# elif [[ $vehicle_name == "drone_4" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 4"
# elif [[ $vehicle_name == "drone_5" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 5"
# elif [[ $vehicle_name == "drone_6" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 6"
# elif [[ $vehicle_name == "drone_7" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 7"
# elif [[ $vehicle_name == "drone_8" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 8"
else
    echo "Vehicle not recognised."
fi

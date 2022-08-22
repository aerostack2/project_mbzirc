#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage: $0 [vehicle_name] "
	exit 1
fi

vehicle_name="$1"

if [[ $vehicle_name == "usv" ]]; then
    # ./docker/as2_usv_launch.bash $vehicle_name
    ros2 launch docker/usv.launch.py drone_id:=usv tree:=usv/usv.xml init_x:=-1462.0 init_y:=-16.5 init_z:=0.3
# elif [[ $vehicle_name =~ ^drone_[0-4]+$ ]]; then
    # ./docker/as2_drone_anchor.bash $vehicle_name
elif [[ $vehicle_name == "drone_1" ]]; then
    ros2 launch docker/anchor_sender.launch.py drone_id:=drone_1 tree:=drone_roles/anchor_drone_1.xml init_x:=-1476.0 init_y:=21.0 init_z:=4.18 
elif [[ $vehicle_name == "drone_2" ]]; then
    ros2 launch docker/anchor.launch.py drone_id:=drone_2 tree:=drone_roles/anchor_drone_2.xml init_x:=-1518.0 init_y:=-4.0 init_z:=4.18 
elif [[ $vehicle_name == "drone_3" ]]; then
    ros2 launch docker/anchor.launch.py drone_id:=drone_3 tree:=drone_roles/anchor_drone_3.xml init_x:=-1500.0 init_y:=-16.5 init_z:=4.18 
elif [[ $vehicle_name == "drone_4" ]]; then
    ros2 launch docker/anchor.launch.py drone_id:=drone_4 tree:=drone_roles/anchor_drone_4.xml init_x:=-1500.0 init_y:=-5.0 init_z:=4.18 
elif [[ $vehicle_name == "drone_5" ]]; then
    # ./docker/as2_drone_inspection.bash $vehicle_name
    ros2 launch docker/inspection.launch.py drone_id:=drone_5 tree:=drone_roles/anchor_drone_5.xml init_x:=-1462.0 init_y:=-17.7 init_z:=1.1
elif [[ $vehicle_name == "drone_6" ]]; then
    # ./docker/as2_drone_inspection.bash $vehicle_name
    ros2 launch docker/inspection.launch.py drone_id:=drone_6 tree:=drone_roles/anchor_drone_6.xml init_x:=-1462.0 init_y:=-15.3 init_z:=1.1
# elif [[ $vehicle_name == "drone_7" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 7"
# elif [[ $vehicle_name == "drone_8" ]]; then
#     ${DIR_SCRIPT}/test.bash "Anchor 8"
else
    echo "Vehicle not recognised."
fi

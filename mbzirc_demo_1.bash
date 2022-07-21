#!/bin/bash

DIR_SCRIPT="${0%/*}"

drone_namespace=${AEROSTACK2_SIMULATION_DRONE_ID::-1}

${DIR_SCRIPT}/launch/as2_usv_launch.bash usv usv/tree.xml

${DIR_SCRIPT}/launch/as2_launch.bash beacon_0 drone_roles/beacon.xml
${DIR_SCRIPT}/launch/as2_launch.bash beacon_1 drone_roles/beacon.xml
${DIR_SCRIPT}/launch/as2_launch.bash hunter_0 drone_roles/beacon.xml
${DIR_SCRIPT}/launch/as2_launch.bash hunter_1 drone_roles/beacon.xml

session=beacon_0

# if inside a tmux session detach before attaching to the session
if [ -n "$TMUX" ]; then
    tmux switch-client -t $session
else
    tmux attach -t $session:0
fi

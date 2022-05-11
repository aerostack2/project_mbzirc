#!/bin/bash

num_drones=$1
num_drones=${num_drones:=1}

DIR_SCRIPT="${0%/*}"

n=0
while [ $n -lt $num_drones ]; do
    ${DIR_SCRIPT}/as2_launch.bash $n
    n=$(($n + 1))
done

session=${USER}_$(($n - 1))
tmux a -t :1  # Attach session 0 window 1
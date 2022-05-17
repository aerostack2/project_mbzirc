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

# if inside a tmux session detach before attaching to the session
if [ -n "$TMUX" ]; then
    tmux switch-client -t $session
else
    tmux attach -t $session:0
fi
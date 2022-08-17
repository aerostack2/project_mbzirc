#!/bin/bash

DIR_SCRIPT="${0%/*}"

${DIR_SCRIPT}/as2_launch.bash quadrotor_1
# ${DIR_SCRIPT}/as2_launch.bash quadrotor_2

session=quadrotor_1

# if inside a tmux session detach before attaching to the session
if [ -n "$TMUX" ]; then
    tmux switch-client -t $session
else
    tmux attach -t $session:0
fi
#!/bin/bash
SESSION=${AEROSTACK2_SIMULATION_DRONE_ID::-1}

sessions=$(tmux ls | awk '{print $1}' | sed "s/://g" | grep $SESSION)

for sess in $sessions
do
    tmux kill-session -t $sess
done

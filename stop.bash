#!/bin/bash
tmux dettach
tmux kill-session -t beacon_0
tmux kill-session -t beacon_1
tmux kill-session -t hunter_0
tmux kill-session -t hunter_1
tmux kill-session -t usv
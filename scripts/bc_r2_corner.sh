#!/bin/bash

# gen_weight = 0.01 and action_loss * 100 with learning rate 1e-5
# 7/10 worked! alignment is good 7/10

# start new tmux sesson
SESS_NAME="bc_r2_corner"
DOC="empty"
VENV_DIR="../.virtualenv/cdil/bin/activate"
#VENV_DIR="~/Desktop/Research/2.DAIL/cdil/venv/bin/activate"
tmux kill-session -t $SESS_NAME
tmux new-session -d -s $SESS_NAME

BEGIN=0
END=4
TOTAL_GPU=2

for ((i=BEGIN; i<=END; i++)); do
gpu_num=$((i % TOTAL_GPU))

PYTHON_CMD="conda activate dail && python train.py --algo ddpg --agent_type bc --save_expert_dir ./target_expert/reacher2_corner/demo1000_seed_${i} --load_dataset_dir ./target_demo/reacher2_corner --edomain reacher2_corner --ldomain reacher2_act_corner --seed 100${i} --doc r2_corner_bc_${i} --n_demo 1000 --gpu ${gpu_num}"

if [ $i -ne $BEGIN ]
then
    tmux selectp -t $SESS_NAME:0
    tmux split-window -h
    tmux send-keys -t $SESS_NAME:0 "$PYTHON_CMD" "C-m"
else
    tmux selectp -t $SESS_NAME:0
    tmux send-keys -t $SESS_NAME:0 "$PYTHON_CMD" "C-m"
fi

sleep 0.1
tmux select-layout tiled
done
tmux a -t $SESS_NAME


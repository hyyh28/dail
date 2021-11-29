#!/bin/bash

# gen_weight = 0.01 and action_loss * 100 with learning rate 1e-5
# 7/10 worked!

# start new tmux sesson
SESS_NAME="align_dynamics"
DOC="empty"
VENV_DIR="activate dail"
tmux kill-session -t $SESS_NAME
tmux new-session -d -s $SESS_NAME

BEGIN=0
END=3
TOTAL_GPU=1

for ((i=BEGIN; i<=END; i++)); do
gpu_num=$((i % TOTAL_GPU))

PYTHON_CMD="conda activate dail && python train.py --algo ddpg --agent_type gama --load_dataset_dir ./alignment_taskset/dynamics.pickle --load_expert_dir ./alignment_expert/reacher2_wall/12goals --save_learner_dir ./saved_alignments/dynamics/12goals/seed_${i} --logdir ./logs/dynamics/12goals/seed_${i} --edomain reacher2_wall --ldomain reacher2_act_wall --seed ${i} --gpu ${gpu_num}"
echo $i
if [ $i -ne $BEGIN ]
then
    tmux selectp -t $SESS_NAME:0
    tmux split-window -h
    tmux send-keys -t $SESS_NAME:0 "$PYTHON_CMD" "C-m"
else
    tmux selectp -t $SESS_NAME:0
    tmux send-keys -t $SESS_NAME:0 "$PYTHON_CMD" "C-m"
fi

sleep 15

tmux select-layout tiled
done
tmux a -t $SESS_NAME


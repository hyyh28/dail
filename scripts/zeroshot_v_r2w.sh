#!/bin/bash


# 7/10 worked! (>100 is good) alignment is good 8/10

# start new tmux sesson
SESS_NAME="eval_v_r2w"
DOC="empty"
#VENV_DIR="../.virtualenv/cdil/bin/activate"
VENV_DIR="~/Desktop/Research/2.DAIL/cdil/venv/bin/activate"
tmux kill-session -t $SESS_NAME
tmux new-session -d -s $SESS_NAME

BEGIN=0
END=9
TOTAL_GPU=4

for ((i=BEGIN; i<=END; i++)); do
gpu_num=$((i % TOTAL_GPU))

PYTHON_CMD="source ${VENV_DIR} && python train.py --algo ddpg --agent_type zeroshot --load_expert_dir ./target_expert/tp_write_reacher2/alldemo --load_learner_dir ./saved_alignments/viewpoint/allgoals/seed_${i} --edomain tp_write_reacher2 --ldomain write_reacher2 --seed 100${i} --doc v_r2w"

if [ $i -ne $BEGIN ]
then
    tmux selectp -t $SESS_NAME:0
    tmux split-window -h
    tmux send-keys -t $SESS_NAME:0 "$PYTHON_CMD" "C-m"
else
    tmux selectp -t $SESS_NAME:0
    tmux send-keys -t $SESS_NAME:0 "$PYTHON_CMD" "C-m"
fi

sleep 0.5

tmux select-layout tiled
done
tmux a -t $SESS_NAME


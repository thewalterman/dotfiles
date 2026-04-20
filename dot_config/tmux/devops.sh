#!/usr/bin/env bash

set -euo pipefail

SESSION="${1:-devops}"
CWD="${2:-$PWD}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach -t "$SESSION"
fi

# dev window
tmux new-session  -d -s "$SESSION" -c "$CWD" -n dev nvim
tmux set-option   -p -t "$SESSION:dev.1" remain-on-exit on
tmux split-window -h -l 30% -c "$CWD" -t "$SESSION:dev" claude
tmux set-option   -p -t "$SESSION:dev.2" remain-on-exit on
tmux select-pane  -t "$SESSION:dev.1"

# ops window
tmux new-window   -t "$SESSION" -c "$CWD" -n ops k9s
tmux set-option   -p -t "$SESSION:ops.1" remain-on-exit on
tmux split-window -v -l 30% -c "$CWD" -t "$SESSION:ops"
tmux set-option   -p -t "$SESSION:ops.2" remain-on-exit on
tmux select-pane  -t "$SESSION:ops.1"

tmux select-window -t "$SESSION:ops"

exec tmux attach -t "$SESSION"

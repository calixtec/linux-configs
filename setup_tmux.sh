#!/bin/bash

#run bash setup_tmux.sh

# Define paths
TMUX_CONF="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

# 1. Install tmux if not already installed
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    sudo apt update && sudo apt install -y tmux
else
    echo "tmux already installed ✅"
fi

# 2. Create tmux config directory and clone TPM
echo "Setting up TPM plugin manager..."
mkdir -p "$TPM_DIR"
if [ ! -d "$TPM_DIR/.git" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM already exists ✅"
fi

# 3. Create ~/.tmux.conf with your desired config
echo "Writing .tmux.conf..."
cat > "$TMUX_CONF" <<EOF
unbind r
bind r source-file ~/.tmux.conf

set -g prefix C-s

setw -g mode-keys vi
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'dracula/tmux'

set -g @dracula-show-powerline true
set -g @dracula-plugins "weather"
set -g @dracula-show-left-icon session
set -g status-position top

run '~/.tmux/plugins/tpm/tpm'
EOF

echo "✔️  .tmux.conf created at $TMUX_CONF"

# 4. Launch tmux and install plugins
echo "Launching tmux in detached mode to install plugins..."
tmux new-session -d -s plugin-setup "sleep 1 && tmux source-file ~/.tmux.conf && ~/.tmux/plugins/tpm/bin/install_plugins && echo 'Plugins installed.' && sleep 2 && exit"

# Optional: List tmux sessions to confirm it ran
tmux ls

echo "🎉 tmux is set up! You can now start it with: tmux attach -t plugin-setup or create your own session."

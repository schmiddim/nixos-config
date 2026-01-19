#!/usr/bin/env sh
# Opens 2 Alacritty terminals side-by-side in ~/code/teapot-operator
# Left terminal: k9s
# Right terminal: shell prompt
# IntelliJ in background
# Everything starts on the currently focused screen

# Get the currently focused window/container to ensure we stay on the same output
FOCUSED_WINDOW=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .id' | head -1)

# Create a new container with horizontal split on the current focus
swaymsg "focus con_id $FOCUSED_WINDOW; splith"

# Open first terminal with k9s (left side)
swaymsg exec "alacritty --working-directory=$HOME/code/teapot-operator -e sh -c 'k9s'"
sleep 0.3

# Move to the right pane
swaymsg 'focus right'
sleep 0.1

# Open second terminal (right side) - normal shell in teapot-operator
swaymsg exec "alacritty --working-directory=$HOME/code/teapot-operator"
sleep 0.3

# Start IntelliJ with --no-single-instance to allow multiple instances
swaymsg exec 'idea --no-single-instance'
sleep 0.5

# Move focus to the IntelliJ window
swaymsg 'focus right'

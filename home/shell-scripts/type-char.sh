#!/usr/bin/env bash
# Type a character via clipboard, preserving clipboard history
# Usage: type-char.sh <character>

char="$1"
[[ -z "$char" ]] && exit 1

# Save current clipboard (text only, ignore errors for images)
old_clip=$(wl-paste 2>/dev/null || true)

# Copy character to clipboard
printf '%s' "$char" | wl-copy

# Paste with Ctrl+V
wtype -M ctrl v -m ctrl

# Small delay to ensure paste completes
sleep 0.05

# Restore old clipboard content
if [[ -n "$old_clip" ]]; then
    printf '%s' "$old_clip" | wl-copy
else
    # Clear clipboard if it was empty
    wl-copy --clear 2>/dev/null || true
fi

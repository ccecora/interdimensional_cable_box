#!/usr/bin/env bash
# Stage 1: minimal channel loop — no IPC, no state, no overlay
CHANNEL_DIR="${1:-$HOME/videos/channels/01_lofi}"

exec mpv \
  --panscan=1 \
  --video-rotate=270 \
  --really-quiet \
  --no-terminal \
  --fs \
  --loop-playlist \
  "$CHANNEL_DIR"

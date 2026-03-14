#!/bin/bash

# Persist .claude.json in the volume so login state survives container restarts
mkdir -p ~/.claude
[ ! -s ~/.claude/.claude.json ] && echo '{}' > ~/.claude/.claude.json
ln -sf ~/.claude/.claude.json ~/.claude.json

# Sync config from host ~/.claude into the volume
# Only copies known config items — leaves credentials and .claude.json untouched
HOST=/tmp/.claude-host
if [ -d "$HOST" ]; then
  for item in CLAUDE.md settings.json commands skills plugins; do
    [ -e "$HOST/$item" ] && cp -r "$HOST/$item" ~/.claude/
  done
fi

# Ensure dangerous-mode permission prompt is skipped (required for --dangerously-skip-permissions)
SETTINGS=~/.claude/settings.json
[ ! -f "$SETTINGS" ] && echo '{}' > "$SETTINGS"
node -e "
  const fs = require('fs');
  const s = JSON.parse(fs.readFileSync('$SETTINGS', 'utf8'));
  s.skipDangerousModePermissionPrompt = true;
  fs.writeFileSync('$SETTINGS', JSON.stringify(s, null, 2) + '\n');
"

# Bridge path-encoding mismatch: symlink the container's encoded path to the host's
if [ -n "$HOST_CWD" ]; then
  HOST_ENCODED="$(echo "$HOST_CWD" | sed 's|/|-|g')"
  CONTAINER_ENCODED="-home-claude-workspace"
  if [ "$HOST_ENCODED" != "$CONTAINER_ENCODED" ]; then
    mkdir -p "$HOME/.claude/projects/$HOST_ENCODED"
    ln -sfn "$HOME/.claude/projects/$HOST_ENCODED" "$HOME/.claude/projects/$CONTAINER_ENCODED"
  fi
fi

exec "$@"

#!/bin/bash
# Setup script for a Claude Code cloud environment.
# Cloud sessions don't install plugins from a repo's .claude/settings.json,
# so this installs the my-mods marketplace and its mods at user scope on the
# cloud VM. The environment cache keeps them for later sessions.
# Paste this file into the environment's "Setup script" box.

if ! command -v claude >/dev/null 2>&1; then
  echo "cloud-setup: claude CLI not found; skipping mods"
  exit 0
fi

claude plugin marketplace add aptaheri94-ai/CLAUDE-MODS- || true

for mod in savvy-progress skins filetree cache-tax blast-radius reflect-mod replay-theater; do
  claude plugin install "$mod@my-mods" --scope user || true
done

claude plugin enable cc-plugin-you-should-know@builtin || true

exit 0

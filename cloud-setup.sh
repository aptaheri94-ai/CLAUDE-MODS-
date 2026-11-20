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

# Skins keeps its made skins and chosen look in a per-mod store file named
# skins_my-mods-<first 12 hex of sha256("skins@my-mods")>.json. Seed it with
# the purple-night skin so cloud sessions start in it. An existing store file
# is left alone, so a look changed later in the cloud is not overwritten.
store_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/store"
store_file="$store_dir/skins_my-mods-eb9daee7b1d1.json"
if [ ! -e "$store_file" ]; then
  mkdir -p "$store_dir" && cat > "$store_file" <<'JSON' || true
{
  "custom": {
    "purple-night": {
      "name": "purple-night",
      "label": "purple-night",
      "base": "dracula",
      "palette": {
        "user": "#a978ff", "fg": "#e6e1f5", "muted": "#a49cbf",
        "surface": "#221b33", "zebra": "#1b1628",
        "read": "#8fb8ff", "write": "#e87ba4", "run": "#ffcb6b",
        "search": "#7fdbca", "web": "#6da7ec", "mcp": "#c3a6ff", "other": "#b8b0d0",
        "ok": "#7ee08a", "err": "#ff6b81", "warn": "#f0b45e"
      },
      "spinner": ["در حال فکر", "در حال کار", "در حال ساختن", "در حال بررسی", "در حال نوشتن"],
      "done": ["تمام شد", "انجام شد", "آماده شد"]
    }
  },
  "prefs": {
    "skin": "purple-night", "icons": "unicode", "prompt": "left", "words": "skin",
    "rail": true, "tables": "on", "shimmer": true, "band": true, "countdown": false,
    "clipOutput": false, "markdown": true, "quiet": false, "charts": true, "math": true,
    "commands": true, "shell": true, "highlight": true, "hints": true, "links": true,
    "copy": true, "fold": true, "expand": false, "compact": true, "calm": null
  }
}
JSON
fi

exit 0

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

# The marketplace repo must be public: a setup script has no GitHub token, so
# a private repo fails here (it did, silently, while every line ended in
# "|| true"). Failures are now printed; the script still exits 0 so a failed
# mod never stops the session from starting.
fail() { echo "cloud-setup: FAILED: $*" >&2; }

claude plugin marketplace add aptaheri94-ai/claude-mods- \
  || fail "marketplace add aptaheri94-ai/claude-mods- (is the repo public?)"

# reflect-mod is left out in the cloud: it writes to CLAUDE.md by itself, and
# hamyarbot's CLAUDE.md is capped and changed only with the owner's word.
for mod in savvy-progress skins filetree blast-radius replay-theater; do
  claude plugin install "$mod@my-mods" --scope user || fail "install $mod"
done

claude plugin enable cc-plugin-you-should-know@builtin || fail "enable you-should-know"

# Skins keeps its made skins and chosen look in a per-mod store file named
# skins_my-mods-<first 12 hex of sha256("skins@my-mods")>.json. Seed it with
# the purple-night skin (skins-seed.json in this repo, so the script itself
# stays left-to-right) so cloud sessions start in it. An existing store file
# is left alone, so a look changed later in the cloud is not overwritten.
cfg="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
seed="$cfg/plugins/marketplaces/my-mods/skins-seed.json"
store_file="$cfg/plugins/store/skins_my-mods-eb9daee7b1d1.json"
if [ ! -e "$store_file" ]; then
  mkdir -p "$cfg/plugins/store" && cp "$seed" "$store_file" || fail "skins seed"
fi

exit 0

# my-mods

A personal Claude Code marketplace. It holds no mod code: each entry points at the upstream repository, pinned to the commit that was reviewed, so nothing changes until the pin is bumped here.

| Mod | Upstream | Note |
| --- | --- | --- |
| savvy-progress | JohnnyVizz/claude-kit `plugins/savvy-progress` | Band is for `/savvy-flow`; the agents panel (`/agents-info`) works alone |
| skins | hellosverre/claude-skins | `/skin` switches themes |
| filetree | data-goblin/claude-code-filetree | Many options: `/plugin configure filetree@my-mods` |
| cache-tax | karanb192/cache-tax | `autoWarm` is on by default and spends tokens keeping the cache warm |
| blast-radius | anthropics/claude-code-playground `claude-code/mods/blast-radius` | |
| reflect-mod | BayramAnnakov/claude-reflect `mod` | One small model call per short prompt |
| replay-theater | anthropics/claude-code-playground `claude-code/mods/replay-theater` | |

You Should Know is built into Claude Code, so it is not listed here: `/plugin enable cc-plugin-you-should-know@builtin`.

## Install

Terminal, once per machine:

```
/plugin marketplace add aptaheri94-ai/claude-mods-
```

then, for each mod:

```
/plugin install <mod>@my-mods
```

Desktop app: click + next to the prompt box, then Plugins, Add marketplace with `aptaheri94-ai/claude-mods-`, then Add plugin.

## Cloud sessions (Claude Code on the web)

Cloud sessions don't install plugins from a repo's `.claude/settings.json`, and plugins installed on your own machine don't carry over. Instead, paste [`cloud-setup.sh`](cloud-setup.sh) into your cloud environment's **Setup script** box (claude.ai/code → environment settings). It runs before a session starts, installs every mod above plus You Should Know, and the environment cache keeps them for later sessions. The environment's network access must allow GitHub (the default **Limited** level does).

## Updating a mod

Review the upstream changes, then replace that entry's `sha` in `.claude-plugin/marketplace.json` and run `/plugin marketplace update my-mods`.

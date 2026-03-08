# AI agent context for this Neovim config

## What this config optimizes for

- fast startup
- readable Lua
- pragmatic defaults
- low maintenance overhead
- minimal surprise

## Non-goals

- turning the config into a framework
- maximizing abstraction
- supporting every OS and every shell
- adding plugins for minor convenience only

## Preferred maintenance style

- prefer incremental cleanup
- prefer removing dead config over adding wrappers
- prefer built-in Neovim APIs when good enough
- prefer explicit code over magic

## Typical task buckets

- plugin add/remove
- keymap cleanup
- LSP/cmp/treesitter maintenance
- filetype tweaks
- startup/performance cleanup
- UI consistency fixes

## Heuristics

- if a config is used only once, keep it local
- if logic repeats twice or more, consider extracting a helper
- if a setting only matters for one filetype, do not make it global
- if a plugin is mostly workaround code, reconsider the plugin

## Before adding a new plugin

Ask:
1. Can built-in Neovim do this already?
2. Is the plugin maintained?
3. Can it be lazy-loaded?
4. Is the feature worth long-term config cost?
5. Does it overlap with an existing plugin?

## Before restructuring files

Ask:
1. Does this reduce cognitive load?
2. Will future edits become easier?
3. Is this a real boundary, or just aesthetics?
4. Can this be done without breaking imports and require paths?

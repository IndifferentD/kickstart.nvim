# AGENTS.md

## Purpose

This repository contains a personal Neovim configuration in Lua.
The goal is to keep it fast, readable, easy to debug, and easy to extend.

## High-level architecture

- `init.lua` is the entry point and should stay minimal.
- `lua/config/*.lua` contains core editor setup:
  - options
  - keymaps
  - autocmds
  - plugin manager bootstrap
- `lua/plugins/*.lua` contains plugin specs and plugin configuration.
- `lua/lang/*.lua` contains language-specific behavior.
- `after/ftplugin/*.lua` contains filetype-local overrides.
- `lua/core/*.lua` contains small shared helpers only when reuse is real.

## Change philosophy

Prefer small, local, reversible changes.
Do not perform broad rewrites unless explicitly requested.
Preserve existing behavior unless the task requires changing it.

## Rules for editing

1. Keep `init.lua` thin.
2. Do not add new dependencies unless clearly justified.
3. Prefer extending existing modules over creating many tiny files.
4. Put plugin declarations in `lua/plugins/`.
5. Put general editor behavior in `lua/config/`, not in plugin files.
6. Put filetype-specific settings in `after/ftplugin/` or `lua/lang/`.
7. Avoid global state unless Neovim APIs require it.
8. Prefer descriptive module names over personal naming tricks.
9. Keep startup performance in mind; lazy-load when reasonable.
10. Do not silently change keymaps, colors, or UX defaults unless requested.

## Style conventions

- Language: Lua
- Indentation: 2 spaces
- Prefer local variables
- Prefer returning tables from modules
- Avoid deeply nested logic when a helper function would make code clearer
- Keep comments brief and useful
- Do not add decorative comments or banners

## Plugin conventions

- One plugin group per file when possible:
  - `lsp.lua`
  - `completion.lua`
  - `treesitter.lua`
  - `git.lua`
  - `ui.lua`
- Group related plugin specs together.
- For each plugin:
  - keep opts close to the spec
  - keep config concise
  - extract helpers only if reused
- Prefer stable, maintained plugins.
- If replacing a plugin, remove obsolete config in the same change.

## Keymaps

- New keymaps must include:
  - mode
  - lhs
  - rhs
  - short description when useful
- Avoid collisions with existing leader mappings.
- Do not replace core navigation habits without explicit instruction.

## Performance and reliability

- Prefer lazy-loading for non-essential plugins.
- Avoid running expensive setup on startup.
- Prefer built-in Neovim functionality when adequate.
- When debugging performance, look for the smallest fix first.

## Debugging workflow

When fixing an issue:
1. Identify the smallest relevant module.
2. Avoid unrelated cleanup in the same patch.
3. Explain probable root cause.
4. Make the minimal fix.
5. Mention follow-up cleanup separately, not mixed into the same edit.

## Safety constraints

- Do not delete large sections of config without explicit reason.
- Do not remove user-facing commands, mappings, or autocmds unless they are broken or obsolete.
- Do not expose secrets, tokens, or local machine paths in committed files.
- Do not hardcode machine-specific paths unless the task explicitly asks for it.

## Output expectations

When proposing changes:
- summarize what changed
- explain why
- note possible side effects
- list manual verification steps

## Verification checklist

After config changes, prefer checks such as:
- Neovim starts without errors
- `:checkhealth` is clean or improved
- affected keymaps still work
- affected filetypes load expected settings
- plugin loads only when expected

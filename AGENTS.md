# AGENTS.md

Purpose
This repository is a Neovim configuration written in Lua. Agents should follow existing Neovim config patterns, keep changes minimal, and avoid introducing new build systems or tooling unless explicitly requested.

Repository layout
- `init.lua` is the entry point and wires `core` and `plugins`.
- `lua/core/` contains base options and keymaps.
- `lua/plugins/` contains packer manifest and custom modules.
- `after/plugin/` contains per-plugin configuration.
- `README.md` documents setup and external dependencies.

Build, lint, and test commands
There is no build, lint, or test runner defined in this repo.
Use Neovim commands for verification:
- Plugin sync: `:PackerSync`
- Treesitter install: `:TSInstall <lang>`
- LSP manager: `:LSPInstallInfo`

Single-test guidance
No automated test framework is configured, so there is no single-test command.
If you add tests in the future, document the runner and a single-test invocation here.

Setup and runtime notes
- Install packer as described in `README.md`.
- External dependencies are documented in `README.md` (Python, Ruby, Node, ripgrep, fd).
- The Lua language server uses `.luarc.json`, which defines `vim` as a global.

Cursor/Copilot rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` found in this repo.

Skill notes (project-local)
- Installed skills live under `~/.config/nvim/.agents/skills/` for this project.
- `neovim` (julianobarbosa) assumes a lazy.nvim-based structure; use it for general guidance but adapt to this repo's packer layout and `lua/core` + `after/plugin` organization.
- `neovim-best-practices` (kriscard) is general Neovim guidance; apply only patterns that fit this repository's structure.

Code style guidelines (Lua)
General
- Follow existing file structure: module per file, with `require` in `init.lua` aggregators.
- Keep configs in `after/plugin/` and core options in `lua/core/`.
- Use ASCII in new files unless the file already uses Unicode symbols.
- Avoid creating new global functions; prefer `local` functions and return tables when appropriate.

Imports and module usage
- Use `require("module")` at top-level or just before use; keep related requires grouped.
- For optional plugins, wrap `require` in `pcall` and bail early on failure.
- Prefer `vim.keymap.set` over `vim.api.nvim_set_keymap` for mappings.

Formatting
- Match existing formatting in the file you edit; many files use two-space indents.
- Use single quotes for Lua strings unless you need interpolation or embedded quotes.
- Keep tables readable with one key per line when they grow beyond 3-4 entries.
- Avoid trailing whitespace.

Naming conventions
- Modules: `lua/<area>/<name>.lua` and `require("area.name")`.
- Functions: `camelCase` or `PascalCase` is already present; prefer `camelCase` for new locals.
- Keymaps: keep keymap descriptions near their mapping lines.

Neovim API usage
- Options: prefer `vim.opt` for user-facing options and `vim.o` for simple globals.
- Globals: `vim.g` for plugin variables and runtime toggles.
- Commands: use `vim.cmd` for ex-commands and `vim.cmd[[...]]` for multi-line blocks.

Error handling and safety
- Use `pcall` around plugin `require` if the plugin may not be installed.
- Guard OS-specific or optional features with checks (`vim.fn.has` or `vim.fn.executable`).
- Avoid heavy work in global scope when it can be deferred to setup functions.

Packer usage
- The plugin manifest lives in `lua/plugins/manifest.lua`.
- Add new plugins using `use { "author/repo" }` and keep related plugins grouped.
- If a plugin requires build steps, use `run = "..."` as already shown.

Configuration patterns
- Place plugin configs under `after/plugin/` using the plugin name.
- For custom behavior, add modules in `lua/plugins/<name>/` and require them in `lua/plugins/init.lua`.
- Keep keymaps and core options centralized in `lua/core/` when they are not plugin-specific.

Documentation expectations
- If you add new dependencies or setup steps, update `README.md`.
- If you add a new test runner or lint command, update this file with exact commands.

Examples (follow existing style)
- Option setting: `vim.opt.number = true`
- Keymap: `vim.keymap.set("n", "<leader>x", "<Cmd>SomeCommand<CR>", { noremap = true, silent = true })`
- Plugin setup: `require("plugin").setup({ ... })`

What not to do
- Do not introduce new global state without a clear reason.
- Do not move files across directories unless the change is requested.
- Do not add formatting tools or lint configs unless explicitly asked.

Verification checklist
- Open Neovim and run `:PackerSync` if plugin changes were made.
- Confirm no runtime errors on startup after editing config files.

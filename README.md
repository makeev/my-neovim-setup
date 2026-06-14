# Neovim Configuration

A modern, fast Neovim setup built on [lazy.nvim](https://github.com/folke/lazy.nvim) — LSP, completion, Git, and AI assistants out of the box.

## Highlights

- ⚡ **Native LSP** (`vim.lsp.config` API) with Mason-managed servers for Python, Lua, TypeScript/JavaScript, and Go
- 🐍 **Python-first**: basedpyright (with auto-imports) + Ruff (LSP) + mypy + debugpy
- 🤖 **AI**: GitHub Copilot ghost text with a smart `<Tab>` (snippet → Copilot → indent) and [sidekick.nvim](https://github.com/folke/sidekick.nvim) for CLI agents
- 🌗 **Auto light/dark** theme that follows the macOS system appearance
- 🚀 Fast completion via [blink.cmp](https://github.com/saghen/blink.cmp) (Rust matcher)
- 🧰 UI niceties consolidated in [snacks.nvim](https://github.com/folke/snacks.nvim): notifier, indent guides, smooth scroll, lazygit, input

## Requirements

| Tool | Why |
|------|-----|
| Neovim >= 0.10 | core (0.12+ recommended for native Treesitter) |
| Git | plugin management |
| Node.js >= 18 | some LSP servers, Copilot |
| Python >= 3.8 | Python LSP/linting |
| ripgrep | live grep |
| A Nerd Font | icons |
| fd, lazygit | optional (fuzzy find, Git UI) |

## Installation

```bash
# Back up any existing config
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null

# Clone and launch — plugins install on first start
git clone <your-repo-url> ~/.config/nvim
nvim
```

On first launch, lazy.nvim installs the plugins, Mason installs the LSP servers, and Treesitter downloads parsers. Then enable Copilot with `:Copilot auth`.

Dependencies on macOS:

```bash
brew install neovim ripgrep fd lazygit node
brew install --cask font-jetbrains-mono-nerd-font
```

## Structure

```
~/.config/nvim/
├── init.lua              # Editor options + autocommands entry point
├── lazy-lock.json        # Pinned plugin versions
├── check_setup.sh        # Python toolchain sanity check
└── lua/
    ├── config/
    │   ├── lazy.lua      # Bootstrap, leader keys, window navigation
    │   └── autocmds.lua  # Trim whitespace, highlight on yank, restore cursor
    └── plugins/          # One file per plugin (auto-imported)
```

## Plugins

| Area | Plugins |
|------|---------|
| Core | lazy.nvim, snacks.nvim |
| LSP & completion | nvim-lspconfig, mason.nvim, mason-lspconfig, blink.cmp, nvim-lint, conform.nvim |
| AI | copilot.lua, sidekick.nvim |
| Navigation | neo-tree.nvim, fzf-lua, harpoon, trouble.nvim, neominimap.nvim |
| Git | gitsigns.nvim, snacks lazygit |
| Editing | nvim-treesitter (+ context), nvim-autopairs, multicursor.nvim, text-case.nvim |
| UI | github-nvim-theme, tokyonight, catppuccin, lualine, bufferline, noice, which-key, mini.hipatterns |
| Sessions | persistence.nvim |
| Python | venv-selector.nvim, nvim-dap-python |
| Misc | vim-wakatime |

Configured LSP servers: **basedpyright** + **ruff** (Python), **lua_ls** (Lua), **ts_ls** (TS/JS), **gopls** (Go). Formatting is handled by conform.nvim (prettier, stylua, ruff).

## Keybindings

Leader is `<Space>`. Press `<leader>?` for buffer-local keymaps (which-key).

### General

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `<leader>p` | Format buffer/selection |

### Find / search (fzf-lua)

| Key | Action |
|-----|--------|
| `<leader>f` | Find files (cwd) |
| `<leader>g` | Live grep |
| `<leader>R` | Recent files |
| `<leader>s` | Workspace symbols |
| `<leader><leader>` | fzf-lua command menu |
| `<leader>:` | Command history |

### LSP

| Key | Action |
|-----|--------|
| `gd` / `gr` / `gi` | Definition / references / implementations |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<C-m>` | Code action |
| `<leader>ci` | Auto-import (basedpyright) |
| `<leader>ts` | Toggle workspace ↔ open-files diagnostics |
| `<leader>cv` | Select Python virtualenv |

### Completion & Copilot

| Key | Action |
|-----|--------|
| `<Enter>` | Accept completion (blink.cmp) |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-Space>` | Open menu / docs |
| `<Tab>` | Snippet jump → accept Copilot → indent |
| `<M-]>` / `<M-[>` | Next / previous Copilot suggestion |

### Git

| Key | Action |
|-----|--------|
| `<leader>G` | LazyGit |
| `<leader>gl` / `<leader>gf` | LazyGit log / file history |
| `]c` / `[c` | Next / previous hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk |
| `<leader>hp` / `<leader>hb` | Preview hunk / blame line |
| `<leader>hd` | Diff this |

### Diagnostics (Trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Diagnostics (all) |
| `<leader>xX` | Diagnostics (buffer) |
| `<leader>cs` / `<leader>cS` | Symbols / LSP references |
| `]q` / `[q` | Next / previous quickfix item |

### Terminal, Harpoon & Sessions

| Key | Action |
|-----|--------|
| `<C-t>` / `<M-t>` | Toggle terminal |
| `<leader>t1/t2/t3` | Focus/open terminal 1–3 |
| `<C-z>` | Zoom terminal |
| `<leader>m` | Add file to Harpoon |
| `<leader>hm` | Harpoon menu |
| `<leader>1`–`<leader>5` | Jump to Harpoon file 1–5 |
| `<leader>qs` / `<leader>ql` | Restore session / last session |

### Editing extras

| Key | Action |
|-----|--------|
| `<C-n>` | Add cursor at next match (multicursor) |
| `ga` | Text-case conversions (snake/camel/Pascal/…) |
| `<leader>M` | Focus minimap |

### AI agents (sidekick)

| Key | Action |
|-----|--------|
| `<M-a>` | Toggle CLI agent |
| `<leader>aa` / `<leader>ac` | Toggle CLI / Claude |
| `<leader>at` / `<leader>av` | Send line/file context / selection |

## Editor defaults

Set in `init.lua`: relative + absolute line numbers, 2-space indents, no line wrap, no swap/backup files, persistent undo (10000 levels), color columns at 80/120, current-line highlight, and trailing whitespace trimmed on save. Invisible characters are shown only in Visual mode.

## Maintenance

```vim
:Lazy update     " update plugins
:Mason           " manage LSP servers (U = update all)
:TSUpdate        " update Treesitter parsers
:checkhealth     " diagnose the setup
```

Verify the Python toolchain from the shell:

```bash
./check_setup.sh
```

### Troubleshooting

- **Plugins**: `:Lazy sync`
- **LSP**: `:LspInfo`, `:checkhealth lsp`
- **Python can't find modules**: pick the right virtualenv with `:VenvSelect`

## License

MIT

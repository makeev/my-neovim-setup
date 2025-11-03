# Neovim Configuration

Modern Neovim configuration with LSP support, autocompletion, Git integration, and AI assistant.

## Requirements

- **Neovim** >= 0.10.0
- **Git**
- **Node.js** >= 18.x (for some LSP servers)
- **Python** >= 3.8 (for Python LSP)
- **Nerd Font** (recommended for icons)
- **ripgrep** (for fast searching)
- **fd** (optional, for fzf)
- **lazygit** (optional, for Git UI)

## Installation

### 1. Installing Dependencies

#### macOS
```bash
# Install Neovim
brew install neovim

# Install additional utilities
brew install ripgrep fd lazygit node

# Install Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

#### Linux (Ubuntu/Debian)
```bash
# Install Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Install additional utilities
sudo apt install ripgrep fd-find nodejs npm

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

### 2. Installing Configuration

```bash
# Backup existing configuration (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone the repository
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim (plugins will install automatically)
nvim
```

On first launch:
1. Lazy.nvim will automatically install all plugins
2. Mason will install necessary LSP servers
3. Treesitter will download syntax parsers

### 3. Setting up GitHub Copilot (optional)

After the first launch, run:
```vim
:Copilot auth
```

## Project Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration file
├── lazy-lock.json          # Installed plugin versions
├── lua/
│   ├── config/
│   │   ├── lazy.lua        # Lazy.nvim plugin manager configuration
│   │   └── autocmds.lua    # Autocommands
│   └── plugins/            # Plugin configurations
│       ├── lsp.lua         # LSP configuration (Pyright, Ruff, Lua, TS, Go)
│       ├── blink.lua       # Autocompletion
│       ├── treesitter.lua  # Syntax highlighting
│       ├── copilot.lua     # GitHub Copilot
│       ├── neo-tree.lua    # File explorer
│       ├── fzf.lua         # Fuzzy finder
│       ├── gitsigns.lua    # Git integration
│       ├── lazygit.lua     # LazyGit integration
│       ├── lualine.lua     # Status line
│       ├── bufferline.lua  # Buffer tabs
│       ├── theme.lua       # Themes
│       ├── conform.lua     # Code formatting
│       ├── trouble.lua     # Diagnostics list
│       ├── toggleterm.lua  # Terminal
│       ├── which-key.lua   # Keyboard shortcuts hints
│       └── ...             # Other plugins
└── README.md               # This file
```

## Core Plugins

### Plugin Manager
- **lazy.nvim** - Modern plugin manager with lazy loading

### LSP and Autocompletion
- **nvim-lspconfig** - LSP server configuration (new vim.lsp.config API)
- **mason.nvim** - Manager for LSP servers, linters, and formatters
- **mason-lspconfig.nvim** - Mason integration with lspconfig
- **blink.cmp** - Fast Rust-based autocompletion

Supported languages:
- Python (Pyright + Ruff)
- Lua (lua_ls)
- TypeScript/JavaScript (ts_ls)
- Go (gopls)

### AI Assistant
- **copilot.lua** - GitHub Copilot integration

### Navigation and Search
- **neo-tree.nvim** - File explorer
- **fzf-lua** - Fast fuzzy search for files, text, etc.
- **trouble.nvim** - Beautiful error and diagnostics list

### Git
- **gitsigns.nvim** - Git status in buffer, blame, etc.
- **lazygit.nvim** - LazyGit integration

### Highlighting and Syntax
- **nvim-treesitter** - Advanced syntax highlighting
- **treesitter-context** - Shows function/class context at the top

### UI and Interface
- **github-nvim-theme** - GitHub theme (light/dark, auto-switching)
- **tokyonight.nvim** - TokyoNight theme
- **catppuccin** - Catppuccin theme
- **lualine.nvim** - Status line
- **bufferline.nvim** - Beautiful buffer line
- **noice.nvim** - Modern UI for messages and commands
- **which-key.nvim** - Keyboard shortcuts hints
- **indent-blankline.nvim** - Indent lines
- **mini.hipatterns** - Color and pattern highlighting

### Editing
- **nvim-autopairs** - Auto-close brackets
- **conform.nvim** - Code formatting
- **multicursor.nvim** - Multiple cursors
- **neoscroll.nvim** - Smooth scrolling

### Python-specific
- **venv-selector.nvim** - Python virtual environment selector

### Terminal
- **toggleterm.nvim** - Integrated terminal

### Other
- **neominimap.nvim** - Code minimap
- **sidekick.nvim** - Sidebar with context

## Keyboard Shortcuts

### Basic
- `<Space>` - Leader key
- `<C-h/j/k/l>` - Navigate between windows

### Files and Navigation
- `<leader>e` - Open/close Neo-tree
- `<leader>ff` - Find file (fzf)
- `<leader>fg` - Search content (grep)
- `<leader>fb` - Buffer list
- `<leader>fh` - File history

### LSP
- `gd` - Go to definition
- `gr` - Show references
- `gi` - Go to implementation
- `K` - Show documentation
- `<leader>rn` - Rename symbol
- `<C-m>` - Code actions

### Git
- `<leader>gg` - Open LazyGit
- `]c` / `[c` - Next/previous change (hunks)

### Terminal
- `<leader>t1` - Terminal 1
- `<leader>t2` - Terminal 2
- `<leader>t3` - Terminal 3

### Autocompletion (Blink)
- `<Enter>` - Accept completion
- `<C-n>` / `<C-p>` - Next/previous
- `<C-e>` - Close menu
- `<C-Space>` - Open menu/documentation

### Copilot
- `<Tab>` - Accept suggestion
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion

## Default Settings

- **Line numbers**: Enabled (absolute + relative)
- **Indentation**: 2 spaces, auto-indent enabled
- **Current line highlighting**: Enabled
- **Line wrapping**: Disabled
- **Backup files**: Disabled
- **Undo history**: Persistent (10000 levels)
- **Search**: No highlight after search
- **Color columns**: 80 and 120 characters
- **Auto-reload**: Enabled

### Features
- **Auto theme switching**: Theme automatically switches based on macOS system theme
- **Show invisible characters**: Only in Visual mode (spaces, tabs, etc.)
- **Document highlight**: Auto-highlight variables under cursor

## Installation Check

Run the check script:
```bash
./check_setup.sh
```

Or manually check in Neovim:
```vim
:checkhealth
:Mason
:Lazy
```

## Updating

### Update Plugins
```vim
:Lazy update
```

### Update LSP Servers
```vim
:Mason
# Press 'U' to update all
```

### Update Treesitter Parsers
```vim
:TSUpdate
```

## Troubleshooting

### Plugins Not Loading
```vim
:Lazy sync
:Lazy clean
:Lazy install
```

### LSP Not Working
```vim
:LspInfo                 # Check LSP status
:Mason                   # Check installed servers
:checkhealth lsp         # LSP diagnostics
```

### Python LSP Can't Find Modules
Make sure the correct virtual environment is selected:
```vim
:VenvSelect
```

## Customization

To add your own settings:
1. Create a file in `lua/plugins/` for new plugins
2. Modify `init.lua` for basic Vim settings
3. Use `lua/config/autocmds.lua` for autocommands

Examples:
```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  opts = {
    -- settings
  }
}
```

## License

MIT

## Contact

If you have questions or suggestions, create an issue in the repository.

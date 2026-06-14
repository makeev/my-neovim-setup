#!/bin/bash

# Python setup checker for Neovim

echo "🔍 Checking the Python setup for Neovim..."
echo ""

# Check Python tools
echo "📦 Checking installed tools:"

check_tool() {
    if command -v $1 &> /dev/null; then
        echo "✅ $1 is installed"
    else
        echo "❌ $1 is NOT installed - run: pip install $1"
    fi
}

check_tool pyright
check_tool ruff
check_tool mypy
check_tool debugpy

echo ""
echo "ℹ️  Note: Ruff now runs as an LSP server (via Mason)"

echo ""

# Check configuration files
echo "📁 Checking configuration files:"

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1 exists"
    else
        echo "❌ $1 is missing"
    fi
}

NVIM_DIR="$HOME/.config/nvim"

check_file "$NVIM_DIR/lua/plugins/lsp.lua"
check_file "$NVIM_DIR/lua/plugins/python.lua"
check_file "$NVIM_DIR/lua/plugins/trouble.lua"
check_file "$NVIM_DIR/lua/plugins/venv-selector.lua"

echo ""
echo "✨ Check complete!"
echo ""
echo "📚 Next steps:"
echo "1. Open Neovim: nvim"
echo "2. Wait for the plugins to install (Lazy.nvim)"
echo "3. Check Mason: :Mason"
echo "4. Open test_python.py: nvim ~/.config/nvim/test_python.py"
echo "5. Press <leader>xx to see errors in Trouble"
echo ""
echo "💡 Note: <leader> is usually Space or \\"

#!/bin/bash

# Скрипт проверки настройки Python для Neovim

echo "🔍 Проверка настройки Python для Neovim..."
echo ""

# Проверка Python инструментов
echo "📦 Проверка установленных инструментов:"

check_tool() {
    if command -v $1 &> /dev/null; then
        echo "✅ $1 установлен"
    else
        echo "❌ $1 НЕ установлен - выполните: pip install $1"
    fi
}

check_tool pyright
check_tool ruff
check_tool mypy
check_tool debugpy

echo ""
echo "ℹ️  Примечание: Ruff теперь используется как LSP сервер (через Mason)"

echo ""

# Проверка файлов конфигурации
echo "📁 Проверка файлов конфигурации:"

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1 существует"
    else
        echo "❌ $1 отсутствует"
    fi
}

NVIM_DIR="$HOME/.config/nvim"

check_file "$NVIM_DIR/lua/plugins/lsp.lua"
check_file "$NVIM_DIR/lua/plugins/python.lua"
check_file "$NVIM_DIR/lua/plugins/trouble.lua"
check_file "$NVIM_DIR/lua/plugins/venv-selector.lua"

echo ""
echo "✨ Проверка завершена!"
echo ""
echo "📚 Следующие шаги:"
echo "1. Откройте Neovim: nvim"
echo "2. Дождитесь установки плагинов (Lazy.nvim)"
echo "3. Проверьте Mason: :Mason"
echo "4. Откройте test_python.py: nvim ~/.config/nvim/test_python.py"
echo "5. Нажмите <leader>xx чтобы увидеть ошибки в Trouble"
echo ""
echo "💡 Примечание: <leader> обычно это пробел или \\"

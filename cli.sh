#!/bin/bash

CMD_1="$1"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME=~/.config
OS="$(uname)"

BLUE='\e[94m'
RESET='\e[0m'

print_help () {
    # shellcheck disable=SC2059
    printf "Options:
${BLUE}--help, -h${RESET} Print help

Commands:
    ${BLUE}link${RESET}     Link the configuration.
    ${BLUE}unlink${RESET}   Unlink the configuration
    ${BLUE}help${RESET}     Print help
"
}

if [ -z "$CMD_1" ]; then
    print_help
elif [ "$CMD_1" = "link" ]; then
    # ln -fsv "$SCRIPT_DIR/bash/.bashrc" ~/.bashrc
    # ln -fsv "$SCRIPT_DIR/bash/.inputrc" ~/.inputrc

    mkdir -p "$XDG_CONFIG_HOME/fish"
    ln -fsv "$SCRIPT_DIR/fish/config.fish" $XDG_CONFIG_HOME/fish/config.fish

    mkdir -p "$XDG_CONFIG_HOME/ghostty"
    ln -fsv "$SCRIPT_DIR/ghostty/config" $XDG_CONFIG_HOME/ghostty/config
    if [ "$OS" = "Darwin" ]; then
        ln -fsv "$SCRIPT_DIR/ghostty/macos.config" $XDG_CONFIG_HOME/ghostty/macos.config
    fi
    if [ "$OS" = "Linux" ]; then
        ln -fsv "$SCRIPT_DIR/ghostty/linux.config" $XDG_CONFIG_HOME/ghostty/linux.config
    fi

    if [ "$OS" = "Darwin" ]; then
        mkdir -p "$XDG_CONFIG_HOME/karabiner"
        ln -fsv "$SCRIPT_DIR/karabiner/karabiner.json" $XDG_CONFIG_HOME/karabiner
    fi

    # ln -fsv "$SCRIPT_DIR/kitty" $XDG_CONFIG_HOME
    ln -fsv "$SCRIPT_DIR/lazygit" $XDG_CONFIG_HOME
    ln -fsv "$SCRIPT_DIR/wezterm" $XDG_CONFIG_HOME

    mkdir -p "$XDG_CONFIG_HOME/mise"
    ln -fsv "$SCRIPT_DIR/mise/mise.toml" $XDG_CONFIG_HOME/mise/mise.toml

    mkdir -p "$XDG_CONFIG_HOME/nvim"
    ln -fsv "$SCRIPT_DIR/nvim/init.lua" $XDG_CONFIG_HOME/nvim/init.lua
    ln -fsv "$SCRIPT_DIR/nvim/colors" $XDG_CONFIG_HOME/nvim

    mkdir -p "$XDG_CONFIG_HOME/nushell"
    ln -fsv "$SCRIPT_DIR/nushell/config.nu" $XDG_CONFIG_HOME/nushell/config.nu
    ln -fsv "$SCRIPT_DIR/nushell/.zoxide.nu" $XDG_CONFIG_HOME/nushell/.zoxide.nu

    ln -fsv "$SCRIPT_DIR/tmux/tmux.conf" ~/.tmux.conf

    mkdir -p "$XDG_CONFIG_HOME/vim"
    ln -fsv "$SCRIPT_DIR/vim/vimrc" $XDG_CONFIG_HOME/vim/vimrc

    # if [ "$OS" = "Darwin" ]; then
    ln -fsv "$SCRIPT_DIR/zsh/.zshrc" ~/.zshrc
    # fi

    mkdir -p "$XDG_CONFIG_HOME/zed"
    ln -fsv "$SCRIPT_DIR/zed/keymap.json" $XDG_CONFIG_HOME/zed/keymap.json
    ln -fsv "$SCRIPT_DIR/zed/settings.json" $XDG_CONFIG_HOME/zed/settings.json
elif [ "$CMD_1" = "unlink" ]; then
    # rm -v ~/.bashrc
    # rm -v ~/.inputrc
    rm -v $XDG_CONFIG_HOME/fish/config.fish
    rm -v $XDG_CONFIG_HOME/ghostty/config
    if [ "$OS" = "Darwin" ]; then
        rm -v $XDG_CONFIG_HOME/ghostty/macos.config
    fi
    if [ "$OS" = "Linux" ]; then
        rm -v $XDG_CONFIG_HOME/ghostty/linux.config
    fi

    if [ "$OS" = "Darwin" ]; then
        rm -v $XDG_CONFIG_HOME/karabiner/karabiner.json
    fi

    # rm -v $XDG_CONFIG_HOME/kitty
    rm -v $XDG_CONFIG_HOME/lazygit
    rm -v $XDG_CONFIG_HOME/wezterm
    rm -v $XDG_CONFIG_HOME/mise/mise.toml
    rm -v $XDG_CONFIG_HOME/nvim/init.lua
    rm -v $XDG_CONFIG_HOME/nvim/colors
    rm -v $XDG_CONFIG_HOME/nushell/config.nu
    rm -v $XDG_CONFIG_HOME/nushell/.zoxide.nu
    rm -v ~/.tmux.conf
    rm -v $XDG_CONFIG_HOME/vim/vimrc

    # if [ "$OS" = "Darwin" ]; then
    rm -v ~/.zshrc
    # fi

    rm -v $XDG_CONFIG_HOME/zed/keymap.json
    rm -v $XDG_CONFIG_HOME/zed/settings.json
elif [[ $CMD_1 = "help" || $CMD_1 = "-h" || $CMD_1 = "--help" ]]; then
    echo "Ioan's configuration manager"
    echo ""
    print_help
else
    echo "Error: no such command '$CMD_1'"
    echo ""
    print_help
fi

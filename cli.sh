#!/bin/bash

CMD_1="$1"

DOTHOME=~/.ioansx
PWD=$(pwd)
XDG_CONFIG_HOME=~/.config

BLUE='\e[94m'
RESET='\e[0m'

ensure_dir_exists () {
    local dirname="$1"
    if [ ! -d "$dirname" ]; then
        echo "Creating directory: $dirname"
        mkdir "$dirname"
    fi
}

print_help () {
    # shellcheck disable=SC2059
    printf "Options:
${BLUE}--help, -h${RESET} Print help

Commands:
    ${BLUE}install${RESET}     Link the configuration with symbolic links
    ${BLUE}uninstall${RESET}   Unlink the configuration
    ${BLUE}help${RESET}        Print help
"
}

if [ -z "$CMD_1" ]; then
    print_help
elif [ "$CMD_1" = "install" ]; then
    ln -fsvw "$PWD/alacritty" $XDG_CONFIG_HOME
    ln -fsvw "$PWD/fish" $XDG_CONFIG_HOME
    ln -fsvw "$PWD/ghostty" $XDG_CONFIG_HOME

    if [ "$(uname)" == "Darwin" ]; then
        ensure_dir_exists $XDG_CONFIG_HOME/karabiner
        ln -fsvw "$PWD/karabiner/karabiner.json" $XDG_CONFIG_HOME/karabiner
    fi

    ln -fsvw "$PWD/kitty" $XDG_CONFIG_HOME
    ln -fsvw "$PWD/lazygit" $XDG_CONFIG_HOME
    ln -fsvw "$PWD/wezterm" $XDG_CONFIG_HOME

    ensure_dir_exists $XDG_CONFIG_HOME/nvim
    ln -fsvw "$PWD/nvim/init.lua" $XDG_CONFIG_HOME/nvim/init.lua

    ln -fsvw "$PWD/tmux/tmux.conf" ~/.tmux.conf
    ln -fsvw "$PWD/zsh/.zshrc" ~/.zshrc
elif [ "$CMD_1" = "uninstall" ]; then
    unlink -v $XDG_CONFIG_HOME/alacritty
    unlink -v $XDG_CONFIG_HOME/fish
    unlink -v $XDG_CONFIG_HOME/ghostty

    if [ "$(uname)" == "Darwin" ]; then
        unlink -v $XDG_CONFIG_HOME/karabiner/karabiner.json
    fi

    unlink -v $XDG_CONFIG_HOME/kitty
    unlink -v $XDG_CONFIG_HOME/lazygit
    unlink -v $XDG_CONFIG_HOME/wezterm
    unlink -v $XDG_CONFIG_HOME/nvim/init.lua
    unlink -v ~/.tmux.conf
    unlink -v ~/.zshrc
elif [[ $CMD_1 = "help" || $CMD_1 = "-h" || $CMD_1 = "--help" ]]; then
    echo "Ioan's configuration manager"
    echo ""
    print_help
else
    echo "Error: no such command '$CMD_1'"
    echo ""
    print_help
fi

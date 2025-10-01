#!/bin/bash

CMD_1="$1"

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
    ${BLUE}link${RESET}     Link the configuration.
    ${BLUE}unlink${RESET}   Unlink the configuration
    ${BLUE}help${RESET}     Print help
"
}

if [ -z "$CMD_1" ]; then
    print_help
elif [ "$CMD_1" = "link" ]; then
    ln -fsv "$PWD/bash/.bashrc" ~/.bashrc
    ln -fsv "$PWD/bash/.inputrc" ~/.inputrc

    ensure_dir_exists $XDG_CONFIG_HOME/fish
    ln -fsv "$PWD/fish/config.fish" $XDG_CONFIG_HOME/fish/config.fish

    ln -fsv "$PWD/ghostty" $XDG_CONFIG_HOME

    if [ "$(uname)" == "Darwin" ]; then
        ensure_dir_exists $XDG_CONFIG_HOME/karabiner
        ln -fsv "$PWD/karabiner/karabiner.json" $XDG_CONFIG_HOME/karabiner
    fi

    # ln -fsv "$PWD/kitty" $XDG_CONFIG_HOME
    ln -fsv "$PWD/lazygit" $XDG_CONFIG_HOME
    ln -fsv "$PWD/wezterm" $XDG_CONFIG_HOME

    ensure_dir_exists $XDG_CONFIG_HOME/nvim
    ln -fsv "$PWD/nvim/init.lua" $XDG_CONFIG_HOME/nvim/init.lua
    ln -fsv "$PWD/nvim/colors" $XDG_CONFIG_HOME/nvim

    ln -fsv "$PWD/nushell/config.nu" $XDG_CONFIG_HOME/nushell/config.nu
    ln -fsv "$PWD/nushell/.zoxide.nu" $XDG_CONFIG_HOME/nushell/.zoxide.nu

    ln -fsv "$PWD/tmux/tmux.conf" ~/.tmux.conf

    ensure_dir_exists $XDG_CONFIG_HOME/vim
    ln -fsv "$PWD/vim/vimrc" $XDG_CONFIG_HOME/vim/vimrc

    # if [ "$(uname)" == "Darwin" ]; then
    ln -fsv "$PWD/zsh/.zshrc" ~/.zshrc
    # fi

    ensure_dir_exists $XDG_CONFIG_HOME/zed
    ln -fsv "$PWD/zed/keymap.json" $XDG_CONFIG_HOME/zed/keymap.json
    ln -fsv "$PWD/zed/settings.json" $XDG_CONFIG_HOME/zed/settings.json
elif [ "$CMD_1" = "unlink" ]; then
    rm -v ~/.bashrc
    rm -v ~/.inputrc
    rm -v $XDG_CONFIG_HOME/fish/config.fish
    rm -v $XDG_CONFIG_HOME/ghostty

    if [ "$(uname)" == "Darwin" ]; then
        rm -v $XDG_CONFIG_HOME/karabiner/karabiner.json
    fi

    # rm -v $XDG_CONFIG_HOME/kitty
    rm -v $XDG_CONFIG_HOME/lazygit
    rm -v $XDG_CONFIG_HOME/wezterm
    rm -v $XDG_CONFIG_HOME/nvim/init.lua
    rm -v $XDG_CONFIG_HOME/nvim/colors
    rm -v $XDG_CONFIG_HOME/nushell/config.nu
    rm -v $XDG_CONFIG_HOME/nushell/.zoxide.nu
    rm -v ~/.tmux.conf
    rm -v $XDG_CONFIG_HOME/vim/vimrc

    # if [ "$(uname)" == "Darwin" ]; then
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

#!/bin/bash

CMD_1="$1"

DOTHOME=~/.ioansx
NVIM_CFG_DIR=$XDG_CONFIG_HOME/nvim
NVIM_LN=$NVIM_CFG_DIR/init.lua
PWD=$(pwd)
TMUX_LN=~/.tmux.conf
XDG_CONFIG_HOME=~/.config
ZSH_LN=~/.zshrc

BLUE='\e[94m'
RESET='\e[0m'

ensure_dir_exists () {
    local dirname="$1"
    if [ ! -d $dirname ]; then
        echo "Creating directory: $dirname"
        mkdir $dirname
    fi
}

ensure_linked () {
    local tname="$1"
    local lname="$2"
    if [ -L $lname ]; then
        echo "Symlink exists: $lname"
    else
        ln -sv $tname $lname
    fi
}

print_help () {
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
elif [ $CMD_1 = "install" ]; then
    echo "Configuring fish..."
    ensure_linked $PWD/fish $XDG_CONFIG_HOME

    echo "Configuring alacritty..."
    ensure_linked $PWD/alacritty $XDG_CONFIG_HOME

    echo "Configuring kitty..."
    ensure_linked $PWD/kitty $XDG_CONFIG_HOME

    echo "Configuring lazygit..."
    ensure_linked $PWD/lazygit $XDG_CONFIG_HOME

    echo "Configuring wezterm..."
    ensure_linked $PWD/wezterm $XDG_CONFIG_HOME

    echo "Configuring neovim..."
    ensure_dir_exists $NVIM_CFG_DIR
    ensure_linked $PWD/nvim/init.lua $NVIM_LN

    echo "Configuring tmux..."
    ensure_linked $PWD/tmux/tmux.conf $TMUX_LN

    echo "Configuring zsh..."
    ensure_linked $PWD/zsh/.zshrc $ZSH_LN
elif [ $CMD_1 = "uninstall" ]; then
    echo "Unlinking fish..."
    unlink $XDG_CONFIG_HOME/fish

    echo "Unlinking alacritty..."
    unlink $XDG_CONFIG_HOME/alacritty

    echo "Unlinking kitty..."
    unlink $XDG_CONFIG_HOME/kitty

    echo "Unlinking lazygit..."
    unlink $XDG_CONFIG_HOME/lazygit

    echo "Unlinking wezterm..."
    unlink $XDG_CONFIG_HOME/wezterm

    echo "Unlinking neovim..."
    unlink $NVIM_LN

    echo "Unlinking tmux..."
    unlink $TMUX_LN

    echo "Unlinking zsh..."
    unlink $ZSH_LN
elif [[ $CMD_1 = "help" || $CMD_1 = "-h" || $CMD_1 = "--help" ]]; then
    echo "Ioan's configuration manager"
    echo ""
    print_help
else
    echo "Error: no such command '$CMD_1'"
    echo ""
    print_help
fi

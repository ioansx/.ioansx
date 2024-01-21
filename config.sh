#!/bin/bash

CMD_1="$1"
PWD=$(pwd)
XDG_CONFIG_HOME=~/.config
FISH_CFG_DIR=$XDG_CONFIG_HOME/fish
NVIM_CFG_DIR=$XDG_CONFIG_HOME/nvim

FISH_LN_1=$FISH_CFG_DIR/config.fish
FISH_LN_2=$FISH_CFG_DIR/fish_variables
FISH_LN_3=$FISH_CFG_DIR/conf.d/fish_command_timer.fish
FISH_LN_4=$FISH_CFG_DIR/functions/fish_prompt.fish
NVIM_LN=$NVIM_CFG_DIR/init.lua
TMUX_LN=~/.tmux.conf


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
		ln -svw $tname $lname
	fi
}

print_help () {
	echo "Options:"
	echo "    --help, -h  Print help"
	echo ""
	echo "Commands:"
	echo "    install     Link the configuration with symbolic links"
	echo "    uninstall   Unlink the configuration"
	echo "    help        Print help"
}

if [ $CMD_1 = "install" ]; then
	echo "Configuring fish..."
	ensure_dir_exists $FISH_CFG_DIR
	ensure_linked $PWD/fish/config.fish $FISH_LN_1
	ensure_linked $PWD/fish/fish_variables $FISH_LN_2
	ensure_dir_exists $FISH_CFG_DIR/conf.d
	ensure_linked $PWD/fish/conf.d/fish_command_timer.fish $FISH_LN_3
	ensure_dir_exists $FISH_CFG_DIR/functions
	ensure_linked $PWD/fish/functions/fish_prompt.fish $FISH_LN_4

	echo "Configuring kitty..."
	ensure_linked $PWD/kitty $XDG_CONFIG_HOME

	echo "Configuring neovim..."
	ensure_dir_exists $NVIM_CFG_DIR
	ensure_linked $PWD/nvim/init.lua $NVIM_LN

	echo "Configuring tmux..."
	ensure_linked $PWD/tmux/tmux.conf $TMUX_LN
elif [ $CMD_1 = "uninstall" ]; then
	echo "Unlinking fish..."
	unlink $FISH_LN_1
	unlink $FISH_LN_2
	unlink $FISH_LN_3
	unlink $FISH_LN_4

	echo "Unlinking kitty..."
	unlink $XDG_CONFIG_HOME/kitty

	echo "Unlinking neovim..."
	unlink $NVIM_LN

	echo "Unlinking tmux..."
	unlink $TMUX_LN
elif [[ $CMD_1 = "help" || $CMD_1 = "-h" || $CMD_1 = "--help" ]]; then
	echo "Ioan's configuration manager"
	echo ""
	print_help
else
	echo "Error: no such command '$CMD_1'"
	echo ""
	print_help
fi

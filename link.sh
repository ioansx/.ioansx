#!/bin/bash

PWD=$(pwd)
XDG_CONFIG_HOME=~/.config

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

# --- fish ---
echo "Configuring fish..."
FISH_CFG_DIR=$XDG_CONFIG_HOME/fish
ensure_dir_exists $FISH_CFG_DIR
ensure_linked $PWD/fish/config.fish $FISH_CFG_DIR/config.fish
ensure_linked $PWD/fish/fish_variables $FISH_CFG_DIR/fish_variables
ensure_dir_exists $FISH_CFG_DIR/conf.d
ensure_linked $PWD/fish/conf.d/fish_command_timer.fish $FISH_CFG_DIR/conf.d/fish_command_timer.fish
ensure_dir_exists $FISH_CFG_DIR/functions
ensure_linked $PWD/fish/functions/fish_prompt.fish $FISH_CFG_DIR/functions/fish_prompt.fish


# --- kitty ---
echo "Configuring kitty..."
ensure_linked $PWD/kitty $XDG_CONFIG_HOME


# --- neovim ---
echo "Configuring neovim..."
NVIM_CFG_DIR=$XDG_CONFIG_HOME/nvim
ensure_dir_exists $NVIM_CFG_DIR
ensure_linked $PWD/nvim/init.lua $NVIM_CFG_DIR/init.lua


# --- tmux ---
echo "Configuring tmux..."
ensure_linked $PWD/tmux/tmux.conf ~/.tmux.conf

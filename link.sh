#!/bin/bash

PWD=$(pwd)
XDG_CONFIG_HOME=~/.config

ensure_dir_exists () {
	local dirname="$1"
	if [ ! -d $dirname ]; then
		echo "Creating directory $dirname"
		mkdir $dirname
	fi
}

ensure_unlinked () {
	local fname="$1"
	if [ -L $fname ]; then
		echo "Link already exists; unlinking $fname"
		unlink $fname
	fi
}

# --- kitty ---
echo "Configuring kitty"
KITTY_CFG_DIR=$XDG_CONFIG_HOME/kitty
KITTY_THEME_LN=$KITTY_CFG_DIR/GruvboxMaterialDarkHard.conf
KITTY_CONF_LN=$KITTY_CFG_DIR/kitty.conf
ensure_dir_exists $KITTY_CFG_DIR
ensure_unlinked $KITTY_THEME_LN
ensure_unlinked $KITTY_CONF_LN

echo "Linking $KITTY_THEME_LN"
ln -s $PWD/kitty/GruvboxMaterialDarkHard.conf $KITTY_THEME_LN

echo "Linking $KITTY_CONF_LN"
ln -s $PWD/kitty/kitty.conf $KITTY_CONF_LN


# --- neovim ---
echo "Configuring neovim"
NVIM_CFG_DIR=$XDG_CONFIG_HOME/nvim
NVIM_INIT_LUA_LN=$NVIM_CFG_DIR/init.lua
ensure_dir_exists $NVIM_CFG_DIR
ensure_unlinked $NVIM_INIT_LUA_LN

echo "Linking $NVIM_INIT_LUA_LN"
ln -s $PWD/nvim/init.lua $NVIM_INIT_LUA_LN


# --- tmux ---
echo "Configuring tmux"
TMUX_CONF_LN=~/.tmux.conf
ensure_unlinked $TMUX_CONF_LN

echo "Linking $TMUX_CONF_LN"
ln -s $PWD/tmux/tmux.conf $TMUX_CONF_LN


#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install \
	alacritty \
	curl \
	fd-find \
	gcc \
	git \
	make \
	ripgrep \
	tmux \
	vim \
	zsh \
	-y

sudo snap install \
	pgadmin4

nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-env -iA \
	nixpkgs.fzf \
	nixpkgs.go \
	nixpkgs.lazygit \
	nixpkgs.neovim \
	nixpkgs.nodejs_20

# Install docker
# https://docs.docker.com/engine/install/ubuntu/

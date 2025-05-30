#!/bin/bash

sudo apt update && apt upgrade

# General
sudo apt install \
	cmake \
	curl \
	gcc \
	git \
	htop \
	make \
	tmux \
	vim \
	zoxide \
	wl-clipboard \
	-y

# Neovim dependencies
sudo apt install \
	fd-find \
	ripgrep \
	shellcheck \
	-y

sudo snap install \
	pgadmin4

# Install docker
# https://docs.docker.com/engine/install/ubuntu/

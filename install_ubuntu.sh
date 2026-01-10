#!/bin/bash

sudo apt update && apt upgrade

# General
sudo apt install \
	cmake \
	curl \
	fish \
	fzf \
	gcc \
	git \
	htop \
	make \
	tmux \
	vim \
	zoxide \
	wl-clipboard \
	-y

sudo snap install ghostty --classic

sudo snap install nvim --classic
sudo apt install \
	fd-find \
	ripgrep \
	shellcheck \
	-y

sudo snap install \
	pgadmin4


if ! [ -x "$(command -v rustup)" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! [ -x "$(command -v pulumi)" ]; then
	curl -fsSL https://get.pulumi.com | sh
fi

# Install docker
# https://docs.docker.com/engine/install/ubuntu/
if ! [ -x "$(command -v docker)" ]; then
	# sudo apt remove -y docker \
	# 	docker-client \
	# 	docker-client-latest \
	# 	docker-common \
	# 	docker-latest \
	# 	docker-latest-logrotate \
	# 	docker-logrotate \
	# 	docker-selinux \
	# 	docker-engine-selinux \
	# 	docker-engine
fi

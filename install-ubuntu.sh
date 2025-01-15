#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install \
	curl \
	fd-find \
	gcc \
	git \
	make \
	ripgrep \
	tmux \
	vim \
	-y

sudo snap install \
	pgadmin4

# Install docker
# https://docs.docker.com/engine/install/ubuntu/

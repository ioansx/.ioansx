#!/bin/bash

sudo dnf copr enable -y scottames/ghostty
sudo dnf copr enable -y dejan/lazygit
sudo dnf copr enable -y jdxcode/mise

sudo dnf install -y \
	fish \
	fzf \
	ghostty \
	lazygit \
	mise \
	neovim \
	ripgrep \
	vim \
	zoxide

mise install

if ! [ -x "$(command -v rustup)" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! [ -x "$(command -v pulumi)" ]; then
	curl -fsSL https://get.pulumi.com | sh
fi

if ! [ -x "$(command -v docker)" ]; then
	# sudo dnf remove -y docker \
	# 	docker-client \
	# 	docker-client-latest \
	# 	docker-common \
	# 	docker-latest \
	# 	docker-latest-logrotate \
	# 	docker-logrotate \
	# 	docker-selinux \
	# 	docker-engine-selinux \
	# 	docker-engine
	sudo dnf -y install dnf-plugins-core
	sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo systemctl enable --now docker
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service
fi

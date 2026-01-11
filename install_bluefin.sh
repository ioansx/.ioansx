#!/bin/bash

brew install \
	fish \
	fzf \
	lazygit \
	mise \
	neovim \
	pulumi \
	ripgrep \
	texlive \
	vim \
	zoxide

# Neovim deps
brew install tree-sitter-cli

mise install

if ! [ -x "$(command -v ghostty)" ]; then
	. /etc/os-release
	curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" | sudo tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo > /dev/null

	rpm-ostree refresh-md && \
	rpm-ostree install ghostty
fi

if ! [ -x "$(command -v rustup)" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi


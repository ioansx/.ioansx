# My zsh config.

autoload -Uz promptinit
promptinit
PS1='%F{yellow}(%?)%f %F{green}%*%f %B%F{blue}%~%f%b %# '

setopt histignorealldups sharehistory

export KEYTIMEOUT=5

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
export CLICOLOR=YES
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export LANG=en_US.UTF-8

export EDITOR='nvim'
export VISUAL="$EDITOR"
export FCEDIT='vim'

bindkey -v

autoload -Uz edit-command-line
zle -N edit-command-line

function edit-command-line-clean() {
  local -x VISUAL="vim" EDITOR="vim"
  zle edit-command-line
}

zle -N edit-command-line-clean
bindkey -M vicmd 'v' edit-command-line-clean
bindkey -M viins '^X^E' edit-command-line-clean

export PATH="$PATH:$HOME/.ioansx/bin"
export XDG_CONFIG_HOME="$HOME/.config"

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias lzg="lazygit"
alias lzd="lazydocker"
alias nav='cd $(important-directories)'
alias man='MANWIDTH=80 man'

. "$HOME/.cargo/env"

if [ -f '/Users/ioan/google-cloud-sdk/path.zsh.inc' ]; then
    source '/Users/ioan/google-cloud-sdk/path.zsh.inc';
fi

source <(fzf --zsh)
eval "$(zoxide init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

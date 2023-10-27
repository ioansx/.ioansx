if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_vi_key_bindings
set fish_command_timer_time_format '%a %d %H:%M'

set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths

alias lg="lazygit"
alias ld="lazydocker"


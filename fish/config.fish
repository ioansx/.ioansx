if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_vi_key_bindings
set fish_command_timer_time_format '%a %d %H:%M'

# cargo path
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths

# user binaries and scripts
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

alias lzg="lazygit"
alias lzd="lazydocker"

fzf --fish | source

# -------------
# --- SoSha ---
# -------------
set -U fish_user_paths $HOME/dev/sosha/pulumi/ $fish_user_paths

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ioan/google-cloud-sdk/path.fish.inc' ]; . '/Users/ioan/google-cloud-sdk/path.fish.inc'; end
# -------------
# --- SoSha ---
# -------------

if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_vi_key_bindings
# set fish_command_timer_time_format '%a %d %H:%M'

set -x XDG_CONFIG_HOME "$HOME/.config"

# cargo path
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths

# user binaries and scripts
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

alias lg="lazygit"

fzf --fish | source
zoxide init fish | source

if [ -f '/Users/ioan/google-cloud-sdk/path.fish.inc' ]; . '/Users/ioan/google-cloud-sdk/path.fish.inc'; end

function fish_prompt --description 'Write out the prompt'
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)
        set -q fish_color_status
        or set -g fish_color_status red

        # Color the prompt differently when we're root
        set -l color_cwd $fish_color_cwd
        set -l suffix ' $'
        if functions -q fish_is_root_user; and fish_is_root_user
                if set -q fish_color_cwd_root
                        set color_cwd $fish_color_cwd_root
                end
                set suffix ' #'
        end

        # Write pipestatus
        # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
        set -l bold_flag --bold
        set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        if test $__fish_prompt_status_generation = $status_generation
                set bold_flag
        end
        set __fish_prompt_status_generation $status_generation
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color $bold_flag $fish_color_status)
        set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        echo -n -s (set_color $color_cwd) (prompt_pwd --full-length-dirs 13) $normal " "$prompt_status $suffix " "
end

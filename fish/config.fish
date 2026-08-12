function fish_greeting; end

set -x XDG_CONFIG_HOME "$HOME/.config"
fish_add_path /opt/homebrew/bin $HOME/.ioansx/bin $HOME/.cargo/bin $HOME/.pulumi/bin $HOME/.local/bin $HOME/dev/google-cloud-sdk/bin

fish_vi_key_bindings

fzf --fish | source
zoxide init fish | source
mise activate fish | source
# mise re-reads the environment on every prompt (~11ms). Its PWD hook already
# covers directory changes, so keep that and drop the per-prompt check.
functions --erase __mise_env_eval_on_prompt

# Ayu Mirage accents the prompt borrows from.
set -g __prompt_dim 5C6773
set -g __prompt_insert 5CCFE6
set -g __prompt_command_mode FFCC66
set -g __prompt_visual D4BFFF
set -g __fish_git_prompt_color $__prompt_dim

# The mode block is drawn inside fish_prompt so the blank-line separator can sit
# above it. Fish repaints the whole prompt on a mode change, so it stays live.
function fish_mode_prompt; end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status red

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '└─▶'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '└─#'
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

    # One palette drives both the mode block and the arrow.
    set -l mode_label I
    set -l mode_color $__prompt_insert
    switch $fish_bind_mode
        case default
            set mode_label N
            set mode_color $__prompt_command_mode
        case visual
            set mode_label V
            set mode_color $__prompt_visual
        case replace replace_one
            set mode_label R
            set mode_color $fish_color_status
    end

    # A failed command overrides the mode colour on the arrow: that signal is
    # transient and worth interrupting for, while the mode is one keypress away.
    set -l suffix_color (set_color $mode_color)
    if test $__fish_last_status -ne 0
        set suffix_color (set_color $fish_color_status)
    end

    # Blank line first, so each command's output reads as its own block.
    echo ""
    echo -s (set_color --bold $mode_color) "[$mode_label]" $normal " " \
        (set_color $__prompt_dim) (date "+%T") " " \
        (set_color $color_cwd) (prompt_pwd --full-length-dirs 13) $normal \
        (fish_git_prompt) " "$prompt_status
    echo -n -s $suffix_color $suffix $normal " "
end

# How long the last command took. $CMD_DURATION is a fish builtin, so this
# costs no subprocess.
function fish_right_prompt
    set -l ms $CMD_DURATION
    set -q ms[1]; or set ms 0
    set -l pretty
    if test $ms -lt 1000
        set pretty {$ms}ms
    else if test $ms -lt 60000
        set pretty (math -s1 $ms/1000)s
    else
        set pretty (math -s0 $ms/60000)m(math -s0 "$ms%60000/1000")s
    end
    echo -n -s (set_color $__prompt_dim) $pretty (set_color normal)
end

if status is-interactive
        # Commands to run in interactive sessions can go here
end

function gob
    set url (git remote get-url origin 2>/dev/null)
    if test -n "$url"
        if string match -q '*github.com*' -- $url
            if string match -q 'git@*' -- $url
                set url (string replace -r '^git@' '' $url)
                set url (string replace ':' '/' $url)
                set url "https://$url"
            end
            open "$url"
        else
            echo "This repository is not hosted on GitHub"
        end
    else
        echo "No remote found"
    end
end

fish_vi_key_bindings

alias lzg="lazygit"

set -x XDG_CONFIG_HOME "$HOME/.config"
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
set -U fish_user_paths $HOME/.pulumi/bin $fish_user_paths
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

if test -f ~/dev/google-cloud-sdk/path.fish.inc
    source ~/dev/google-cloud-sdk/path.fish.inc
end

fzf --fish | source
zoxide init fish | source
mise activate fish | source

function humantime --argument-names ms --description "Turn milliseconds into a human-readable string"
    set --query ms[1] || return

    set --local secs (math --scale=1 $ms/1000 % 60)
    set --local mins (math --scale=0 $ms/60000 % 60)
    set --local hours (math --scale=0 $ms/3600000)

    test $hours -gt 0 && set --local --append out $hours"h"
    test $mins -gt 0 && set --local --append out $mins"m"
    test $secs -gt 0 && set --local --append out $secs"s"

    set --query out && echo $out || echo $ms"ms"
end

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

    # echo -n -s (humantime $CMD_DURATION) (set_color $color_cwd) " [" (date "+%T") "] " (prompt_pwd --full-length-dirs 13) $normal " "$prompt_status $suffix " "
    echo -n -s (set_color $color_cwd) (date "+%T") " " (prompt_pwd --full-length-dirs 13) $normal " "$prompt_status $suffix " "
end

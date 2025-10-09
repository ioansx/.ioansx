local wezterm = require "wezterm"

local config = wezterm.config_builder()

local is_linux = function()
    return wezterm.target_triple:find("linux") ~= nil
end

if is_linux() then
    config.default_prog = { '/usr/bin/fish', '-l' }
else
    config.default_prog = { '/usr/local/bin/fish', '-l' }
end

config.color_scheme = "GruvboxDarkHard"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 120
config.window_padding = {
    left = 0,
    top = 0,
    right = 0,
    bottom = 0,
}

config.font = wezterm.font "JetBrainsMono Nerd Font"
config.font_size = 14
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.send_composed_key_when_right_alt_is_pressed = false

local act = wezterm.action

wezterm.on('update-right-status', function(window)
    window:set_right_status(window:active_workspace())
end)

config.keys = {
    {
        key = 'k',
        mods = 'ALT',
        action = act.SwitchWorkspaceRelative(1)
    },
    {
        key = 'j',
        mods = 'ALT',
        action = act.SwitchWorkspaceRelative(-1)
    },
    {
        key = 'o',
        mods = 'ALT',
        action = act.SwitchToWorkspace { name = 'notes' },
    },
    {
        key = 'i',
        mods = 'ALT',
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
    {
        key = 'N',
        mods = 'CTRL|SHIFT',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    },
}

return config

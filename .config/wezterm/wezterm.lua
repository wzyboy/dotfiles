local wezterm = require("wezterm")
local act = wezterm.action

local config = {
    audible_bell = "Disabled",
    check_for_updates = false,
    color_scheme = "Tokyo Night",
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    initial_cols = 120,
    initial_rows = 30,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    font = wezterm.font 'Iosevka Term',
    font_size = 12.0,
    launch_menu = {},
    leader = { key = "b", mods = "CTRL" },
    disable_default_key_bindings = true,
    keys = {
        { key = '-', mods = 'LEADER', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
        { key = '|', mods = 'SHIFT|LEADER', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
        { key = 'c', mods = 'LEADER', action = act.SpawnCommandInNewTab{ cwd =  wezterm.home_dir } },
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane{ confirm = true } },
        { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

        { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
        { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize{ 'Left', 5 } },
        { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize{ 'Down', 5 } },
        { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize{ 'Up', 5 } },
        { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize{ 'Right', 5 } },

        { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
        { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
        { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
        { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
        { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
        { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
        { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
        { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
        { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
        { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
        { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

        { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
        { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
        { key = 'N', mods = 'CTRL', action = act.ToggleFullScreen },
        { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
    },
    set_environment_variables = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    local git_bash = "C:/Program Files/Git/bin/bash.exe"
    config.default_prog = { git_bash, "-i" }
    table.insert(config.launch_menu, { label = "Git Bash", args = { git_bash, "-i" } })
else
    config.default_prog = { "/bin/bash", "-i" }
    table.insert(config.launch_menu, { label = "bash", args = {"bash", "-i"} })
end

return config

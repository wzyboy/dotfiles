local wezterm = require("wezterm")

local function file_exists(path)
    local f = io.open(path, "r")
    if f~=nil then io.close(f) return true else return false end
end

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
        { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        { key = "|", mods = "LEADER|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
        { key = "c", mods = "LEADER",       action=wezterm.action{SpawnCommandInNewTab={cwd=wezterm.home_dir}}},
        { key = "h", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
        { key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
        { key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
        { key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
        { key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
        { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
        { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
        { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
        { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
        { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
        { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
        { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
        { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
        { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
        { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
        { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
        { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
        { key = "n", mods = "LEADER",       action=wezterm.action{ActivateTabRelative=1}},
        { key = "p", mods = "LEADER",       action=wezterm.action{ActivateTabRelative=-1}},
        { key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
        { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},

        { key = "n", mods = "SHIFT|CTRL",   action="ToggleFullScreen" },
        { key = "v", mods = "SHIFT|CTRL",   action=wezterm.action.PasteFrom 'Clipboard'},
        { key = "c", mods = "SHIFT|CTRL",   action=wezterm.action.CopyTo 'Clipboard'},
        { key = "+", mods = "SHIFT|CTRL",   action="IncreaseFontSize" },
        { key = "-", mods = "SHIFT|CTRL",   action="DecreaseFontSize" },
        { key = "0", mods = "SHIFT|CTRL",   action="ResetFontSize" },
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

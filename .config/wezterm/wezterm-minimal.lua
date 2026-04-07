local wezterm = require('wezterm')

local config = {
    audible_bell = 'Disabled',
    check_for_updates = false,
    color_scheme = 'Tokyo Night',
    initial_cols = 120,
    initial_rows = 30,
    font = wezterm.font 'Iosevka Term',
    font_size = 12.0,
    enable_tab_bar = false,
}

return config

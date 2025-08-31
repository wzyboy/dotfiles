local wezterm = require 'wezterm'
local act = wezterm.action

local copy_mode = nil
if wezterm.gui then
    copy_mode = wezterm.gui.default_key_tables().copy_mode
    table.insert(
        copy_mode,
        { key = 'Enter', mods = 'NONE', action = act.Multiple{ { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } }
    )
end

local config = {
    audible_bell = 'Disabled',
    check_for_updates = false,
    color_scheme = 'Tokyo Night',
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
    leader = { key = 'b', mods = 'CTRL' },
    disable_default_key_bindings = true,
    keys = {
        { key = '-', mods = 'LEADER', action = act.SplitVertical },
        { key = '|', mods = 'SHIFT|LEADER', action = act.SplitHorizontal },
        { key = 'c', mods = 'LEADER', action = act.SpawnCommandInNewTab{ cwd = wezterm.home_dir } },
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane{ confirm = true } },
        { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
        { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },

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
        { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    },
    key_tables = {
        copy_mode = copy_mode,
    },
    set_environment_variables = {},
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    local git_bash = 'C:/Program Files/Git/bin/bash.exe'
    config.default_prog = { git_bash, '-i' }
    table.insert(config.launch_menu, { label = 'Git Bash', args = { git_bash, '-i' } })
else
    config.default_prog = { '/bin/bash', '-i' }
    table.insert(config.launch_menu, { label = 'bash', args = { 'bash', '-i' } })
end

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  local date = wezterm.strftime '%Y-%m-%d  %H:%M'
  table.insert(cells, date)

  local hostname = wezterm.hostname()
  table.insert(cells, hostname)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = colors[cell_no] } })
    table.insert(elements, { Text = '' })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell)
  end

  window:set_right_status(wezterm.format(elements))
end)

return config

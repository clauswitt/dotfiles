local wezterm = require 'wezterm';
local segments = require 'segments';
local colors = require 'colors';
local keys = require 'keys';
local config = wezterm.config_builder();

local function is_appearance_dark()
  local appearance = (wezterm.gui and wezterm.gui.get_appearance()) or 'Light'
  return appearance:find("Dark")
end

local known_shells = {
  bash = true, zsh = true, fish = true,
  sh = true, csh = true, tcsh = true
}

local function basename(path)
  return path:gsub('(.*[/\\])(.*)', '%2'):gsub('[%.][eE][xX][eE]$', '')
end

local function ternary(a, b)
  if a and a ~= '' then
    return a
  end
  return b
end

local function get_progress(pane, raw_title, foreground)
  -- Note: pane.progress is not available in current wezterm version
  -- Disabled to prevent runtime errors
  return foreground, raw_title
end

local function get_title(tab, foreground)
  -- Figure out what title to show
  local pane = tab.active_pane
  local raw_title = tab.tab_title
  local ran_cmd = pane.user_vars.WEZTERM_CMD or ''
  local pane_title = pane.title
  local base_pane_title = basename(pane_title)
  local is_shell = base_pane_title ~= '' and known_shells[base_pane_title]
  local proc_name = basename(pane.foreground_process_name)
  if raw_title == '' then
    if pane_title == '' then
      raw_title = ternary(ran_cmd, proc_name)
    elseif ran_cmd == '' then
      if is_shell then
        raw_title = ternary(proc_name, base_pane_title)
      else
        raw_title = ternary(pane_title, proc_name)
      end
    else
      if is_shell then
        raw_title = ternary(ran_cmd, base_pane_title)
      else
        raw_title = ternary(pane_title, ran_cmd)
      end
    end
  end
  if raw_title == '' then
    raw_title = ternary(proc_name, basename(os.getenv('WEZTERM_EXECUTABLE')))
  else
    raw_title = raw_title:gsub('[%.][eE][xX][eE]$', '')
  end

  -- If there is progress, show that as well
  return get_progress(pane, raw_title, foreground)
end

wezterm.on('format-tab-title',
  function(tab, tabs, _, econfig, _, max_width)
    local color_scheme = econfig.resolved_palette
    local total_tabs = #tabs > 0 and #tabs or 1
    local foreground = color_scheme.foreground
    local edge_background = color_scheme.tab_bar.background

    -- Build a gradient across the number of tabs
    local base_bg = wezterm.color.parse(color_scheme.background)
    local gradient_to, gradient_from = base_bg, base_bg
    if is_appearance_dark() then
      gradient_from = gradient_to:lighten(0.15)
    else
      gradient_from = gradient_to:darken(0.15)
    end
    local gradient = wezterm.color.gradient(
      {
        orientation = 'Horizontal',
        colors = { gradient_to, gradient_from },
      },
      total_tabs
    )

    -- Use the tab index (0-based) to pick the colour for this tab
    local current_index0 = tab.tab_index or 0
    local background = gradient[current_index0 + 1]

    -- Make the right wedge blend into the NEXT tab's background color
    local next_index0 = current_index0 + 1
    local next_background
    if next_index0 < total_tabs then
      next_background = gradient[next_index0 + 1]
    end

    local fg_color, raw_title = get_title(tab, foreground)

    -- Ensure that the titles fit in the available space,
    local title_cells = math.max(0, max_width - 3) -- (leading space + trailing space + wedge)
    local title = wezterm.truncate_right((tab.tab_index + 1) .. ': ' .. raw_title, title_cells)

    return {
      { Background = { Color = background } },
      { Foreground = { Color = fg_color } },
      { Text = ' ' .. title .. ' ' },

      { Background = { Color = next_background or edge_background } },
      { Foreground = { Color = background } },
      { Text = '' },
    }
  end
)

wezterm.on('update-status',
  function(window, pane)
    local segs = segments.get_right_status_segments(window, pane)
    local color_scheme = window:effective_config().resolved_palette

    -- wezterm.color.parse returns a Color object, which we can
    -- lighten or darken (amongst other things).
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    local gradient_to, gradient_from = bg, bg
    if is_appearance_dark() then
      gradient_from = gradient_to:lighten(0.15)
    else
      gradient_from = gradient_to:darken(0.15)
    end
    local gradient = wezterm.color.gradient(
      {
        orientation = 'Horizontal',
        colors = { gradient_from, gradient_to },
      },
      #segs -- as many colours as no. of segments
    )

    -- Build up the elements to send to wezterm.format
    local elements = {}

    for i, seg in ipairs(segs) do
      local is_first = i == 1

      if is_first then
        table.insert(elements, { Background = { Color = 'none' } })
      end
      table.insert(elements, { Foreground = { Color = gradient[i] } })
      table.insert(elements, { Text = '' })

      table.insert(elements, { Foreground = { Color = fg } })
      table.insert(elements, { Background = { Color = gradient[i] } })
      table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end
    window:set_right_status(wezterm.format(elements))
  end
)

-- Always use dark mode
config.colors = colors.theme_config.dark
config.command_palette_bg_color = colors.theme_config.dark.tab_bar.active_tab.bg_color
config.command_palette_fg_color = colors.theme_config.dark.tab_bar.active_tab.fg_color
config.keys = keys.bindings
config.mouse_bindings = keys.mouse_bindings
config.default_prog = { 'zsh', '-l' }
config.initial_cols = 90
config.initial_rows = 30
config.scrollback_lines = 10000
config.max_fps = 120
config.switch_to_last_active_tab_when_closing_tab = true
config.window_decorations = "RESIZE"
config.enable_scroll_bar = true
config.font = wezterm.font("Source Code Pro")
if wezterm.target_triple == 'aarch64-apple-darwin' then
  config.font_size = 14
end
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.status_update_interval = 10000
config.set_environment_variables = {
  POWERSHELL_UPDATECHECK= "Off",
}
config.unix_domains = {
  { name = "default" }
}

-- Allow Option key to be used for typing special characters on non-US keyboards
-- This is essential for Danish keyboard layouts where Option is needed for characters like backslash
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Allow CMD key to bypass mouse reporting in tmux
-- This makes CMD+click work for opening links even when tmux has mouse mode enabled
config.bypass_mouse_reporting_modifiers = 'CMD'

-- Enable clickable hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Add custom rules for URLs without explicit protocol
table.insert(config.hyperlink_rules, {
  regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
  format = 'mailto:$0',
})

return config;

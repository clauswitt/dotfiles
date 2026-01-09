local wezterm = require 'wezterm';

local M = {}
local system_shell = { 'cmd' }
local bash_env = 'MINGW64'
if wezterm.target_triple == 'aarch64-apple-darwin' then
  system_shell = { 'zsh', '-l' }
  bash_env = ''
end

M.bindings = {
  -- Claude Code multi-line support: Shift+Enter adds newlines
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
  -- Shortcuts
}

-- Mouse bindings: CMD+click to open links, regular click for text selection only
M.mouse_bindings = {
  -- Regular click: select text only, don't open hyperlinks
  -- This makes it easy to select URLs for copying without accidentally opening them
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'Clipboard',
  },

  -- CMD+click: open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },

  -- Disable the 'Down' event of CMD+Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.Nop,
  },
}

return M

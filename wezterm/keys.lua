local wezterm = require 'wezterm';

local M = {}
local system_shell = { 'cmd' }
local bash_env = 'MINGW64'
if wezterm.target_triple == 'aarch64-apple-darwin' then
  system_shell = { 'zsh', '-l' }
  bash_env = ''
end

M.bindings = {
  -- Shortcuts
}

return M

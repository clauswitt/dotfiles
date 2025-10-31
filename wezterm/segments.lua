local wezterm = require 'wezterm'

local M = {}

-- Cache for right status segments
local cache = {
  spotify = '',
  kube = '',
  git = '',
  day = '',
  last_update_ms = 0,
}


local function is_process_running_macos(image)
  -- -q: quiet (no output), rely on exit status
  -- -x: exact match of the process name
  local ok, _, _ = wezterm.run_child_process{
    "pgrep",
    "-q",
    "-x",
    image,
  }

  return ok
end

local function is_process_running(image)
  if wezterm.target_triple == 'aarch64-apple-darwin' then
    return is_process_running_macos(image)
  end
  return is_process_running_windows(image .. '.exe')
end

local function get_playback_status()
  -- Check if spotify_player process is running

  if not is_process_running('spotify_player') then
      return ''
  end

  local success, result, _ = wezterm.run_child_process{
    '/opt/homebrew/bin/spotify_player',
    'get',
    'key',
    'playback'
  }

  if not success or not result then
      return ''
  end

  -- Trim whitespace
  result = result:gsub("^%s*(.-)%s*$", "%1")

  if result == "null" then
    return "2N/A"
  end


  local status_data = wezterm.json_parse(result)
  local is_playing, track_name = status_data.is_playing, status_data.item.name

  -- Handle track name (nil if not found or null)
  if not track_name or track_name == "null" or track_name == "" then
      track_name = nil
  end

  if is_playing == nil and track_name == nil then
      return "󰎊"
  elseif is_playing == false and track_name then
      return "󰏤 " .. track_name
  elseif is_playing == true and track_name then
      return "󰐊 " .. track_name
  else
      return ""
  end
end


local function get_current_kube_context()
  -- the below command will give us the following output:
  -- saas-qa01-aks\n
  local pcall_ok, success, output, _ = pcall(wezterm.run_child_process, {
    '/opt/homebrew/bin/kubectl',
    'config',
    'current-context'
  })

  if not pcall_ok then
    return ''
  end

  if not success or not output or output == "" then
    return ''
  end

  -- Trim whitespace from both ends
  output = output:match("^%s*(.-)%s*$")

  -- Shorten long AWS EKS ARN context names
  -- arn:aws:eks:region:account:cluster/name -> name
  local short_name = output:match("cluster/(.+)$") or output

  return '󱃾 ' .. short_name
end

local function get_git_info(pane)
  -- Only get git info if we're in a git repo
  local ok, cwd = pcall(function() return pane:get_current_working_dir() end)
  if not ok or not cwd then
    return ''
  end

  -- Extract path from file:// URL
  local path = cwd.file_path or cwd
  path = tostring(path):gsub('^file://[^/]*', '')

  local pcall_ok, success, branch_output, _ = pcall(wezterm.run_child_process, {
    '/opt/homebrew/bin/starship',
    'module',
    'git_branch',
    '--path', path
  })

  if not pcall_ok or not success or not branch_output or branch_output == '' then
    return ''
  end

  -- Get git status as well
  local _, status_success, status_output, _ = pcall(wezterm.run_child_process, {
    '/opt/homebrew/bin/starship',
    'module',
    'git_status',
    '--path', path
  })

  local result = branch_output
  if status_success and status_output and status_output ~= '' then
    result = result .. status_output
  end

  -- Strip ANSI codes and trim
  result = result:gsub('\27%[[0-9;]*m', ''):gsub("^%s*(.-)%s*$", "%1")

  return result
end


-- Returns true if we should refresh based on the effective status update interval
local function is_stale(window)
  local now_ms = os.time() * 1000
  local interval_ms = window:effective_config().status_update_interval
  return (now_ms - cache.last_update_ms) >= interval_ms
end

local function refresh_cache(pane)
  -- Update synchronously; this runs at most as often as status_update_interval
  cache.spotify = get_playback_status() or ''
  cache.kube = get_current_kube_context() or ''
  cache.git = get_git_info(pane) or ''
  cache.day = wezterm.strftime(' %a, %b %-d')
  cache.last_update_ms = os.time() * 1000
end

function M.get_right_status_segments(window, pane)
  -- Protect against stale pane references
  local ok, domain = pcall(function() return pane:get_domain_name() end)
  if not ok then
    wezterm.log_warn('Failed to get domain name from pane: ' .. tostring(domain))
    return {}
  end

  local items = {}

  -- If we're in tmux, return empty segments (tmux will handle its own status line)
  -- Check TMUX environment variable (standard variable set by tmux)
  local user_vars_ok, user_vars = pcall(function() return pane:get_user_vars() end)
  if user_vars_ok and user_vars.TMUX and user_vars.TMUX ~= '' then
    return {}
  end

  -- Check pane title which contains tmux session info when tmux is running
  local title_ok, title = pcall(function() return pane.title end)
  if title_ok and title and (title:find('%[tmux') or title:find('tmux%[')) then
    return {}
  end

  -- Also check foreground process
  local process_ok, foreground_process = pcall(function() return pane.foreground_process_name end)
  if process_ok and foreground_process and foreground_process:find('tmux') then
    return {}
  end

  -- we can use `cols` to do conditional rendering of segments
  -- local cols = window:mux_window():active_tab():get_size().cols

  if domain == 'local' or domain == 'default' then
    local domain_display = ''
    if domain == 'default' then
      domain_display = 'MUX'
    end

    if is_stale(window) then
      refresh_cache(pane)
    end

    items = {
      cache.spotify,
      cache.kube,
      cache.git,
      cache.day,
      domain_display
    }
  else
    local m = pane:get_metadata() or {}
    local ms = m.since_last_response_ms or ''

    items = {
      " ".. ms .. "ms",
      wezterm.strftime(' %a, %b %-d'),
      domain
    }
  end

  -- Build segments and filter out empty values to avoid duplicate checks
  local result = {}
  for _, v in ipairs(items) do
    if v and v ~= '' then
      table.insert(result, v)
    end
  end
  return result
end

return M



#!/bin/bash
# Generate status segments for tmux using the same logic as wezterm

STARSHIP="/opt/homebrew/bin/starship"
SPOTIFY_PLAYER="/opt/homebrew/bin/spotify_player"
KUBECTL="/opt/homebrew/bin/kubectl"

# Strip ANSI codes
strip_ansi() {
  echo "$1" | sed 's/\x1b\[[0-9;]*m//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Get Spotify status
get_spotify() {
  if ! pgrep -q -x spotify_player; then
    return
  fi

  local result=$($SPOTIFY_PLAYER get key playback 2>/dev/null)
  if [[ -z "$result" || "$result" == "null" ]]; then
    return
  fi

  local is_playing=$(echo "$result" | grep -o '"is_playing":[^,]*' | cut -d':' -f2)
  local track_name=$(echo "$result" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)

  if [[ -z "$track_name" || "$track_name" == "null" ]]; then
    return
  fi

  if [[ "$is_playing" == "true" ]]; then
    echo "󰐊 $track_name"
  elif [[ "$is_playing" == "false" ]]; then
    echo "󰏤 $track_name"
  fi
}

# Get Kubernetes context
get_kube() {
  local context=$($KUBECTL config current-context 2>/dev/null)
  if [[ -z "$context" ]]; then
    return
  fi

  # Shorten AWS EKS ARN
  local short_name=$(echo "$context" | sed 's|.*cluster/\(.*\)|\1|')
  echo "󱃾 $short_name"
}

# Get date
get_date() {
  date +" %a, %b %-d"
}

# Build segments array
segments=()

spotify=$(get_spotify)
[[ -n "$spotify" ]] && segments+=("$spotify")

kube=$(get_kube)
[[ -n "$kube" ]] && segments+=("$kube")

date_str=$(get_date)
[[ -n "$date_str" ]] && segments+=("$date_str")

# Join segments with separator
output=""
for ((i=0; i<${#segments[@]}; i++)); do
  if [[ $i -eq 0 ]]; then
    output="${segments[$i]}"
  else
    output="$output | ${segments[$i]}"
  fi
done

echo "$output"

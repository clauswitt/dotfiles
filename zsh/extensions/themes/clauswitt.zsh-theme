RPROMPT='$(rvm-prompt) $(battery_pct_prompt) $EPS1'

function get_pwd() {
  echo "${PWD/$HOME/~}"
}

PROMPT='
%{$fg[cyan]%}[%~% ]
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} %B$%b '


function get_pwd() {
  echo "${PWD/$HOME/~}"
}

PROMPT='
%{$fg[cyan]%}%~%    %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}    $(rvm-prompt) 
%{$fg[magenta]%}λ%{$reset_color%} '



ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}!!!!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

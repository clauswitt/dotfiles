TERM=screen-256color-bce
alias tc="~/Scripts/tmux-copy-session.sh"
alias editzsh='vim ~/.oh-my-zsh/plugins/cw/cw.plugin.zsh'
alias ez="editzsh"
alias theme="vim ~/.oh-my-zsh/themes/clauswitt.zsh-theme"
alias r="/usr/local/bin/r"

alias here='open . '
alias dup='open . -a "iTerm.app"'
alias deck='open -a "DeckSet.app"'


alias cdg='cd "$(git rev-parse --show-toplevel)"'

daemons() {
  if (( $# == 0 )) then
    echo "Usage: daemons [pattern] [command]"
    echo "\n"
    return
  fi
  daemon_list=`launchctl list|grep "$1" |awk '{print $3}'`
  if (( $# == 1 )) then
    echo $daemon_list
    return
  fi
  if (( $# == 2 )) then
    if [[ $2 == "start" ]] then
      echo 'starting'
      launchctl start $daemon_list
      return
    fi
    if [[ $2 == "stop" ]] then
      echo 'stopping'
      launchctl stop $daemon_list
      return
    fi
    if [[ $2 == "restart" ]] then
      echo 'restarting'
      launchctl stop $daemon_list
      launchctl start $daemon_list
      return
    fi
    echo "'$2' is not a legal command - I only support start, stop and restart"
  fi
}

newpost() {
  middleman article $1
  vim `gsts |awk '{print \$2}'`
}


alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
# Setup default root paths
CDPATH=.:~/Documents/Projects:~/Documents/Projects/private:~/Documents/Projects/work:~/Dropbox:~
# Use vim text as default editor
EDITOR=vim
export EDITOR='vim'

get_path_part() {
  count=${1:-2}
  print -P %$count~
}

set_title_from_path() {
  printf "\033k`get_path_part $1`\033\\"
}


# Ctrl-z resumes app
foreground-vi() {
  fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi


# complete on words from current tmux buffer (using ctrl+x)
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  w=( ${(u)=$(tmux capture-pane \; show-buffer \; delete-buffer)} )
  _wanted values expl 'words from current tmux pane' compadd -a w
}

now() {
  echo $(date "+%Y-%m-%d %H:%M:%S") "|" $(get_path_part)  "|" "$@" >> $HOME/.now
}

git-php-lint() {
  for file in $(gss |cut -d ' ' -f3|grep php); php -l $file
}


git-php-cs-psr2() {
  for file in $(gss |cut -d ' ' -f3|grep php); php-cs-fixer fix $file
}

git-select-lint() {
  file=$(gss |cut -d ' ' -f3 | selecta); php -l $file
}

git-select-checkout() {
  file=$(gss |cut -d ' ' -f3 | selecta); git checkout $file
}


cg() {
    cd $GOPATH/src/github.com/$1;
}
compdef _files -W $GOPATH/src/github.com/ -/


emacsd() {
  CHECK=`ps aux|grep emacs|grep daemon|wc -l|bc`
  if [[ "$CHECK" == 0 ]]; then
    command emacs --daemon
  fi
}

emacsg() {
  emacsd
  command emacsclient -c &
}

emacs() {
  emacsd
  command emacsclient -t
}


alias nw="/Applications/node-webkit.app/Contents/MacOS/node-webkit"

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

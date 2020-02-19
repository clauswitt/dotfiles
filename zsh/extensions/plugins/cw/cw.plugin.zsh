TERM=screen-256color-bce
alias strace=dtruss
alias tc="~/Scripts/tmux-copy-session.sh"
alias editzsh='vim ~/.oh-my-zsh/plugins/cw/cw.plugin.zsh'
alias ez="editzsh"
alias theme="vim ~/.oh-my-zsh/themes/clauswitt.zsh-theme"
alias r="/usr/local/bin/r"

alias here='open . '
alias dup='open . -a "iTerm.app"'
alias deck='open -a "DeckSet.app"'

alias gas='git add `git status --short | selecta|cut -d " " -f2`'
alias gds='git diff `git status --short | selecta|cut -d " " -f2`'
alias cdz='cd `z |selecta|rev|cut -d " " -f1 | rev`'
alias pulls='hub browse -- pulls'
alias pr='hub pull-request'


alias cdg='cd "$(git rev-parse --show-toplevel)"'


tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then 
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

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


alias m=make
alias s=rspec

function mcd() { mkdir -p $1 && cd $1 }
function cdf() { cd *$1*/ }
#
# Switch projects
function p() {
    proj=$(find ~/Documents/Projects -type d -maxdepth 3 | selecta)
    if [[ -n "$proj" ]]; then
        cd $proj
    fi
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do; brew install $prog; done;
  fi
}

# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd);
    do; brew upgrade $prog; done;
  fi
}



# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

gsave() {
  local date=$(date +%Y-%m-%d)
  # Create a new branch (only one per day guys)
  git checkout -b SAVEPOINTS-$date
  # Add all files
  git add -A
  # Commit everything - skipping checks
  git commit -n -m "SAVEPOINT $date"
  # Force push
  git push origin $(git_current_branch) -f
}


# v - open files in ~/.viminfo
v() {
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}



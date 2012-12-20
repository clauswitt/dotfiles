# edit zsh settings (this file)
TERM=screen-256color-bce
WEBSERVER=root@josephcurwen.diginero.eu:/opt/sites
#alias tmux="TERM=screen-256color-bce tmux"
alias tls="tmux ls"
alias tk="tmux kill-session -t"
alias ta="tmux attach-session -t "
alias editzsh='vim ~/.oh-my-zsh/plugins/cw/cw.plugin.zsh'
alias ez="editzsh"
alias ezs='subl ~/.oh-my-zsh/plugins/cw/cw.plugin.zsh'
alias theme="vim ~/.oh-my-zsh/themes/clauswitt.zsh-theme"
alias themes="subl ~/.oh-my-zsh/themes/clauswitt.zsh-theme"
alias cw="ssh cw"
alias vd="vagrant destroy -f"
alias vu="vagrant up"
# alias for directories
alias sys='cd ~/Documents/Projects/SystemetProject/Systemet'
alias ssh="source ~/.auth_ssh; ssh"
alias git="source ~/.auth_ssh; git"
alias fpm='/usr/local/sbin/php-fpm '
# open browser
alias chrome='open -a "Google Chrome" '
alias canary='open -a "Google Chrome Canary" '
alias safari='open -a "Safari" '
alias firefox='open -a "Firefox" '
alias sp='subl `find . -maxdepth 1 -name "*.sublime-project"`'
alias yb='yeoman build'
alias yt='yeoman test'

# alias for project directory
alias p='~/Documents/Projects/'


#git aliases
alias clone='git clone'
alias gsts='git status --short'
alias c='git commit '

alias gd='git diff '
alias clean='git clean -f'
alias gl='git l'
alias cont='git rebase --continue'
alias skip='git rebase --skip'

alias push="ggpush"
alias pull="ggpull"

alias here='open . '
alias dot='cd ~/bin/dotfiles'


ci() {
  refName=`echo "$(current_branch)" | sed 's/\([A-Z-]*[0-9]*\).*/Refs #\1/'`
  git commit $@ -m "$refName" --edit
}

remain() {
  CURRENTBRANCH=$(git symbolic-ref HEAD | cut -d'/' -f3)
  if (( $# == 0 )) then
    REMOTE='origin'
    BRANCH='master'
  fi
  if (( $# == 1 )) then
    REMOTE='origin'
    BRANCH=$1
  fi
  if (( $# > 1 )) then
    REMOTE=$1
    BRANCH=$2
  fi
  git checkout $BRANCH && git pull $REMOTE $BRANCH && git checkout $CURRENTBRANCH && git rebase $BRANCH
}

memain() {
  CURRENTBRANCH=$(git symbolic-ref HEAD | cut -d'/' -f3)
  if (( $# == 0 )) then
    REMOTE='origin'
    BRANCH='master'
  fi
  if (( $# == 1 )) then
    REMOTE='origin'
    BRANCH=$1
  fi
  if (( $# > 1 )) then
    REMOTE=$1
    BRANCH=$2
  fi
  git checkout $BRANCH && git pull $REMOTE $BRANCH && git checkout $CURRENTBRANCH && git merge $BRANCH
}


#git function to add last parameter of last command via git add (used after a diff)
gal() {
  last_command=$history[$[HISTCMD-1]];
  last_command_array=("${(s/ /)last_command}")
  echo $last_command_array[-1];
  git add $last_command_array[-1];
}
vim() {
  if command -v mvim >/dev/null 2>&1; then
    mvim -v $@
  else
    /usr/bin/vim $@
  fi
}
#git function to checkout last parameter of last command via git checkout
gcl() {
  last_command=$history[$[HISTCMD-1]];
  last_command_array=("${(s/ /)last_command}")
  echo $last_command_array[-1];
  git checkout $last_command_array[-1];
}

_mux() {
  compadd `mux list|grep -v "tmuxinator" | sed -e 's/^[ \t]*//'`
}

reset() {
  git reset HEAD $1
}

#git function to run diff on a file
gdl() {
  git diff $1
}

#get autocomplete options for gdl command
_gitdiff () {
    compadd `git status --short |cut -d ' ' -f3`
}

_gitreset () {
  compadd `git status --short |cut -d ' ' -f3`
}

compdef _gitdiff gdl
compdef _gitreset reset
compdef _mux mux

#Minor git scripts
# remove remote branches
alias gr='~/Scripts/remove.sh'
# remove local branches
alias grl='~/Scripts/removeLocal.sh'
# list all local branches ordered by last commit
alias gbrt='~/Scripts/gbrt.rb'

alias impact="~/Scripts/impact.sh"

alias :e='vim'
alias :E='vim'
alias :q='exit'
alias :Q='exit'
alias :bd='clear'

alias coffeebone='yeoman init coffeebone'
alias rest='yeoman init coffeebone:rest'


acp() {
  git add $1
  c -m $2
  push
}

siteup() {
  d=`pwd`
  sitename=`basename $d`
  rsync -rv . $WEBSERVER/$sitename/
}

sitedown() {
  d=`pwd`
  sitename=`basename $d`
  rsync -rv $WEBSERVER/$sitename/ .
}

rsyncremote() {
  rsync -rv . $@
}


printjson() {
  cat $1 | pjson
}

remotejson() {
  curl $1 | pjson
}

mkp() {
  cd ~/Documents/Projects
  mkdir -p $1
  cd $1
  git init

}

clonep() {
  cd ~/Documents/Projects
  git clone $1 $2
  cd $2

}

createTmux() {
  projectName=$1
  basefile=~/.tmuxinator/.base.yml
  filename=~/.tmuxinator/$projectName.yml
  cp $basefile $filename
  vim $filename
}
# Setup default root paths
CDPATH=.:~/Documents/Projects:~/Documents/Projects/sites:~/Documents/Projects/SystemetProject:~/Documents/Projects/FLOW3/Packages/Application:~/Documents/Projects/FLOW3/Packages/Application/ArnsboMedia.VideoSystem.Tweaker/Resources/Public:
# Use vim text as default editor
EDITOR=vim
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

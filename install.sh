#!/bin/zsh
set -e
ROOT=${1:-~}

function main {
  update_git
  install_packages
}

function install_packages {
  install "tmuxinator"
  install "git/gitconfig" ".gitconfig"
  install "git/gitignore_global" ".gitignore_global"
  install "grunt"
  install "tmux/tmux.conf" ".tmux.conf"
  install "vim/vimrc" ".vimrc"
  install "vim/gvimrc" ".gvimrc"
  install "vim/dotvim" ".vim"
  install "zsh/oh-my-zsh/plugins/cw" ".oh-my-zsh/plugins/cw"
  install "zsh/oh-my-zsh/themes/clauswitt.zsh-theme" ".oh-my-zsh/themes/clauswitt.zsh-theme"
  install "zsh/zshrc" ".zshrc"
  install "Scripts" "Scripts"
}
function install() {
  TARGET=$ROOT/${2:-.$1}
  if [[ -e $TARGET ]]; then
    rm $TARGET
  fi
  ln -nfs $PWD/$1 $TARGET
}

function update_git {
  git submodule init
  git submodule update
}
main

#!/bin/zsh
set -e
ROOT=${1:-~}

function main {
  test -d "$ROOT/.config" || mkdir -p "$ROOT/.config"
  update_git
  install_packages
}

function install_packages {
  install "tmuxinator"
  install "ag/agignore" ".agignore"
  install "git/gitconfig" ".gitconfig"
  install "git/gitmessage" ".gitmessage"
  install "git/gitignore_global" ".gitignore_global"
  install "grunt"
  install "tmux/tmux.conf" ".tmux.conf"
  install "vim/vimrc" ".vimrc"
  install "vim/gvimrc" ".gvimrc"
  install "vim/dotvim" ".vim"
  install "zsh/oh-my-zsh/" ".oh-my-zsh"
  install "zsh/extensions/plugins/cw" ".oh-my-zsh/plugins/cw"
  install "zsh/extensions/themes/clauswitt.zsh-theme" ".oh-my-zsh/themes/clauswitt.zsh-theme"
  install "zsh/zshrc" ".zshrc"
  install "zsh/zshenv" ".zshenv"

  install "Scripts" "Scripts"

  install "ruby/gemrc" ".gemrc"
  install "bin" "bin"
  install "profile"
}
function install() {
  TARGET=$ROOT/${2:-.$1}
  if [[ -e $TARGET ]]; then
    rm -rf $TARGET
  fi
  ln -nfs $PWD/$1 $TARGET
}

function update_git {
  git submodule init
  git submodule update
}
main

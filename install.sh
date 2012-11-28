#!/bin/zsh
ROOT=${1:-~}

function install() {
  TARGET=$ROOT/${2:-.$1}
  if [[ -e $TARGET ]]; then
    rm $TARGET
  fi
  ln -nfs $PWD/$1 $TARGET
}

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

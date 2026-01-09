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
  install "git/gitmessage" ".gitmessage"
  install "git/gitignore_global" ".gitignore_global"
  install "tmux/tmux.conf" ".tmux.conf"
  install "tmux/dottmux" ".tmux"
  install "vim/vimrc" ".vimrc"
  install "vim/gvimrc" ".gvimrc"
  install "vim/dotvim" ".vim"
  install "zsh/oh-my-zsh/" ".oh-my-zsh"
  install "zsh/extensions/plugins/cw" ".oh-my-zsh/plugins/cw"
  install "zsh/extensions/themes/clauswitt.zsh-theme" ".oh-my-zsh/themes/clauswitt.zsh-theme"
  install "zsh/zshrc" ".zshrc"
  install "zsh/zshenv" ".zshenv"
  install "zsh/profile" ".profile"

  install "Scripts" "Scripts"

  install "ruby/gemrc" ".gemrc"
  install "ruby/irbrc" ".irbrc"
  install "bin" "bin"

  # Modern tools (.config)
  install "wezterm" ".config/wezterm"
  install "helix" ".config/helix"
  install "zed" ".config/zed"
  install "starship/starship.toml" ".config/starship.toml"
  install "spotify-player" ".config/spotify-player"
  install "aerospace" ".config/aerospace"
  install "karabiner" ".config/karabiner"
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

#!/bin/bash

if ! type "brew" > /dev/null; then
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew tap josegonzalez/homebrew-php
brew install php55

brew install tmux

# Install everything else
brew install ssh-copy-id
brew install nginx
brew install memcached
brew install phantomjs
brew install sox
brew install redis
brew install postgresql
brew install mongodb
brew install mysql
brew install ack
brew install git
brew install imagemagick
brew install ffmpeg
brew install node
brew install rename
brew install rhino
brew install tree
brew install webkit2png
brew install ag
brew install go --cross-compile-all
brew install reattach-to-user-namespace
brew install asciidoc
brew install fop
brew install qt
brew install graphviz
brew install qcachegrind
brew install haskell-platform
brew install rust
brew install erlang
brew install elixir
brew install scala
brew install leiningen

brew tap homebrew/science
brew install r

brew tap thoughtbot/formulae
brew install gitsh

brew tap jingweno/gh
brew install gh

brew install vim
brew linkapps

brew tap phinze/cask
brew install brew-cask

brew cask install iterm2
brew cask install charles
brew cask install skype
brew cask install virtualbox
brew cask install scrivener
brew cask install vlc
brew cask install omnifocus
brew cask install google-drive
brew cask install sequel-pro
brew cask install alfred
brew cask install concentrate
brew cask install rescuetime
brew cask install hipchat
brew cask install pckeyboardhack
brew cask install keyremap4macbook
brew cask install caffeine
brew cask install vagrant
brew cask install spotify
brew cask install google-chrome
brew cask install firefox
brew cask install send-to-kindle
brew cask install calibre









# Remove outdated versions from the cellar
brew cleanup

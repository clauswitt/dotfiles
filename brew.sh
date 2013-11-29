#!/bin/bash

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
brew install php54

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

brew install macvim --override-system-vim
brew linkapps

# Remove outdated versions from the cellar
brew cleanup

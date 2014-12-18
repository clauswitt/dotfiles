#!/bin/bash

if ! type "brew" > /dev/null; then
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install more recent versions of some OS X tools
brew tap homebrew/dupes

brew tap josegonzalez/homebrew-php
brew install go --cross-compile-all
brew tap mcuadros/homebrew-hhvm
brew install hhvm --HEAD
brew tap homebrew/science
brew tap thoughtbot/formulae
brew install gh

brew linkapps

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew tap dart-lang/dart
brew install dart
brew install dartium # if you build Dart client apps

brew bundle

apps=(
  dropbox
  firefox
  firefox-aurora
  google-chrome
  google-chrome-canary
  hazel
  atom
  mailbox
  iterm2
  charles
  skype
  virtualbox
  scrivener
  vlc
  omnifocus
  sequel-pro
  alfred
  concentrate
  rescuetime
  hipchat
  pckeyboardhack
  keyremap4macbook
  caffeine
  vagrant
  spotify
  send-to-kindle
  calibre
)


brew cask install --appdir="/Applications" ${apps[@]}


brew tap caskroom/fonts
# fonts
fonts=(
  font-m-plus
  font-clear-sans
  font-roboto
)

# install fonts
echo "installing fonts..."
brew cask install ${fonts[@]}





# Remove outdated versions from the cellar
brew cleanup

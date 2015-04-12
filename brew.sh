#!/bin/bash

if ! type "brew" > /dev/null; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install more recent versions of some OS X tools
brew tap homebrew/dupes

brew tap josegonzalez/homebrew-php brew install go --cross-compile-all brew tap mcuadros/homebrew-hhvm brew install hhvm --HEAD brew tap homebrew/science brew tap thoughtbot/formulae brew install gh

brew linkapps

brew tap dart-lang/dart brew install dart brew install dartium # if you build Dart client apps

brew bundle



# Remove outdated versions from the cellar
brew cleanup

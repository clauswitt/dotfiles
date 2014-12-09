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

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

brew tap josegonzalez/homebrew-php
binaries=(
  ack
  ant
  apple-gcc42
  asciidoc
  autoconf
  automake
  bash
  binutils
  binutilsfb
  boost
  boostfb
  boot2docker
  brew-cask
  bsdmake
  cairo
  chicken
  cloc
  cloog
  cloog-ppl015
  cloog018
  cmake
  ctags
  curl
  dnsmasq
  docbook
  docker
  doxygen
  elixir
  emacs
  emscripten
  erlang
  exiftool
  faac
  ffmpeg
  fish
  flac
  folly
  fontconfig
  fontforge
  fop
  freetype
  gcc
  gcc46
  gcc48
  gd
  gdb
  gdbm
  gettext
  gflags
  gfortran
  ghc
  git
  glew
  glfw3
  glib
  glm
  glog
  gmp
  gmp4
  gnupg
  graphviz
  grep
  harfbuzz
  haskell-platform
  html2text
  icu4c
  imagemagick
  imap-uw
  isl
  isl011
  jemallocfb
  jpeg
  lame
  leiningen
  libarchive
  libdwarf
  libelf
  libevent
  libeventfb
  libffi
  libgpg-error
  libksba
  libmemcached
  libmpc
  libmpc08
  libogg
  libpng
  libsndfile
  libssh2
  libtiff
  libtool
  libvorbis
  libxml2
  libxslt
  libyaml
  llvm
  lua
  lzo
  mackup
  mad
  mcrypt
  md5sha1sum
  memcached
  mercurial
  mhash
  mongodb
  mono
  mpfr
  mpfr2
  mysql
  mysql-connector-c++
  ncurses
  neovim
  nginx
  node
  normalize
  oniguruma
  openssl
  openvpn
  ossp-uuid
  pcre
  phantomjs
  php55
  pixman
  pkg-config
  postgresql
  ppl011
  python
  qcachegrind
  qt
  qt5
  re2c
  readline
  reattach-to-user-namespace
  redis
  rename
  rhino
  rust
  scala
  scons
  sdl
  sdl2
  sfml
  siege
  sox
  sqlite
  ssh-copy-id
  tbb
  texi2html
  the_silver_searcher
  tmux
  tree
  ttfautohint
  tuntap
  unixodbc
  valgrind
  vim
  webkit2png
  wget
  wxmac
  x264
  xmlstarlet
  xvid
  xz
  yasm
  yuicompressor
  zlib
  zsh
)
brew install go --cross-compile-all
brew tap mcuadros/homebrew-hhvm
brew install hhvm --HEAD
brew tap homebrew/science
brew install r
brew tap thoughtbot/formulae
brew install gitsh
brew tap jingweno/gh
brew install gh


brew linkapps

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew tap dart-lang/dart
brew install dart
brew install dartium # if you build Dart client apps

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

#!/usr/bin/env bash

# Install RVM
\curl -L https://get.rvm.io | bash -s stable

# Install some Rubies
source "$HOME/.rvm/scripts/rvm"
command rvm install 1.9.3,2.0.0,rbx,jruby

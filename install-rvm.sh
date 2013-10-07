#!/usr/bin/env bash

# Install RVM
\curl -L https://get.rvm.io | sudo bash -s stable

# Install some Rubies
source "/usr/local/rvm/scripts/rvm"
command rvm install 1.9.3,2.0.0,rbx,jruby

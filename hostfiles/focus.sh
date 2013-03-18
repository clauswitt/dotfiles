#!/bin/bash
rm /etc/hosts
cp /Users/clauswitt/bin/dotfiles/hostfiles/hosts /etc/
cat /Users/clauswitt/bin/dotfiles/hostfiles/hosts.focus >> /etc/hosts
cat /Users/clauswitt/bin/dotfiles/hostfiles/hosts.email >> /etc/hosts

#!/bin/bash
# setup myenv

pwd=`pwd`

if [ -f ~/.bashrc ]; then
  mv ~/.bashrc ~/.bashrc.orig
fi
cp $pwd/bashrc ~/.bashrc
chmod 644 ~/.bashrc
cp $pwd/gitconfig ~/.gitconfig
chmod 644 ~/.gitconfig

exit 0
#!/bin/bash
# setup myenv

pwd=`pwd`

mv ~/.bashrc ~/.bashrc.orig
cp $pwd/bashrc ~/.bashrc
chmod 644 ~/.bashrc
cp $pwd/gitconfig ~/.gitconfig
chmod 644 ~/.gitconfig

exit 0
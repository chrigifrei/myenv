#!/bin/bash
# setup myenv

pwd=`pwd`

mv ~/.bashrc ~/.bashrc.orig
cp $pwd/bashrc ~/.bashrc
cp $pwd/gitconfig ~/.gitconfig

exit 0
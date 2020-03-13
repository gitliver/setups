#!/bin/bash

# A script for installing programs on a new Mac
# 2020

echo "get dev tools (annoying)"
xcode-select --install

echo "*** install brew ***"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

for i in wget coreutils tmux youtube-dl imagemagick gpg python3 postgres ffmpeg tree htop datamash npm; do
	echo "*** install "${i}" ***"; 
	brew install ${i}; 
done

echo "*** install pip ***"
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py

echo "*** install python packages ***"
sudo pip install virtualenv
pip install Pygments
sudo pip3 install awscli --upgrade
pip3 install numpy
pip3 install scipy

echo
echo "Don't forget to download VLC, Office, Photoshop, Illustrator..."

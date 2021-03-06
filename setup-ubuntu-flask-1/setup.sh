#!/usr/bin/env bash

# Install packages for a flask app on a fresh Ubuntu AWS EC2 node

# the programs we want (flask needs python-dev build-essential)
mypackages="build-essential python-dev python-numpy git nginx htop sqlite3 libsqlite3-dev"
helpmessage="Install packages for a flask app on a fresh Ubuntu AWS EC2 node:\n\n\
${mypackages}\n\nRun from your home directory (as root):\n\
$0              # any other time you run it"

# go HOME
cd $HOME

# parse args
if [  "$1" == "-h" -o "$1" == "-help" -o "$1" == "--help" ]; then
        echo -e "$helpmessage"
        exit;
fi

echo "***update current system"
sudo apt-get update
echo

# install various programs
for i in $mypackages; do
        # apt-cache search $i
        # install automatically updates package even if installed
        echo "*** installing "$i && sudo apt-get install $i
        echo
done

# now that we have git, get my dotfiles
if git clone https://github.com/gitliver/.dotfiles.git 2> /dev/null; then
        echo
	# modify current bashrc
        echo >> .bashrc
        echo "source ~/.bash_profile" >> .bashrc
	# make links
        ln -s .dotfiles/.bash_profile
        ln -s .dotfiles/.tmux.conf
        ln -s .dotfiles/.vimrc
        ln -s .dotfiles/.gitconfig
        # should source .bashrc interactively since file protects sourcing via script:
        # "If not running interactively, don't do anything"
        echo "*** Please source your .bashrc"
        echo
fi

if ! which pip > /dev/null; then
        echo "*** installing pip"
        wget https://bootstrap.pypa.io/get-pip.py
        sudo python get-pip.py
fi

# install virtualenv
i=virtualenv
(echo "*** checking for "$i && which $i > /dev/null) || (echo "*** installing "$i && sudo pip install $i)

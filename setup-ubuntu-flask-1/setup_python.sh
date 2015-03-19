#!/usr/bin/env bash

# Install python packages for a flask app on a fresh Ubuntu AWS EC2 node

mypackages_python="uwsgi flask pandas numpy python-instagram"

# turn virtualenv on
# virtualenv venv
# source venv/bin/activate

# install Python packages
for i in $mypackages_python; do
        # get Python package if not installed
        # (echo "*** checking for "$i && which $i > /dev/null) || (echo "*** installing "$i && pip install $i)
        echo "*** installing "$i && pip install $i
        echo
done

# turn virtualenv off
# deactivate

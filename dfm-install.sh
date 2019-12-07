#!/bin/bash

dir=$(ls -AlF /home/$USER/.config | grep "dfm/")

if [[ "$dir" == "dfm/" ]]; then
    echo
    sleep 1
    echo "All Done..."
    echo
    exit
else
    pushd /home/$USER/.config/ &> /dev/null
    mkdir dfm/
    popd &> /dev/null
    sleep 1
    echo
    echo "All Done..."
    echo
    exit
fi

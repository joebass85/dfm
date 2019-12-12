#!/bin/bash

dir=$(ls -AF /home/$USER/.config/ | grep "dfm/")

if [[ "$dir" == "dfm/" ]]; then
    echo
    sleep 1
    echo "All Done..."
else
    pushd /home/$USER/.config/ &> /dev/null
    mkdir dfm/
    popd &> /dev/null
    sleep 1
    echo
    echo "All Done..."
fi

dir2=$(ls -AF /home/$USER/ | grep "bin/")

if [[ "$dir2" == "bin/" ]]; then
    echo
    echo "Copying dfm to /home/$USER/bin/dfm"
    cp dfm /home/$USER/bin/dfm
    sleep 1
    echo
    echo "All Done..."
else
    echo
    echo "Creating a /home/$USER/bin/ folder."
    echo
    mkdir /home/$USER/bin/
    echo "Copying dfm to /home/$USER/bin/dfm"
    cp dfm /home/$USER/bin/dfm
    echo
    echo "All Done..."
fi

term=$(awk '/export TERMINAL/ {print $2}' /home/$USER/.bashrc)

if [[ "$term" == "" ]]; then
    echo
    echo "Please define your terminal emulator in your ~/.bashrc file like this:"
    echo "  export TERMINAL=<your terminal emulator>"
else
    echo
    echo "All done..."
fi

edit=$(awk '/export EDITOR/ {print $2}' /home/$USER/.bashrc)

if [[ "$edit" == "" ]]; then
    echo
    echo "Please define your editor in your ~/.bashrc file like this:"
    echo "  export EDITOR=<your text editor>"
    echo
else
    echo
    echo "All done..."
    echo
fi

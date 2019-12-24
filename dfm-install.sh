#!/bin/bash

dir3=$(ls /usr/bin/ | grep dmenu)

if [[ "$dir3" == "" ]]; then
    echo
    echo "Please install dmenu."
    echo
    exit
fi

dir=$(ls /home/$USER/.config/ | grep "dfm/")

if [[ "$dir" == "dfm/" ]]; then
    echo
    echo "All Done..."
else
    pushd /home/$USER/.config/ &> /dev/null
    mkdir dfm/
    popd &> /dev/null
    echo
    echo "All Done..."
fi

dir2=$(ls /home/$USER/ | grep "bin/")

if [[ "$dir2" == "bin/" ]]; then
    echo
    pushd dfm &> /dev/null
    echo "Copying dfm to /home/$USER/bin/dfm"
    cp dfm /home/$USER/bin/dfm/
    popd &> /dev/null
    echo
    echo "All Done..."
else
    echo
    echo "Creating a /home/$USER/bin/ folder."
    echo
    pushd dfm &> /dev/null
    mkdir /home/$USER/bin/
    echo "Copying dfm to /home/$USER/bin/dfm"
    cp dfm /home/$USER/bin/
    popd &> /dev/null
    echo
    echo "All Done..."
fi

dir4=$(ls -A /home/$USER/.config/dfm | grep .bkmks)

if [[ "$dir4" == ".bkmks" ]]; then
	echo
	echo "All Done..."
else
	echo
	echo "Creating empty bookmarks file."
	echo
	pushd /home/$USER/.config/dfm &> /dev/null
	touch .bkmks
	popd &> /dev/null
	echo "All Done..."
fi

dir5=$(ls -AF /home/$USER/.config/dfm/ | grep "trash/")

if [[ "$dir5" == "trash/" ]]; then
	echo
	echo "All Done..."
else
	echo
	echo "Creating a trash folder at /home/$USER/.config/dfm/trash"
	echo
	pushd /home/$USER/.config/dfm/ &> /dev/null
	mkdir trash
	popd &> /dev/null
	echo "All Done..."
fi

term=$(awk '/export TERMINAL/ {print $2}' /home/$USER/.bashrc)

if [[ "$term" == "" ]]; then
    echo
    echo "Please define your terminal emulator in your ~/.bashrc file like this:"
    echo "  export TERMINAL=<your terminal emulator>"
fi

edit=$(awk '/export EDITOR/ {print $2}' /home/$USER/.bashrc)

if [[ "$edit" == "" ]]; then
    echo
    echo "Please define your editor in your ~/.bashrc file like this:"
    echo "  export EDITOR=<your text editor>"
    echo
fi

dir6=$(ls -AF /home/$USER/.config/dfm/ | grep .commhist)

if [[ "$dir6" == ".commhist" ]]; then
	echo
	echo "All Done..."
	echo
	echo "================================================="
	echo " Dfm has successfully been installed. Thank you!"
	echo "================================================="
	echo
else
	echo
	echo "Creating a command history file at /home/$USER/.config/dfm/.commhist"
	echo
	pushd /home/$USER/.config/dfm/ &> /dev/null
	touch .commhist
	popd &> /dev/null
	echo "All Done..."
	echo
	echo "================================================="
	echo " Dfm has successfully been installed. Thank you!"
	echo "================================================="
	echo
fi


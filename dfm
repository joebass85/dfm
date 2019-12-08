#!/bin/bash
# A dmenu-based file manager, written by Joe Diamond; email: jdiamond_11@comcast.net
# TERMINAL, EDITOR should be defined in ~/.bashrc like this:

# export TERMINAL=<your terminal name>
# export EDITOR=<editor name>

# Dependencies: dmenu, grep, awk, cut, terminal emulator, text editor

# Defining necessary variables not already defined.
currentdir=$('pwd')
ln=2000
genfont="Monospace-15"
version="1.0"

# Allows editing of files.
edit () {
    choice=$(ls -Ap $currentdir | grep -v "/" | dmenu -l $ln -i -p 'Pick a file to edit.' -fn $genfont)
    if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		    terminal=$(awk '/TERMINAL/ {print $2}' /home/$USER/.bashrc | cut -c 10-)
		    editor=$(awk '/EDITOR/ {print $2}' /home/$USER/.bashrc | cut -c 8-)
		    if [[ "$terminal" == "$terminal" ]]; then
				    $terminal -e $editor $choice
		    fi
    fi
    main
}

# Presents choices of available directories to cd into.
changed () {
    lsdir=$(ls -aF $currentdir | grep "/")
    choice=$(echo "$lsdir" | dmenu -l $ln -i -fn $genfont)
    if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		    cd $choice
    fi
    currentdir=$('pwd')
    main
}

# Lists storage of the current directory.
list () {
    ls -AF $currentdir | dmenu -l $ln -i -fn $genfont &> /dev/null
    main
}

# Moves specified file/directory to ~/.config/dfm/ to be held until the Clear Trash command is run.
trash () {
    lsdir=$(ls -AF $currentdir)
    choice=$(echo "$lsdir" | dmenu -l $ln -i -fn $genfont -p 'Remove which file?')
    if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		    mv -f $choice /home/$USER/.config/dfm/
    fi
    main
}

# Creates a new file or folder in the pwd.
newfd () {
    choice=$(echo '' | dmenu -fn $genfont -p 'Enter a filename and press Enter.')
    var=$(echo '' | dmenu -fn $genfont -i -p 'Is this a directory? [Y/N]')
    case "$var" in
			    Y|y) if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then mkdir $choice; fi;;
			    N|n) if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then touch $choice; fi;;
    esac
    main
}

# Removes the contents of ~/.config/dfm/
clstrash () {
    var=$(echo '' | dmenu -fn $genfont -i -p 'Are you sure? [Y/N]')
    case "$var" in
		    Y|y) rm -rf /home/$USER/.config/dfm/*;;
		    *) main;;
    esac
    main
}

# Copies the selected file/directory to the specified location.
copy () {
    choice=$(ls -Ap "$currentdir" | dmenu -l $ln -fn $genfont -i -p 'Pick a file to copy')
    name=$(echo '' | dmenu -fn $genfont -p 'Pick a name for the new file.')
    dir=$(echo '' | dmenu -fn $genfont -p 'Is the file being copied a directory?')
    case "$dir" in
		    Y|y) cp -R $choice $name;;
		    *) cp $choice $name;;
    esac
    main
}

# Moves the specified file/directory to the new location $path.
movefd () {
    choice=$(ls -AF "$currentdir" | dmenu -l $ln -fn $genfont -i -p 'Pick a file to move:')
    path=$(echo '' | dmenu -fn $genfont -i -p 'Give the absolute path to where you would like to move this file to')
    if [[ ! "$choice " == "" && "$choice" == "$choice" ]]; then
		    mv -f $choice $path
    fi
    main
}

# Main function for the program
main () {

items="Create a New File/Directory
Copy a File/Directory
Move a File/Directory
Remove a File/Directory
Edit a File
Change Directory
Clear Trash
List
Exit"

    selection=$(echo "$items" | dmenu -l $ln -i -p 'Select an action:' -fn $genfont)

    case "$selection" in
        "Create a New File/Directory") newfd;;
        "Change Directory") changed;;
        "Edit a File") edit;;
        List) list;;
        "Remove a File/Directory") trash;;
        "Clear Trash") clstrash;;
        "Copy a File/Directory") copy;;
        "Move a File/Directory") movefd;;
        Exit) exit;;
    esac
}

main

if [[ "$1" == "-v" ]]; then
	echo $version
	exit
fi

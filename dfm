#!/bin/bash
# A dmenu-based file manager, written by Joe Diamond; email: jdiamond_11@comcast.net
# TERMINAL, EDITOR should be defined in ~/.bashrc like this:

# export TERMINAL=<your terminal name>
# export EDITOR=<editor name>

# Dependencies: dmenu, grep, awk, cut, terminal emulator, text editor

# Defining necessary variables not already defined.
currentdir=$('/usr/bin/pwd')
ln=40
genfont="Monospace-15"

# Allows editing of files.
edit () {
    choice=$(/usr/bin/ls -Ap $currentdir | /usr/bin/grep -v "/" | dmenu -l $ln -i -p 'Pick a file to edit.' -fn $genfont)
    if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		    terminal=$(/usr/bin/awk '/TERMINAL/ {print $2}' /home/$USER/.bashrc | /usr/bin/cut -c 10-)
		    editor=$(/usr/bin/awk '/EDITOR/ {print $2}' /home/$USER/.bashrc | /usr/bin/cut -c 8-)
		    $terminal -e $editor $choice
    fi
    main
}

# Presents choices of available directories to cd into.
changed () {
    lsdir=$(/usr/bin/ls -aF $currentdir | /usr/bin/grep "/")
    choice=$(/usr/bin/echo "$lsdir" | dmenu -l $ln -i -fn $genfont -p "Current directory is: $currentdir")
    if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		    cd $choice
		fi
    currentdir=$('/usr/bin/pwd')
    main
}

# Lists storage of the current directory.
list () {
    /usr/bin/ls -AF $currentdir | dmenu -l $ln -i -fn $genfont -p "Contents of: $currentdir" &> /dev/null
    main
}

# Moves specified file/directory to ~/.config/dfm/ to be held until the Clear Trash command is run.
trash () {
    lsdir=$(/usr/bin/ls -AF $currentdir)
    choice=$(/usr/bin/echo "$lsdir" | dmenu -l $ln -i -fn $genfont -p 'Remove which file?')
    if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		    /usr/bin/mv -f $choice /home/$USER/.config/dfm/
    fi
    main
}

# Creates a new file or folder in the pwd.
newfd () {
    choice=$(/usr/bin/echo '' | dmenu -fn $genfont -p 'Enter a filename and press Enter.')
    var=$(/usr/bin/echo '' | dmenu -fn $genfont -i -p 'Is this a directory? [Y/N]')
    case "$var" in
			    Y|y) if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then /usr/bin/mkdir $choice; fi;;
			    N|n) if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then /usr/bin/touch $choice; fi;;
    esac
    main
}

# Removes the contents of ~/.config/dfm/
clstrash () {
    var=$(/usr/bin/echo '' | dmenu -fn $genfont -i -p 'Are you sure? [Y/N]')
    case "$var" in
		    Y|y) /usr/bin/rm -rf /home/$USER/.config/dfm/*;;
		    *) main;;
    esac
    main
}

# Copies the selected file/directory to the specified location.
copy () {
    choice=$(/usr/bin/ls -Ap "$currentdir" | dmenu -l $ln -fn $genfont -i -p 'Pick a file to copy')
    name=$(/usr/bin/echo '' | dmenu -fn $genfont -p 'Pick a name for the new file.')
    dir=$(/usr/bin/echo '' | dmenu -fn $genfont -p 'Is the file being copied a directory?')
    case "$dir" in
		    Y|y) /usr/bin/cp -R $choice $name;;
		    *) /usr/bin/cp $choice $name;;
    esac
    main
}

# Moves the specified file/directory to the new location $path.
movefd () {
    choice=$(/usr/bin/ls -AF "$currentdir" | dmenu -l $ln -fn $genfont -i -p 'Pick a file to move:')
    path=$(/usr/bin/echo '' | dmenu -fn $genfont -i -p 'Give the absolute path to where you would like to move this file to')
    if [[ ! "$choice " == "" && "$choice" == "$choice" ]]; then
		    /usr/bin/mv -f $choice $path
    fi
    main
}

# Allows the user to execute terminal commands; Good for compiling files after editing, but not for things like ls
execute () {
	terminal=$(/usr/bin/awk '/TERMINAL/ {print $2}' /home/$USER/.bashrc | /usr/bin/cut -c 10-)
	comm=$(/usr/bin/echo '' | dmenu -fn $genfont -i -p 'Execute which command?')
	if [[ ! "$comm" == "" && "$comm" == "$comm" ]]; then
		$terminal -e $comm 2> /dev/null
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
Command
List
Exit"

selection=$(/usr/bin/echo "$items" | dmenu -l $ln -i -p 'Select an action:' -fn $genfont)

	case "$selection" in
		"Create a New File/Directory") newfd;;
		"Change Directory") changed;;
		"Edit a File") edit;;
		List) list;;
		"Remove a File/Directory") trash;;
		"Clear Trash") clstrash;;
		"Copy a File/Directory") copy;;
		"Move a File/Directory") movefd;;
		Command) execute;;
		Exit) exit;;
	esac
}

main

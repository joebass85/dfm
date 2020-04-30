#!/bin/bash
# A dmenu-based file manager, written by Joe Diamond; email: jdiamond_11@comcast.net
# TERMINAL, EDITOR should be defined in ~/.bashrc like this:

# export TERMINAL=<your terminal name>
# export EDITOR=<editor name>

# Dependencies: dmenu, grep, awk, cut, uniq, tail, terminal emulator, text editor

# Defining necessary variables not already defined.
currentdir=$('pwd')
ln=40
genfont="Monospace-15"
ver="1.1"
terminal=$(awk '/export TERMINAL/ {print $2}' /home/$USER/.bashrc | cut -c 10-)
editor=$(awk '/export EDITOR/ {print $2}' /home/$USER/.bashrc | cut -c 8-)

# Allows editing of files.
edit () {
	choice=$(ls -Ap $currentdir | grep -v "/" | dmenu -l $ln -p 'Pick a file to edit.' -fn $genfont)
	if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		if [[ "$editor" == "vim" || "$editor" == "nano" || "$editor" == "vi" ]]; then
			# edit this command if your terminal does not use the -e option to execute commands
			$terminal -e $editor $choice &> /dev/null
		else
			$editor $choice &> /dev/null
		fi
	fi
	main
}

# Presents choices of available directories to cd into.
changed () {
	lsdir=$(ls -aF $currentdir | grep "/")
	choice=$(echo "$lsdir" | dmenu -l $ln -fn $genfont -p "Current directory is $currentdir:")
	if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then
		cd $choice
		currentdir=$('pwd')
	fi
	main
}

# Lists storage of the current directory.
list () {
	ls -AF $currentdir | dmenu -l $ln -i -fn $genfont -p "Contents of $currentdir:" &> /dev/null
	main
}

# Moves specified file/directory to ~/.config/dfm/ to be held until the Clear Trash command is run.
trash () {
	lsdir=$(ls -AF $currentdir)
	choice=$(echo "$lsdir" | dmenu -l $ln -fn $genfont -p 'Remove which file?')
	var=$(echo '' | dmenu -fn $genfont -i -p 'Are you sure? [Y/N]')
	case "$var" in
		Y|y) if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then mv -f $choice /home/$USER/.config/dfm/trash/; fi;;
		*) main;;
	esac
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

# Removes the contents of ~/.config/dfm/trash/
clstrash () {
	var=$(echo '' | dmenu -fn $genfont -i -p 'Are you sure? [Y/N]')
	case "$var" in
		Y) rm -rf /home/$USER/.config/dfm/trash/*;;
		*) main;;
	esac
	main
}

# Copies the selected file/directory to the specified location.
copy () {
	choice=$(ls -Ap "$currentdir" | dmenu -l $ln -fn $genfont -p 'Pick a file to copy')
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
	choice=$(ls -AF "$currentdir" | dmenu -l $ln -fn $genfont -p 'Pick a file to move:')
	path=$(echo '' | dmenu -fn $genfont -p 'Give the absolute path to where you would like to move this file to')
	if [[ ! "$choice " == "" && "$choice" == "$choice" ]]; then mv -f $choice $path; fi
	main
}

# Allows the user to execute terminal commands; Good for compiling files after editing, but not for things like ls
execute () {
	comm=$(echo '' | dmenu -fn $genfont -i -p 'Execute which command?')
	if [[ ! "$comm" == "" && "$comm" == "$comm" ]]; then
		echo $comm >> /home/$USER/.config/dfm/.commhist
		# also change this command if your terminal does not use the -e option to execute commands
		$terminal -e $comm
	fi
	main
}

# Allows user to view permissions of a file.
fperm () {
	choice=$(ls -AF "$currentdir" | grep -v "/" | dmenu -l $ln -fn $genfont -p 'Pick a file to view permissions:')
	ls -la $choice | dmenu -fn $genfont -l 1 &> /dev/null
	main
}

# Allows the user to view the contents of /home/$USER/.config/dfm/trash
viewtrash () {
	ls -A /home/$USER/.config/dfm/trash | dmenu -l $ln -fn $genfont -p 'Deleted Files:' &> /dev/null
	main
}

# Set current directory as a bookmark
bkmk () {
	bkmk="/home/$USER/.config/dfm/.bkmks"
	currentdir=$('pwd')
	echo $currentdir >> $bkmk
}

# View all bookmarks set in /home/$USER/.config/dfm/.bkmks
viewbkmk () {
	bkmk=$(cat /home/$USER/.config/dfm/.bkmks)
	echo "$bkmk" | uniq | dmenu -l $ln -fn $genfont -p 'Bookmarked Folders:' &> /dev/null
}

# Clears out any previously set bookmarks
clsbkmk () {
	choice=$(echo '' | dmenu -p "Are you sure? [Y/N]" -fn $genfont)
	case "$choice" in
		Y) rm /home/$USER/.config/dfm/.bkmks; touch /home/$USER/.config/dfm/.bkmks;;
		*) bkmks;;
	esac
}

# Allows the user to change to a specified bookmark
chbkmk () {
	bkmk=$(cat /home/$USER/.config/dfm/.bkmks)
	choice=$(echo "$bkmk" | uniq | dmenu -l $ln -fn $genfont -p 'Pick a bookmark to change to:')
	if [[ ! "$choice" == "" && "$choice" == "$choice" ]]; then cd $choice; fi
	currentdir=$('pwd')
}

# Bookmark function that displays a submenu just for bookmarks
bkmks () {
	items="Bookmark This Folder
View Bookmarks
Clear Bookmarks
Change to Bookmark
Return to Main Menu"

	choice=$(echo "$items" | dmenu -i -l $ln -fn $genfont -p 'Select an Action:')
	case "$choice" in
		"Bookmark This Folder") bkmk; bkmks;;
		"View Bookmarks") viewbkmk; bkmks;;
		"Clear Bookmarks") clsbkmk; bkmks;;
		"Change to Bookmark") chbkmk; bkmks;;
		"Return to Main Menu") main;;
		*) bkmks;;
	esac
}

# View Command History (only last 10 commands)
vcomm () {
	tail /home/$USER/.config/dfm/.commhist | dmenu -l $ln -fn $genfont -p 'Last 10 Commands:' &> /dev/null
	main
}

#Clear Command list
ccomm () {
	choice=$(echo '' | dmenu -fn $genfont -p 'Are you sure? [Y/N]')
	case "$choice" in
		Y) rm /home/$USER/.config/dfm/.commhist; touch /home/$USER/.config/dfm/.commhist;;
		*) main;;
	esac
	main
}

# Adds some helpful documentation inside of the script.
helper () {
	less << _EOF_
DFM
A dmenu-based, no extra dependencies file manager.
Written by Joe Diamond, email: jdiamond_11@comcast.net

What is DFM?
DFM is a dmenu-based, no extra dependencies file manager. It seeks to provide a simple, clean interface for your files without all of the heaviness of a traditional GUI file manager.

Dependencies
The only dependency needed is dmenu (which I consider an essential program, not a dependency).
Every other tool the script uses is supplied by the standard GNU Utilites package, along with your distribution's terminal emulator and a text editor of some sort (be it vim, nano, leafpad, etc.).

How to Customize DFM
There are built-in functions that are not enabled by default in DFM. You can enable them by adding the function name from the case statement to the items array in the main function of the script (at the bottom). Then, reload dfm to enable them.
As of Dec. 23, 2019, the disabled fucnctions include:

- Command
- View File Permissions
- View Trash
- Bookmarks
- View Command History

Notes
- DFM will not delete/move any files owned by other users/root user.
- Move can also be used to rename files.

Command Options
-v or --version --> returns the version number.
-h or --help --> returns this help section.
-vh or -hv --> returns both the version number and help section.

_EOF_
}

# Main function for the program
main () {

# Add disabled function names here from the case statement below.
items="Create a New File/Directory
Remove a File/Directory
Copy a File/Directory
Move a File/Directory
Change Directory
Edit a File
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
	Command) execute;;
	Bookmarks) bkmks;;
	"View File Permissions") fperm;;
	"View Trash") viewtrash;;
	"View Command History") vcomm;;
	"Clear Command History") ccomm;;
	Exit) exit;;
	*) main;;
esac
}

# Argument Handling
if [[ "$1" != "" ]];then
	while [[ "$1" != "" ]]; do
		case "$1" in
			-v | --version) shift;echo "	Version $ver";;
			-h | --help) shift;helper;;
			-hv | -vh) shift;helper; echo "	Version $ver";;
			*) echo "Not a valid argument.";exit;;
		esac
	done
else
	main
fi

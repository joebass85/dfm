# dfm
A dmenu-based, no extra dependencies file manager

## What is dfm?
Dfm is a dmenu-based, no extra dependencies file manager. It seeks to provide a simple, clean interface for your files without all of the heaviness of a traditional GUI file manager.

## How to set up dfm
At the bottom of your `~/.bashrc` file, add the following commands: `export TERMINAL=<your terminal emulator>` and `export EDITOR=<your favorite editor>`. Save and exit the file and relaunch the terminal. `cd` into the dfm directory and run `./dfm`.

## Dependencies
The only dependency needed is dmenu (which I consider an essential program). Every other tool the script uses is supplied by the standard GNU Utilites package, along with your distrobution's terminal emulator and a text editor of some sort (be it vim, nano, leafpad, etc.)

# dfm
A dmenu-based, no extra dependencies file manager

## What is dfm?
Dfm is a dmenu-based, no extra dependencies file manager. It seeks to provide a simple, clean interface for your files without all of the heaviness of a traditional GUI file manager.

## How to set up dfm
At the bottom of your `~/.bashrc` file, add the following commands: `export TERMINAL=<your terminal emulator>` and `export EDITOR=<your favorite editor>`. Save and exit the file and relaunch the terminal. `cd` into the dfm directory and run `./dfm`.

On my setup, my `.bashrc` file looks like this:
  `export TERMINAL=st``\n`
  `export EDITOR=vim`

## Dependencies
The only dependency needed is `dmenu` (which I consider an essential program and not a dependency). 
Every other tool the script uses is supplied by the standard GNU Utilites package, along with your distribution's terminal emulator and a text editor of some sort (be it vim, nano, leafpad, etc.)

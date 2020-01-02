# DFM
A dmenu-based, no extra dependencies file manager.
Written by Joe Diamond, email: jdiamond_11@comcast.net

## What is DFM?
DFM is a dmenu-based, no extra dependencies file manager. It seeks to provide a simple, clean interface for your files without all of the heaviness of a traditional GUI file manager.

## How to set up DFM
Run the `dfm-install.sh` script to setup DFM.

## Dependencies
The only dependency needed is `dmenu` (which I consider an essential program, not a dependency).
Every other tool the script uses is supplied by the standard GNU Utilites package, along with your distribution's terminal emulator and a text editor of some sort (be it vim, nano, leafpad, etc.).

## How to Customize DFM
There are built-in functions that are not enabled by default in DFM. You can enable them by adding the function name from the case statement to the `items` array in the main function of the script (at the bottom). Then, reload `dfm` to enable them.
As of Dec. 23, 2019, the disabled fucnctions include:
```
- Command
- View File Permissions
- View Trash
- Bookmarks
- View Command History
```

## Notes
- DFM will not delete/move any files owned by other users/root user.
- Move can also be used to rename files.

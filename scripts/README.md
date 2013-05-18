# patterns-shell/scripts

**patterns-shell/scripts** - Scripts for common shell tasks

## history
Persistent shell history with advanced search

Source `history.sh` in your .\*rc file.

Then you will have access to these three functions:
* **gh** [pattern]
  * Search history for pattern
* **dh** [pattern]
  * Show history of commands in this directory and subdirectories and optionally filter with pattern
* **ldh** [pattern]
  * Show history of commands in this directory only and optionally filter with pattern

## untar
Untar and unzip archives

Source `untar.sh` in your .\*rc file.

Then you will have access to these two functions:
* **untar** *\*tar.gz*
  * Creates a directory named after the archive without the \*.tar.gz extension.  
    Overwrites any previous directory.
* **unzip** *\*gz*
  * Unzips the archive to the file with the same name without the \*.gz extension.  
    Overwrites any previous file.

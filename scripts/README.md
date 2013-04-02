# patterns-shell/scripts

**patterns-shell/scripts** - Scripts for common shell tasks

## untar
Untar and unzip archives

Source `untar.sh` in your .*rc file.

Then you will have access to these two functions:
* **untar** *\*tar.gz*
  * Creates a directory named after the archive without the *.tar.gz extension.  
    Overwrites any previous directory.
* **unzip** *\*gz*
  * Unzips the archive to the file with the same name without the *.gz extension.  
    Overwrites any previous file.

# patterns-shell/scripts

**patterns-shell/scripts** - Scripts for common shell tasks

## autoscreen
Automatically start a GNU screen session without inception

Source this file at the very end of your .*rc file.  When you start your
shell, you will be notified that you are about to enter a screen session
(^C to cancel).  When your screen session ends, you will be notified that
your shell will exit (^C to cancel).

## pgdb
Manage PostgreSQL databases

Source pgdb.sh and then use templates/pgdb.sh (automatically sourced)
to generate your custom database management functions.

## remote
Manage connections to remotes via SSH and SCP

Source remote.sh and then use templates/remote.sh (automatically sourced)
to generate your custom remote management functions.

## untar
Untar and unzip archives

Two functions:
* **untar** *\*tar.gz*
  * Creates a directory named after the archive without the *.tar.gz extension.  
    Overwrites any previous directory.
* **unzip** *\*gz*
  * Unzips the archive to the file with the same name without the *.gz extension.  
    Overwrites any previous file.

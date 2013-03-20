# patterns-shell/scripts

**patterns-shell/scripts** - Scripts for common shell tasks

## autoscreen
Automatically start a GNU screen session without inception

Source `autoscreen.sh` at the very **END** of your .*rc file.

When you start your shell, you will be notified that you are about to enter
a screen session (^C to cancel).  When your screen session ends, you will be
notified that your shell will exit (^C to cancel).

## pgdb
Manage PostgreSQL databases

Source `pgdb.sh` in your .*rc file.

Then use `template-db` and `template-dbbackup`
in `../templates/pgdb.sh` (automatically sourced)
to generate your custom database management functions.

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

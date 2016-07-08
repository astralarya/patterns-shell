# patterns-shell/scripts

**patterns-shell/scripts** - Scripts for common shell tasks


## autoscreen

Automatically start GNU screen without inception

Source `autoscreen.sh` at the END of your .\*rc file.

See https://github.com/autochthe/autoscreen


## clip

Simplified access to xclip

Source `clip.sh` in your .\*rc file.

Then you will have access to the following functions:
* **cb** [TEXT...]
  * If pipe on STDIN, copy incoming data to the clipboard,
    else if TEXT is not empty, copy TEXT to the clipboard,
    else outputs the current contents of the clipboard on STDOUT.
* **cbf** FILES...
  * Copies the contents of FILE to the clipboard.
* **cbssh**
  * Copies current users SSH public key to the clipboard.
* **cbwd**
  * Copies current working directory to the clipboard.
* **cbhs**
  * Copies most recent command to the clipboard.


## history

Persistent shell history with advanced search

Source `history.sh` in your .\*rc file.

See https://github.com/autochthe/history


## prompt

Pretty bash prompt that colors fields and displays customizable command output.

Source `prompt.sh` in your .\*rc file.

See https://github.com/autochthe/prompt


## seek

Search current directory for files and folders

Source `seek.sh` in your .\*rc file.

See https://github.com/autochthe/seek


## to

Bookmark directory locations in POSIX-like systems with tab completion

Source `to.sh` in your .\*rc file.

See https://github.com/autochthe/to


## trace

Log and monitor commands

Add `patterns-shell/scripts` to your `PATH`.

Then you will have access to the following function:
* **trace** [*COMMAND...*]
  * Runs COMMAND recording the environment, return status, and runtime.
    If STDOUT and STDERR are redirected to the same location (for example,
    when using `&>`), output is automatically echoed to the terminal.


## untar

Untar and unzip archives

Add `patterns-shell/scripts` to your `PATH`.

Then you will have access to these two functions:
* **untar** *\*tar.gz*
  * Creates a directory named after the archive without the \*.tar.gz extension.  
    Overwrites any previous directory.
* **unzip** *\*gz*
  * Unzips the archive to the file with the same name without the \*.gz extension.  
    Overwrites any previous file.

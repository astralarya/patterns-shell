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


## prompt

Pretty bash prompt that colors fields and displays custom command output.

Source `prompt.sh` in your .\*rc file.

The prompt also outputs the result of `PS1_COMMAND`, suppressing any error messages.  By default, this is 'git status -sb' if git is present.

You can change the colors used in the prompt by adjusting the following environment variables:

* `PS1_USER_COLOR` - username color
* `PS1_HOST_COLOR` - hostname color
* `PS1_PATH_COLOR` - path color
* `PS1_STATUS_GOOD_COLOR` - status color when 0
* `PS1_STATUS_BAD_COLOR` - status color when not 0
* `PS1_PROMPT_COLOR` - prompt symbol color
* `PS1_COMMAND_COLOR` - color of the output of the `PS1_COMMAND`


## randpw

Generate random passwords

Source `randpw.sh` in your .\*rc file.

Then you will have access to these two functions:
* **randpw**
  * Creates a SHA256 hash of /dev/urandom output.
* **randpw-strong**
  * Creates a SHA512 hash of /dev/random output.  
    Note that this may block for a long time.


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

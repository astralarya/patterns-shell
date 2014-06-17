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

![Prompt Screenshot](https://autochthe.github.io/images/patterns-shell/prompt.png)

```
USER@HOST:DIRECTORY (COMMAND STATUS)
[ACTIVE JOBS]
[PS1_COMMAND OUTPUT]
$ █
```

The prompt outputs the STDOUT of executing `$PS1_COMMAND`.
If `git` is installed, this defaults to `git rev-parse HEAD && git status -sb`.
You may adjust this at any time by changing the value of this variable.

You can change the colors used in the prompt at any time by adjusting the following environment variables:

* `$PS1_PROMPT_COLOR` - prompt symbol color; default `0;32;40` (green)
* `$PS1_USER_COLOR` - username color; default `0;31;40` (red)
* `$PS1_HOST_COLOR` - hostname color; default `0;35;40` (purple)
* `$PS1_PATH_COLOR` - path color; default `0;34;40` (blue)
* `$PS1_STATUS_GOOD_COLOR` - status color when 0; default `0;32;40` (green)
* `$PS1_STATUS_BAD_COLOR` - status color when not 0; default `0;31;40` (red)
* `$PS1_JOB_COLOR` - jobs list color; default `0;33;40` (yellow)
* `$PS1_COMMAND_COLOR` - color of the output of `$PS1_COMMAND`; default `$PS1_PROMPT_COLOR`

Note that only the numerical protion of the color code is necessary.
For more information on terminal colors, see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html


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

Source `trace.sh` in your .\*rc file.

Then you will have access to the following functions:
* **trace** [*COMMAND...*]
  * Runs COMMAND recording the environment, return status, and runtime.
    If STDOUT and STDERR are redirected to the same location (for example,
    when using `&>`), output is automatically echoed to the terminal.


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

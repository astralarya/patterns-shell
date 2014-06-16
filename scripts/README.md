# patterns-shell/scripts

**patterns-shell/scripts** - Scripts for common shell tasks


## history

Persistent shell history with advanced search

Source `history.sh` in your .\*rc file.

Then you will have access to these three functions:
* **gh** [*TIMESPEC*] [*SEARCH*]
  * Search history for pattern
* **dh** [*TIMESPEC*] [*SEARCH*]
  * Show history of commands in this directory and subdirectories and optionally filter with pattern
* **ldh** [*TIMESPEC*] [*SEARCH*]
  * Show history of commands in this directory only and optionally filter with pattern

TIMESPEC is an argument of the form "[START..END]", (note the square brackets)
where START and END are strings understood by `date`.  
SEARCH is a regular expression understood by `gawk`.



## prompt

Pretty bash prompt that colors fields and displays customizable command output.

Source `prompt.sh` in your .\*rc file.

The resulting prompt looks like the following (bracketed fields displayed conditionally):

```
USER@HOST:DIRECTORY (COMMAND STATUS)
[ACTIVE JOBS]
[PS1_COMMAND OUTPUT]
$ █
```

The prompt outputs the result of executing `$PS1_COMMAND`, suppressing any error messages.
By default, this is `git rev-parse HEAD && git status -sb` if git is installed,
but may be adjusted at any time by changing the value of this variable.

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

Screenshot:

![Prompt Screenshot](https://autochthe.github.io/images/patterns-shell/prompt.png)


## trace

Log and monitor commands

Source `trace.sh` in your .\*rc file.

Then you will have access to the following functions:
* **trace** *LOGFILE*  [*COMMAND...*}
  * Runs COMMAND asynchronously piping output to LOGFILE and
    streams LOGFILE via `less`. Also records return status
    and runtime.



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

# prompt
# Pretty bash prompt
#
# Copyright (C) 2013 Mara Kim
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see http://www.gnu.org/licenses/.


### USAGE ###
# Source this file in your shell's .*rc file

if [ -z "$PS1_COMMAND" ] && command -v git &> /dev/null
then
      PS1_COMMAND='(git rev-parse HEAD && git status -sb) || (hg identify --branch --id && hg status -q)'
fi

if [ -z "$PS1_PROMPT_COLOR" ]
then
    PS1_PROMPT_COLOR='0;32;40'
fi

if [ -z "$PS1_USER_COLOR" ]
then
    PS1_USER_COLOR='0;31;40'
fi

if [ -z "$PS1_HOST_COLOR" ]
then
    PS1_HOST_COLOR='0;35;40'
fi

if [ -z "$PS1_PATH_COLOR" ]
then
    PS1_PATH_COLOR='0;34;40'
fi

if [ -z "$PS1_STATUS_GOOD_COLOR" ]
then
    PS1_STATUS_GOOD_COLOR='0;32;40'
fi

if [ -z "$PS1_STATUS_BAD_COLOR" ]
then
    PS1_STATUS_BAD_COLOR='0;31;40'
fi

if [ -z "$PS1_JOB_COLOR" ]
then
    PS1_JOB_COLOR='0;33;40'
fi

if [ -z "$PS1_COMMAND_COLOR" ]
then
    PS1_COMMAND_COLOR="$PS1_PROMPT_COLOR"
fi

# track jobs
PROMPT_COMMAND='_JOBS="$(jobs)";'"${PROMPT_COMMAND}"

PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[${PS1_USER_COLOR}m\]\u\[\033[${PS1_HOST_COLOR}m\]@\h\[\033[${PS1_PATH_COLOR}m\]:\w $(STATUS=$?; if [ $STATUS = 0 ]; then printf \[\033[%bm\]\(%b\) $PS1_STATUS_GOOD_COLOR $STATUS; else printf \[\033[%bm\]\(%b\) $PS1_STATUS_BAD_COLOR $STATUS; fi)$(if [ "$_JOBS" ]; then awk "{printf \"\[\033[0m\]\\n\[\033[${PS1_JOB_COLOR}m\]%s\",\$0}" <<<"$_JOBS"; fi)$(eval "$PS1_COMMAND" 2> /dev/null | awk "{printf \"\[\033[0m\]\\n\[\033[${PS1_COMMAND_COLOR}m\]%s\",\$0}")\[\033[0m\]\n\[\033[${PS1_PROMPT_COLOR}m\]\$\[\033[0m\] '
PS2='\[\033[${PS1_PROMPT_COLOR}m\]>\[\033[0m\] '

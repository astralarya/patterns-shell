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

if [ -z "$PS1_USER_COLOR" ]
then
    PS1_USER_COLOR='\[\033[0;31;40m\]'
fi

if [ -z "$PS1_HOST_COLOR" ]
then
    PS1_HOST_COLOR='\[\033[0;35;40m\]'
fi

if [ -z "$PS1_PATH_COLOR" ]
then
    PS1_PATH_COLOR='\[\033[0;34;40m\]'
fi

if [ -z "$PS1_PROMPT_COLOR" ]
then
    PS1_PROMPT_COLOR='\[\033[0;32;40m\]'
fi

if [ -z "$PS1_COMMAND" ] && hash git &> /dev/null
then
    PS1_COMMAND='git status -sb'
fi

PS1_COMMAND_CLEAN="\$(awk '{printf \"\\[\\033[0m\\]\\\\n$PS1_PROMPT_COLOR%s\",\$0}' <(\$PS1_COMMAND 2> /dev/null) )"
PS1="\\[\\e]0;\\u@\\h: \\w\\a\\]\${debian_chroot:+(\$debian_chroot)}$PS1_USER_COLOR\\u$PS1_HOST_COLOR@\\h$PS1_PATH_COLOR:\\w$PS1_PROMPT_COLOR (\$?)$PS1_COMMAND_CLEAN\\[\\033[0m\\]\n$PS1_PROMPT_COLOR\\$\\[\\033[0m\\] "
PS2="$PS1_PROMPT_COLOR>\\[\\033[0m\\] "

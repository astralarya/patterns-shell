# seek
# Search directories for file
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

# search using find
function seek {
    # read arguments
    local option
    local op_cd
    local input
    local rawinput
    local state
    local appender
    appender='('
    for arg in "$@"
    do
        if [ "$state" = "input" ]
        then
            input+=("$appender" -name "*$arg*")
            rawinput+=("$arg")
            appender='-o'
        elif [ "$arg" = "-h" -o "$arg" = "--help" ]
        then
            \printf 'Usage: seek [OPTION] [PATTERN]
Search the current directory and any children for files matching PATTERN
  Option	Meaning
  -, -cd, -to	Change current directory to the lowest unambiguous directory containing all matches
  -h		Show help
'
            return 0
        elif [ "$arg" = "--" ]
        then
            state="input"
        elif [ -z "${arg/-*/}" ]
        then
            if [ "$arg" = "-" -o "$arg" = "-cd" -o "$arg" = "-to" ]
            then
                op_cd="1"
            else
                option+=("$arg")
                \printf 'Ignored option: %q\n' "$arg"
            fi
        else
            input+=("$appender" -name "*$arg*")
            rawinput+=("$arg")
            appender='-o'
        fi
    done

    # search using find, no parameters
    if [ -z "$input" ]
    then
        \find .
        return 0
    fi

    # search with parameters
    input+=( ')' )
    if [ "$op_cd" ]
    then
        local targets
        local target
        while \read -r -d '' target
        do
            targets+=( "$target" )
        done < <(\find . "${input[@]}" -print0)

        if [ "${#targets[@]}" -lt 1 ]
        then
            \printf 'Not found: %b\n' "${rawinput[@]}"
        else
            local finder
            local trimmer
            target="$targets"
            trimmer="${target/%\/*//}"
            target="${target#$trimmer}"
            while [ -z "$(\printf '%b' "${targets[@]##$finder$trimmer*}")" -a "$target" ]
            do
                finder+="$trimmer"
                trimmer="${target/%\/*//}"
                target="${target#$trimmer}"
            done
            if [ -z "$target" ]
            then
                finder+="$trimmer"
            fi
            if [ -f "$finder" ]
            then
                finder="$(\dirname -- "$finder")"
            fi
            \cd -- "$finder"
            \printf '%b\n' "${targets[@]}"
        fi
    else
        \find . "${input[@]}"
    fi
}


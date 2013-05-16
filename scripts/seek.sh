# seek
# Search directories for file
#
# Copyright (C) 2013 Mara Kim, Kris McGary
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
if [ "$1" ]
then
    \find . -wholename "*$1*"
else
    \find .
fi
}

# Change to directory or directory containing
# search results
function seekto {
if [ "$1" ]
then
    local targets
    local target
    while \read -r -d '' target
    do
        targets+=( "$target" )
    done < <(\find "$PWD" -wholename "*$1*" -print0)
    if [ "${#targets[@]}" -lt 1 ]
    then
        \printf 'Not found: %b\n' "$1"
    else
        local good="good"
        if [ -f "$targets" ]
        then
            target="$(\dirname "$targets")"
        else
            target="$targets"
        fi
        for i in "${targets[@]}"
        do
            if [ -f "$i" ]
            then
                i="$(\dirname "$i")"
            fi
            if [ "$target" != "$i" ]
            then
                good="bad"
                break
            fi
        done
        if [ "$good" = "good" ]
        then
            \cd "$target"
        else
            \printf '%b\n' "${targets[@]}"
        fi
    fi
fi
}

# search
# Search directories
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
function search {
if [ "$1" ]
then
    find . -name "$1*"
else
    find .
fi
}

function goto {
if [ "$1" ]
then
    local targets
    local target
    while read -r -d '' target
    do
        targets+=( "$target" )
    done < <(\find "$PWD" -name "$1*" -print0)
    if [ "${#targets[@]}" -lt 1 ]
    then
        printf 'Not found: %b\n' "$1"
    elif [ "${#targets[@]}" -gt 1 ]
    then
        printf '%b\n' "${targets[@]}"
    else
        if [ -f "$targets" ]
        then
            targets="$(dirname "$targets")"
        fi
        cd "$targets"
    fi
fi
}

# randpw
# generate random passwords
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

function randpw {
 local length=64
 if [ "$1" ]
 then
  length="$1"
 fi
 tr -dc A-Za-z0-9 </dev/urandom |  head -c $length
 printf '\n' 1>&2
}

function randpw-strong {
 printf "Creating a cryptographically strong password. This could take a while...\n" 1>&2
 local length=128
 if [ "$1" ]
 then
  length="$1"
 fi
 tr -dc A-Za-z0-9 </dev/random |  head -c $length
 printf '\n' 1>&2
}

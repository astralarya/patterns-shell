# track
# trace and monitor a command
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

function track {
if [ "$1" ]
then
  { eval time '{' "${@:2}" $'\n' '}'; } &> "$1" &
  local pid=$!
  less +F "$1"

  if kill -0 $pid 2> /dev/null
    then fg %-
  fi
  true
fi
}

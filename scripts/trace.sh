# trace
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

function trace {
if [ -z "$1" ]
then
  printf 'Usage: trace [COMMAND...]\n'
else
  # Log environment
  printf '%s@%s:%s\n' "$USER" "$HOSTNAME" "$PWD"
  # Log command
  printf '$'; printf ' %s' "$@"; printf '\n'
  # Run command
  eval time '{' "$@" $'\n' 'status=$?; printf "\nstatus\t%b" $status 1>&2; }'
  return $status
fi
}

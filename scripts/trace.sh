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
  printf 'Usage: trace LOGFILE [COMMAND...]\n'
elif [ ! -e "$1" ]
then
    # Log environment
    printf '%s@%s:%s\n' "$USER" "$HOSTNAME" "$PWD" > "$1"
    # Log command
    printf '$' >> "$1"; printf ' %s' "${@:2}" >> "$1"; printf '\n' >> "$1"
    # Run command
  { eval time '{' "${@:2}" $'\n' 'status=$?; printf "\nstatus\t%b" $status 1>&2; }'
    exit $status
  } 2>&1 | tee -a "$1"
  return ${PIPESTATUS[0]}
else
  printf 'trace: cannot log to ‘%b’: file exists\n' "$1"
  return 1
fi
}

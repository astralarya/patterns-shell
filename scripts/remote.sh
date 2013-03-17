# remote
# Patterns for managing a connection to an SSH server
# and pushing and pulling files via SCP
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
# Then use template-remote in ../templates/remotes.sh
# to create your functions
# See README.md for more info


### FUNCTIONS ###

# generic ssh
#
# $1 Server
# $2 Username
# $3 Command (optional)
# $4 Option (optional)
function ssh-connection {
if [ "$4" ]
then
 ssh "$4" "$2@$1" "$3";
else
 ssh "$2@$1" "$3";
fi
}

# generic scp push to server
#
# $1 Server
# $2 Username
# $3 File
function scp-push { 
if [ "$3" -a -a "$3" ]
then
 scp "$3" "$2@$1:$3"; 
fi
}

# generic scp pull from server
#
# $1 Server
# $2 Username
# $3 File
function scp-pull { scp "$2@$1:$3" .; }


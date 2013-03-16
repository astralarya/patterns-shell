# remote templates
# Pattern examples for managing a connection to an SSH server
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

# then copy the example functions below into a new file
# and edit for your needs
#
# DO NOT edit the examples in this file directly


### TEMPLATES ###

# copy the functions in this section and edit for your needs
# :s/myconnection/connectionname
# :s/myserver/server
# :s/myuser/username
# :s/myscpdir/remotedir (without slash)

# SSH connection function
function myconnectfunc {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: myconnectfunc  [OPTION] [command]
Connect via SSH to myserver
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to myserver.
Option		GNU long option		Meaning
-h		--help			Show this message
-X					Enable X11 forwarding"
elif [ "$1" = "-X" ]
then
 # enable X11 forwarding
 ssh-connection "myserver" "myuser" "$2" "$1"
else
 # execute normal
 ssh-connection "myserver" "myuser" "$1"
fi
}

# SCP push function
function myconnection-push {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: myconnection-push [file]
Push file to myscpdir/ at myserver
Option		GNU long option		Meaning
-h		--help			Show this message"
else
 # execute normal
 scp-push "myserver" "myuser" "myscpdir/$1"
fi
}

# SCP pull function
function myconnection-pull {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: myconnection-pull [file]
Pull file from myscpdir/ at myserver
Option		GNU long option		Meaning
-h		--help			Show this message"
else
then
 # execute normal
 scp-pull "myserver" "myuser" "myscpdir/$1"
fi
}


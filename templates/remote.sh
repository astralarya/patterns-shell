# remote
# Template functions for managing a connection to an SSH server
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
# Then use template-remote to create your functions
# See README.md for more info


### TEMPLATE ###

# output three function definitons
# * access server via SSH
# * push file to server via SCP
# * pull file from server via SCP
# ex.
# source <(template-remote "myconnection" "myserver" "myuser" "myscpdir")
# * myconnection [OPTION] [command]
# * myconnection-push [OPTION] [file]
# * myconnection-pull [OPTION] [file]
function template-remote {

local MYCONNECTION=$1
local MYSERVER=$2
local MYUSER=$3
local MYSCPDIR=$4

cat << TEMPLATE 
# SSH connection function
function $MYCONNECTION {
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION [OPTION] [command]
Connect via SSH to $MYSERVER
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to $MYSERVER.
Option		GNU long option		Meaning
-h		--help			Show this message
-X					Enable X11 forwarding"
elif [ "\$1" = "-X" ]
then
 # enable X11 forwarding
 ssh "\$1" "$MYUSER@$MYSERVER" "\$2"
else
 ssh "$MYUSER@$MYSERVER" "\$1"
fi
}


# SSH key function
function $MYCONNECTION-keygen {
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION-keygen [OPTION]
Check and set up key authentication for $MYCONNECTION.
Option		GNU long option		Meaning
-h		--help			Show this message"
else
 echo "Testing key"
 # see if we already have a key
 ssh-add -L
 local status=\$?
 if [ \$status -eq 2 ]
 then
  # start ssh-agent if not started
  eval \$(ssh-agent)
  ssh-add -L
  local status=\$?
 fi
 if [ \$status -eq 1 ]
 then
  # if not, generate one
  ssh-keygen -f ~/.ssh/id_rsa
 fi

 # check if key auth already enabled
 ssh '-o PasswordAuthentication=no' "$MYUSER@$MYSERVER" ':' ||
 # if not set up remote key 
 ( ssh-add -L | ssh "$MYUSER@$MYSERVER" '\$(: \$(mkdir -p ~/.ssh)) cat >> ~/.ssh/authorized_keys' &&
 echo "Now try logging into the machine, with \"$MYCONNECTION\", and check in:

  ~/.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting." )

 echo "Key authentication enabled"
fi
}


# SCP push function
function $MYCONNECTION-push {
if [[ "\$1" = "-*" ]]
then
 local option="\$1"
 local file="\$2"
 local destination="\$3"
else
 local file="\$1"
 local dest="\$2"
fi
if [ -z "\$dest" ]
then
 local dest="$MYSCPDIR/\$file"
elif [[ "\$dest" = /* ]]
then
 local dest="\$dest"
else
 local dest="$MYSCPDIR/\$dest"
fi

if [ "\$option" = "-h" -o "\$option" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION-push [OPTION] [file] [destination]
Push file to destination \(default $MYSCPDIR/\) at $MYSERVER
Option		GNU long option		Meaning
-h		--help			Show this message"
elif [ -e "\$file" ]
then
 scp "\$file" "$MYUSER@$MYSERVER:\$dest"
fi
}


# SCP pull function
function $MYCONNECTION-pull {
if [[ "\$1" = -* ]]
then
 local option="\$1"
 local file="\$2"
 local destination="\$3"
else
 local file="\$1"
 local dest="\$2"
fi

if [[ "\$file" = /* ]]
then
 local file="\$file"
else
 local file="$MYSCPDIR/\$file"
fi
if [ -z "\$dest" ]
then
 local dest="."
else
 local dest="\$dest"
fi

if [ "\$option" = "-h" -o "\$option" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION-pull [OPTION] [file] [destination]
Pull file from $MYSCPDIR/ at $MYSERVER
Option		GNU long option		Meaning
-h		--help			Show this message"
else
  scp "$MYUSER@$MYSERVER:\$file" "\$dest"
fi
}
TEMPLATE
} # function template-remote


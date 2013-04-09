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

if [ "$1" = "-h" -o "$1" = "--help" ]
then
 echo "Usage: template-remote [connection] [server] [user] [scpdir]
Output code for a four functions named [connection], [connection]-keygen
[connection]-push, [connection]-pull, to connect to server via SSH,
push/pull files via SCP (default remote dir as [scpdir], and set up key
authentication as [user]@[server].
Option		GNU long option		Meaning
-h		--help			Show this message"
 return 0
fi

local MYCONNECTION=$1
local MYSERVER=$2
local MYUSER=$3
local MYSCPDIR=$4

cat << TEMPLATE 
# SSH connection function
function $MYCONNECTION {

if [[ "\$1" = "-*" ]]
then
 local option="\$1"
 local command="\$2"
else
 local command="\$1"
 local option="\$2"
fi
if [ "\$option" = "-h" -o "\$option" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION [OPTION] [command]
Connect via SSH to $MYSERVER
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to $MYSERVER.
Option		GNU long option		Meaning
-h		--help			Show this message
-*					SSH option (see man ssh)"
else
 ssh \$option "$MYUSER@$MYSERVER" "\$command"
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
  echo "It appears your ssh-agent does not start automatically. Put 

  eval \\\$(ssh-agent); ssh-add;

in your ~/.*rc file to fix"
  eval \$(ssh-agent)
  ssh-add -L
  local status=\$?
 fi
 if [ \$status -eq 1 ]
 then
  # check if key file exists
  if [ -e ~/.ssh/id_rsa ]
  then
   ssh-add
  else
   # if not, generate one
   ssh-keygen -f ~/.ssh/id_rsa
   ssh-add -L
   local status=\$?
   if [ \$status -eq 1 ]
   then
    ssh-add
   fi
  fi
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
local file
local option
local dest
local state
local good="good"
for arg in "\$@"
do
 if [ "\$state" = "file" ]
 then
  if [ -e "\$arg" ]
  then
   file="\$file \$arg"
  else
   echo "Cannot find file: \$arg"
   good="bad"
  fi
 elif [ "\$state" = "dest" ]
 then
  dest="\$arg"
  state=""
 elif [ "\$arg" = "-h" -o "\$arg" = "--help" ]
 then
  # show help
  echo "Usage: $MYCONNECTION-push [OPTION] [file]...
Push file to destination \(default $MYSCPDIR/\) at $MYSERVER
Option		GNU long option		Meaning
-h		--help			Show this message
-d		--destination		Specify the remote destination
-*					SCP option (see man scp)"
  return 0
 elif [ "\$arg" = "-d" -o "\$arg" = "--destination" ]
 then
  state="dest"
 elif [ "\$arg" = "--" ]
 then
  state="file"
 elif [[ "\$arg" = "-*" ]]
 then
  option="\$option \$arg"
 elif [ -e "\$arg" ]
 then
  file="\$file \$arg"
 else
  echo "Cannot find file: \$arg"
  good="bad"
 fi
done

if [ "\$good" != "good" ]
then
 echo "Abort"
 return 1
fi

if [ -z "\$dest" ]
then
 local dest="$MYSCPDIR/"
elif [[ "\$dest" = /* ]]
then
 local dest="\$dest"
else
 local dest="$MYSCPDIR/\$dest"
fi

scp \$option \$file "$MYUSER@$MYSERVER:\$dest"
}


# SCP pull function
function $MYCONNECTION-pull {
local file
local option
local dest
local state
local good="good"
for arg in "\$@"
do
 if [ "\$state" = "file" ]
 then
  if [[ "\$arg" = /* ]]
  then
   local file="\$file $MYUSER@$MYSERVER:\$arg"
  else
   local file="\$file $MYUSER@$MYSERVER:$MYSCPDIR/\$arg"
  fi
 elif [ "\$state" = "dest" ]
 then
  if [ -d "\$arg" ]
  then
   dest="\$arg"
  else
   good="bad"
  fi
  state=""
 elif [ "\$arg" = "-h" -o "\$arg" = "--help" ]
 then
  # show help
  echo "Usage: $MYCONNECTION-push [OPTION] [file]...
Pull files from $MYSERVER. Relative paths resolve from $MYSCPDIR.
Option		GNU long option		Meaning
-h		--help			Show this message
-d		--destination		Specify the local destination
-*					SCP option (see man scp)"
  return 0
 elif [ "\$arg" = "-d" -o "\$arg" = "--destination" ]
 then
  state="dest"
 elif [ "\$arg" = "--" ]
 then
  state="file"
 elif [[ "\$arg" = "-*" ]]
 then
  option="\$option \$arg"
 else
  if [[ "\$arg" = /* ]]
  then
   local file="\$file $MYUSER@$MYSERVER:\$arg"
  else
   local file="\$file $MYUSER@$MYSERVER:$MYSCPDIR/\$arg"
  fi
 fi
done

if [ "\$good" != "good" ]
then
 echo "Abort"
 return 1
fi

if [ -z "\$dest" ]
then
 local dest="."
else
 local dest="\$dest"
fi

scp \$option \$file "\$dest"
}
TEMPLATE
} # function template-remote


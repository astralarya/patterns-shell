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

# Source the output of this file in your shell's .*rc file
#
# Accepts the following arguments:
# connection: the name of the connection
# myuser@myserver: the SSH connection string
# scpdir: optional; default remote directory for SCP operations
# 
# Declares the following functions:
# [connection]: to connect to server via SSH as [user@server]
# [connection]-keygen: setup key authentication for this connection
# [connection]-push, [connection]-pull: push/pull files via SCP, default remote dir [scpdir] (default ~/scp)
# [connection]-proxy: start a SOCKS proxy using this connection"
#
# Example:
#     remote.sh "myremote" "myuser@myserver" "myscpdir"
#
# See README.md for more info

if [ -z "$1" -o -z "$2" ]
then
 printf "Usage: remote.sh connection [user@]server [scpdir]
Output code for functions to manage a remote connection.
* [connection]: to connect to server via SSH as [user@server]
* [connection]-keygen: setup key authentication for this connection
* [connection]-push, [connection]-pull: push/pull files via SCP, default remote dir [scpdir] (default ~/scp)
* [connection]-proxy: start a SOCKS proxy using this connection
" >&2
 exit 1
fi

### TEMPLATE ###

NAME="$1"
CONNECTION="$2"
if [ -z "$3" ]
then SCPDIR='~/scp'
else SCPDIR="$3"
fi

cat << TEMPLATE
# SSH connection function
$NAME () {

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
 echo "Usage: $NAME [OPTION] [command]
Connect via SSH to $CONNECTION
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to $CONNECTION
Option		GNU long option		Meaning
-h		--help			Show this message
-*					SSH option (see man ssh)"
else
 ssh \$option "$CONNECTION" "\$command"
fi
}


# SSH key function
$NAME-keygen () {
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $NAME-keygen [OPTION]
Check and set up key authentication for $NAME.
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
 ssh '-o PasswordAuthentication=no' "$CONNECTION" ':' ||
 # if not set up remote key 
 ( ssh-add -L | ssh "$CONNECTION" '\$(: \$(mkdir -p ~/.ssh)) cat >> ~/.ssh/authorized_keys' &&
 echo "Now try logging into the machine, with \"$NAME\", and check in:

  ~/.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting." )

 echo "Key authentication enabled"
fi
}

# SSH proxy function
$NAME-proxy () {
local port=\$1
if [ -z "\$port" ]
then
 local port=9999
fi
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $NAME-proxy [OPTION] [PORT]
Start a proxy on localhost using $CONNECTION on PORT (default 9999).
Option		GNU long option		Meaning
-h		--help			Show this message"
else
 echo "Starting SOCKS host to $CONNECTION on localhost:\$port (^C to STOP)"
 ssh -D \$port -C "$CONNECTION" "echo 'Success!'; cat > /dev/null"
 true
fi
}

# SCP push function
$NAME-push () {
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
  echo "Usage: $NAME-push [OPTION] [file]...
Push file to remote directory (default $SCPDIR) on $CONNECTION
Option		GNU long option		Meaning
-h		--help			Show this message
-d		--destination		Specify the remote destination (absolute or relative to $SCPDIR)
--					Treat all following arguments as files
-*					SCP option (see man scp)"
  return 0
 elif [ "\$arg" = "-d" -o "\$arg" = "--destination" ]
 then
  state="dest"
 elif [ "\$arg" = "--" ]
 then
  state="file"
 elif [[ "\$arg" = -* ]]
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
 local dest="$SCPDIR/"
elif [[ "\$dest" = /* ]]
then
 local dest="\$dest"
else
 local dest="$SCPDIR/\$dest"
fi

scp \$option \$file "$CONNECTION:\$dest"
}


# SCP pull function
$NAME-pull () {
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
   local file="\$file $CONNECTION:\$arg"
  else
   local file="\$file $CONNECTION:$SCPDIR/\$arg"
  fi
 elif [ "\$state" = "dest" ]
 then
  if [ -d "\$arg" ]
  then
   dest="\$arg"
  else
   echo "Bad destination: \$arg"
   good="bad"
  fi
  state=""
 elif [ "\$arg" = "-h" -o "\$arg" = "--help" ]
 then
  # show help
  echo "Usage: $NAME-push [OPTION] [file]...
Pull files from ${2}. Relative remote paths resolve from $SCPDIR/.
Option		GNU long option		Meaning
-h		--help			Show this message
-d		--destination		Specify the local destination
--					Treat all following arguments as files
-*					SCP option (see man scp)"
  return 0
 elif [ "\$arg" = "-d" -o "\$arg" = "--destination" ]
 then
  state="dest"
 elif [ "\$arg" = "--" ]
 then
  state="file"
 elif [[ "\$arg" = -* ]]
 then
  option="\$option \$arg"
 else
  if [[ "\$arg" = /* ]]
  then
   local file="\$file $CONNECTION:\$arg"
  else
   local file="\$file $CONNECTION:$SCPDIR/\$arg"
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

# SCP pull function tab completions
_$NAME-pull () {
    local IFS=\$'\\0'
    local word="\${COMP_WORDS[\$COMP_CWORD]}"
    local filename

    if [ -z "\$word" ]
    then
     filename="$SCPDIR/"
    elif [ -z "\${word##/*}" ]
    then
     filename="\$word"
    else
     filename="$SCPDIR/\$word"
    fi

    local compreply
    while \read -r -d '' file
    do
        compreply+=(\$file)
    done < <(ssh -o 'Batchmode yes' $CONNECTION \
               'find "\$(dirname -- "\$(readlink -f -- "\${filename}0" || printf '/dev/null')")" -mindepth 1 -maxdepth 1 -print0 2> /dev/null')

    local filter
    for completion in "\${compreply[@]}"
    do
        if [ -z "\${completion/#\$word*}" -a "\${completion/#\$word}" ]
        then
            filter+=("\$completion")
        fi
    done
    COMPREPLY=( "\${filter[@]}" )
}

complete -o filenames -o nospace -F _$NAME-pull $NAME-pull
TEMPLATE

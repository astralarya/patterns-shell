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
#
# Accepts the following arguments:
# connection: the name of the connection
# myuser@myserver: the SSH connection string
# scpdir: Optional; default remote directory for SCP operations
# 
# Declares the following functions:
# [connection]: to connect to server via SSH as [user@server]
# [connection]-keygen: setup key authentication for this connection
# [connection]-push, [connection]-pull: push/pull files via SCP, default remote dir [scpdir] (default ~/scp)
# [connection]-proxy: start a SOCKS proxy using this connection"
#
# Example:
#     source .../remote.sh "myremote" "myuser@myserver" "myscpdir"
#
# See README.md for more info

if [ -z "$1" -o -z "$2" ]
then
 echo "Usage: source .../remote.sh connection user@server [scpdir]
Output code for functions to manage a remote connection.
[connection]: to connect to server via SSH as [user@server]
[connection]-keygen: setup key authentication for this connection
[connection]-push, [connection]-pull: push/pull files via SCP, default remote dir [scpdir] (default ~/scp)
[connection]-proxy: start a SOCKS proxy using this connection"
 return 0
fi

### TEMPLATE ###

# $1 = connection name
# $2 = user@connection
# $3 = scpdir

eval "
# SSH connection function
$1 () {

if [[ \"\$1\" = \"-*\" ]]
then
 local option=\"\$1\"
 local command=\"\$2\"
else
 local command=\"\$1\"
 local option=\"\$2\"
fi
if [ \"\$option\" = \"-h\" -o \"\$option\" = \"--help\" ]
then
 # show help
 echo \"Usage: $1 [OPTION] [command]
Connect via SSH to $2
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to $2
Option		GNU long option		Meaning
-h		--help			Show this message
-*					SSH option (see man ssh)\"
else
 ssh \$option \"$2\" \"\$command\"
fi
}


# SSH key function
$1-keygen () {
if [ \"\$1\" = \"-h\" -o \"\$1\" = \"--help\" ]
then
 # show help
 echo \"Usage: $1-keygen [OPTION]
Check and set up key authentication for $1.
Option		GNU long option		Meaning
-h		--help			Show this message\"
else
 echo \"Testing key\"
 # see if we already have a key
 ssh-add -L
 local status=\$?
 if [ \$status -eq 2 ]
 then
  # start ssh-agent if not started
  echo \"It appears your ssh-agent does not start automatically. Put 

  eval \\\$(ssh-agent); ssh-add;

in your ~/.*rc file to fix\"
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
 ssh '-o PasswordAuthentication=no' "$2" ':' ||
 # if not set up remote key 
 ( ssh-add -L | ssh \"$2\" '\$(: \$(mkdir -p ~/.ssh)) cat >> ~/.ssh/authorized_keys' &&
 echo \"Now try logging into the machine, with \\\"$1\\\", and check in:

  ~/.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.\" )

 echo \"Key authentication enabled\"
fi
}

# SSH proxy function
$1-proxy () {
local port=\$1
if [ -z \"\$port\" ]
then
 local port=9999
fi
if [ \"\$1\" = \"-h\" -o \"\$1\" = \"--help\" ]
then
 # show help
 echo \"Usage: $1-proxy [OPTION] [PORT]
Start a proxy on localhost using $2 on PORT (default 9999).
Option		GNU long option		Meaning
-h		--help			Show this message\"
else
 echo \"Starting SOCKS host to $2 on localhost:\$port (^C to STOP)\"
 ssh -D \$port -C \"$2\" \"echo 'Success!'; cat > /dev/null\"
 true
fi
}

# SCP push function
$1-push () {
local file
local option
local dest
local state
local good=\"good\"
for arg in \"\$@\"
do
 if [ \"\$state\" = \"file\" ]
 then
  if [ -e \"\$arg\" ]
  then
   file=\"\$file \$arg\"
  else
   echo \"Cannot find file: \$arg\"
   good=\"bad\"
  fi
 elif [ \"\$state\" = \"dest\" ]
 then
  dest=\"\$arg\"
  state=\"\"
 elif [ \"\$arg\" = \"-h\" -o \"\$arg\" = \"--help\" ]
 then
  # show help
  echo \"Usage: $1-push [OPTION] [file]...
Push file to remote directory (default $(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)) on $2
Option		GNU long option		Meaning
-h		--help			Show this message
-d		--destination		Specify the remote destination (absolute or relative to $(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)/)
--					Treat all following arguments as files
-*					SCP option (see man scp)\"
  return 0
 elif [ \"\$arg\" = \"-d\" -o \"\$arg\" = \"--destination\" ]
 then
  state=\"dest\"
 elif [ \"\$arg\" = \"--\" ]
 then
  state=\"file\"
 elif [[ \"\$arg\" = -* ]]
 then
  option=\"\$option \$arg\"
 elif [ -e \"\$arg\" ]
 then
  file=\"\$file \$arg\"
 else
  echo \"Cannot find file: \$arg\"
  good=\"bad\"
 fi
done

if [ \"\$good\" != \"good\" ]
then
 echo \"Abort\"
 return 1
fi

if [ -z \"\$dest\" ]
then
 local dest=\"$(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)/\"
elif [[ \"\$dest\" = /* ]]
then
 local dest=\"\$dest\"
else
 local dest=\"$(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)/\$dest\"
fi

scp \$option \$file \"$2:\$dest\"
}


# SCP pull function
$1-pull () {
local file
local option
local dest
local state
local good=\"good\"
for arg in \"\$@\"
do
 if [ \"\$state\" = \"file\" ]
 then
  if [[ \"\$arg\" = /* ]]
  then
   local file=\"\$file $2:\$arg\"
  else
   local file=\"\$file $2:$(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)/\$arg\"
  fi
 elif [ \"\$state\" = \"dest\" ]
 then
  if [ -d \"\$arg\" ]
  then
   dest=\"\$arg\"
  else
   echo \"Bad destination: \$arg\"
   good=\"bad\"
  fi
  state=\"\"
 elif [ \"\$arg\" = \"-h\" -o \"\$arg\" = \"--help\" ]
 then
  # show help
  echo \"Usage: $1-push [OPTION] [file]...
Pull files from ${2}. Relative remote paths resolve from $(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)/.
Option		GNU long option		Meaning
-h		--help			Show this message
-d		--destination		Specify the local destination
--					Treat all following arguments as files
-*					SCP option (see man scp)\"
  return 0
 elif [ \"\$arg\" = \"-d\" -o \"\$arg\" = \"--destination\" ]
 then
  state=\"dest\"
 elif [ \"\$arg\" = \"--\" ]
 then
  state=\"file\"
 elif [[ \"\$arg\" = -* ]]
 then
  option=\"\$option \$arg\"
 else
  if [[ \"\$arg\" = /* ]]
  then
   local file=\"\$file $2:\$arg\"
  else
   local file=\"\$file $2:$(if [ -z "$3" ]; then printf '~/scp'; else printf "$3"; fi)/\$arg\"
  fi
 fi
done

if [ \"\$good\" != \"good\" ]
then
 echo \"Abort\"
 return 1
fi

if [ -z \"\$dest\" ]
then
 local dest=\".\"
else
 local dest=\"\$dest\"
fi

scp \$option \$file \"\$dest\"
}
"


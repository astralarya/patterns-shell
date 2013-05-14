# deploy
# deploy a Makefile project to a remote server
# Makefile must respond to make tar and make name
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
# Then use template-deploy-client and template-deploy-server
# to create your functions
# See README.md for more info

function template-deploy-client {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 echo "Usage: template-deploy-client [server] [FUNCNAME] [REMOTEFUNC]
Output code for two functions named [FUNCNAME] (default deploy) and [FUNCNAME]-full
to find the name of a makefile project (via make name) and
create a tarball of the project (via make tar) and copy to [server]
(via [server]-push) and then call [REMOTEFUNC] (default [FUNCNAME])
or [REMOTEFUNC]-full for [FUNCNAME]-full.
Option		GNU long option		Meaning
-h		--help			Show this message"
 return 0
fi

local MYSERVER="$1"
if [ "$2" ]
then
 local MYFUNC="$2"
else
 local MYFUNC="deploy"
fi
if [ "$3" ]
then
 local MYREMOTEFUNC="$3"
else
 local MYREMOTEFUNC="$MYFUNC"
fi

cat << TEMPLATE
function $MYFUNC {
local name="\$(make name | tail -1)"
make tar;
if [ -e "\$name"*.tar.gz ]
then
 $MYSERVER-push "\$name"*.tar.gz
 $MYSERVER "$MYREMOTEFUNC \"\$name\"" 
fi }

function $MYFUNC-full {
local name="\$(make name | tail -1)"
make tar;
if [ -e "\$name"*.tar.gz ]
then
 $MYSERVER-push "\$name"*.tar.gz
 $MYSERVER "$MYREMOTEFUNC-full \"\$name\"" 
fi }
TEMPLATE
} # function template-deploy-client

function template-deploy-server {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 echo "Usage: template-deploy-server [stagedir] [livedir] [scpdir] [FUNCNAME]
Output code for two functions named [FUNCNAME] (default deploy)
and [FUNCNAME]-full.
[FUNCNAME] deploys a program tarball located in [scpdir] (default ~/scp)
to [stagedir], overwriting any previous deployment. It then builds
and links a stable name to deployed program.
[FUNCNAME]-full calls [FUNCNAME], then copies the deployment from
[stagedir] to [livedir].
Option		GNU long option		Meaning
-h		--help			Show this message"
 return 0
fi

local MYSTAGEDIR="$1"
local MYLIVEDIR="$2"
if [ "$3" ]
then
 local MYSCPDIR="$3"
else
 local MYSCPDIR="~/scp"
fi
if [ "$4" ]
then
 local MYFUNC="$4"
else
 local MYFUNC="deploy"
fi

cat << TEMPLATE
function $MYFUNC {
if [ "\$1" -a -a $MYSCPDIR/"\$1"*.tar.gz ]
then
  cd $MYSTAGEDIR
  rm -r "\$1"*
  mv $MYSCPDIR/"\$1"*.tar.gz .
  local archive=( \$MYSCPDIR/"$1"*.tar.gz )
  fullname="\${archive%.tar.gz}"
  mkdir -p "\$fullname";
  tar -zxvf "\$archive" -C "\$fullname/"; 
  ln -s "\$fullname/" "\$1"
  cd "\$1"
  make
else
  return 1
fi }

function $MYFUNC-full {
deploy "\$1"
local status="\$?"
if [ "\$status" -eq 0 ]
then
  rm -r "$MYLIVEDIR/\$1"*
  cp -r "$MYSTAGEDIR/\$1"* "$MYLIVEDIR/"
fi }
TEMPLATE
} # function template-deploy-server

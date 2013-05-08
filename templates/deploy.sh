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

# TODO
function template-deploy-client {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 echo "Usage: template-deploy-client [server] [FUNCNAME] [REMOTEFUNC]
Output code for a function named [FUNCNAME] (default deploy)
to copy a tarball of the project to [server] and then
call [REMOTEFUNC] (default [FUNCNAME]).
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
 $MYSERVER "$MYREMOTEFUNC \$name" 
fi }
TEMPLATE
} # function template-deploy-client

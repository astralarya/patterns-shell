# pgdb
# Template function for managing a connection to a PostgreSQL database
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
# database: the PostgreSQL database
# user: the PostgreSQL user
# funcname: optional; the name of the generated function, default [database]
# 
# Declares the following function:
# [FUNCNAME]: connect to the PostgreSQL database
#
# Example:
#     source .../pgdb.sh "database" "user" [FUNCNAME]
#
# See README.md for more info


if [ -z "$1" -o -z "$2" ]
then
 echo "Usage: source pgdb.sh database user [FUNCNAME]
Output code for a function [FUNCNAME] (default [database])
to access the PostgreSQL database [database] as [user]."
 return 0
fi

### TEMPLATE ###

# $1 = database
# $2 = user
# $3 = function name

eval "
# Database access function
$(if [ -z "$3" ]; then printf "$1"; else printf "$3"; fi) () {
local file
local option
local state
local good=\"good\"
for arg in \"\$@\"
do
 if [ \"\$state\" = \"file\" ]
 then
  if [ -e \"\$arg\" ]
  then
   file+=( '-f' \"\$arg\" )
  else
   echo \"Cannot find file: \$arg\"
   good=\"bad\"
  fi
 elif [ \"\$arg\" = \"-h\" -o \"\$arg\" = \"--help\" ]
 then
  # show help
  echo \"Usage: $(if [ -z "$3" ]; then printf "$1"; else printf "$3"; fi) [OPTION] [queryfile]
Access $1 as $2.
If a file is given as an argument, execute the queries in the file,
otherwise start a psql session connected to $1. 
Option		GNU long option		Meaning
-h		--help			Show this message
-*		--*			Pass argument to psql (see man psql)\"
  return 0
 elif [ \"\$arg\" = \"--\" ]
 then
  state=\"file\"
 elif [[ \"\$arg\" = -* ]]
 then
  option=( \"\$arg\" )
 elif [ -e \"\$arg\" ]
 then
  file+=( '-f' \"\$arg\" )
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


if [ \"\${#file[@]}\" = 0 -a \"\${#option[@]}\" = 0 ]
then
 psql -U \"$2\" -d \"$1\"
elif [ \"\${#file[@]}\" = 0 ]
then
 psql -U \"$2\" -d \"$1\" \"\${option[@]}\"
elif [ \"\${#option[@]}\" = 0 ]
then
 psql -U \"$2\" -d \"$1\" \"\${file[@]}\"
else
 psql -U \"$2\" -d \"$1\" \"\${file[@]}\" \"\${option[@]}\"
fi
}
"

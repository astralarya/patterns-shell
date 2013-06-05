# pgdb
# Template functions for managing a connection to a PostgreSQL database
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
# Then use template-mydb and template-mydbbackup
# to create your functions
# See README.md for more info


### TEMPLATES ###

# generate function definition
# to access a database
# ex.
# source <(template-db "mydb" "myuser" "myfunc")
# * myfunc [OPTION] [queryfile]
function template-db {

if [ "$1" = "-h" -o "$1" = "--help" ]
then
 echo "Usage: template-db [db] [user] [FUNCNAME]
Output code for a function named [FUNCNAME] (default [db])
to access [db] as [user].
Option		GNU long option		Meaning
-h		--help			Show this message"
 return 0
fi

local MYDB=$1
local MYUSER=$2
if [ "$3" ]
then
 local MYFUNC=$3
else
 local MYFUNC=$MYDB
fi

cat << TEMPLATE
# $MYDB access function
function $MYFUNC {
local file
local option
local op_cd
local state
local good="good"
for arg in "\$@"
do
 if [ "\$state" = "file" ]
 then
  if [ -e "\$arg" ]
  then
   file+=( '-f' "\$arg" )
  else
   echo "Cannot find file: \$arg"
   good="bad"
  fi
 elif [ "\$arg" = "-h" -o "\$arg" = "--help" ]
 then
  # show help
  echo "Usage: $MYFUNC [OPTION] [queryfile]
Access $MYDB as $MYUSER.
If a file is given as an argument, execute the queries in the file,
otherwise start a psql session connected to $MYDB. 
Option		GNU long option		Meaning
		--time			Time the query or session
-h		--help			Show this message
-*		--*			Pass argument to psql (see man psql)"
  return 0
 elif [ "\$arg" = "--time" ]
 then
  op_cd="true"
 elif [ "\$arg" = "--" ]
 then
  state="file"
 elif [[ "\$arg" = -* ]]
 then
  option="\$option \$arg"
 elif [ -e "\$arg" ]
 then
  file+=( '-f' "\$arg" )
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


if [ "\$op_time" ]
then
 # Time execution
 date
 if [ "\${#file[@]}" = 0 ]
 then
  psql "\${option[@]}" -U "$MYUSER" "$MYDB"
 else
  psql "\${option[@]}" "\${file[@]}" -U "$MYUSER" "$MYDB"
 fi
 date
else
 if [ "\${#file[@]}" = 0 ]
 then
  psql "\${option[@]}" -U "$MYUSER" "$MYDB"
 else
  # Execute query file
  psql "\${option[@]}" "\${file[@]}" -U "$MYUSER" "$MYDB"
 fi
fi
}
TEMPLATE
} # function template-mydb


# output function definition
# to backup a database
# ex.
# source <(template-dbbackup "mydb" "mysuperuser" "mybackupdir" "myfunc")
# * myfunc [OPTION] [file]
function template-dbbackup {

if [ "$1" = "-h" -o "$1" = "--help" ]
then
 echo "Usage: template-dbbackup [db] [superuser] [backupdir] [FUNCNAME]
Output code for a function named [FUNCNAME] (default [db]backup)
to backup [db] as [superuser]. Backups placed in [backupdir] by default.
Option		GNU long option		Meaning
-h		--help			Show this message"
 return 0
fi

local MYDB=$1
local MYSUPERUSER=$2
local MYBACKUPDIR=$3
if [ "$4" ]
then
 local MYFUNC=$4
else
 local MYFUNC=${MYDB}backup
fi

cat << TEMPLATE
# $MYDB backup function
function $MYFUNC {
if [ -z "\$1" ]
then
 # make dated backup
 pg_dumpall -c -U "$MYSUPERUSER" > "$MYBACKUPDIR/${MYDB}_\$(date +%F).sql"
elif [ "\$1" = "-h" ]
then
 echo "Usage: $MYFUNC [OPTION] [file]
Backup or restore $MYDB as $MYSUPERUSER.
If no arguments given, make dated backup in $MYBACKUPDIR,
otherwise, execute according the options below.
Option		GNU long option		Meaning
-b		--backup		Backup $MYDB to file
-r		--restore		Restore $MYDB from file
-h		--help			Show this message"
elif [ "\$1" = "-b" -a "\$2" ]
then
 pg_dumpall -c -U "$MYSUPERUSER" > "\$2"
elif [ "\$1" = "-r" -a -e "\$2" ]
then
 psql -f "\$2" -U "$MYSUPERUSER" postgres | grep ERROR
fi
}
TEMPLATE
} # function template-dbbackup


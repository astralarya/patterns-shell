# pgdb-backup
# Template function for backing up a PostgreSQL database
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
# Then use template-dbbackup to generate your function.
#
# ex.
# source <(template-dbbackup "mydb" "mysuperuser" "mybackupdir" "myfunc")
#
# * myfunc [OPTION] [file]
#
# See README.md for more info


# output function definition
# to backup a database
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
elif [ "\$1" = "-m" ]
then
 # move last monthly, delete previous month
 mkdir -p "$MYBACKUPDIR/monthly"
 mv "$MYBACKUPDIR/${MYDB}_\$(date -d"1 month ago" +%F).sql" "$MYBACKUPDIR/monthly" &&
 rm "$MYBACKUPDIR/${MYDB}_\$(date -d"1 month ago" +%Y-%m-)*.sql"
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
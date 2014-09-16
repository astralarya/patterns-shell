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
# source <(template-dbbackup "myfunc" "mydb" "mysuperuser" "mybackupdir" "myhost")
#
# output function definition
# to backup a database
# * myfunc [OPTION] [file]
#
# See README.md for more info


if [ -z "$1" -o -z "$2" -o -z "$3" ]
then
 printf "Usage: pgdb-backup.sh funcname database superuser backupdir [host]
Output code for a function to backup a database.
* [funcname]: to backup [db] as [superuser]. Backups placed in [backupdir] by default.
" >&2
 exit 1
fi

MYFUNC=$1
MYDB=$2
MYSUPERUSER=$3
MYBACKUPDIR=$4
if [ -z "$5" ]
then HOST="localhost"
else HOST="$5"
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
Backup or restore $MYDB@$HOST as $MYSUPERUSER.
If no arguments given, make dated backup in $MYBACKUPDIR,
otherwise, execute according the options below.
Option		GNU long option		Meaning
-b		--backup		Backup $MYDB to file
-r		--restore		Restore $MYDB from file
-h		--help			Show this message"
elif [ "\$1" = "-b" -a "\$2" ]
then
 pg_dumpall -c -U "$MYSUPERUSER" -h "$HOST" > "\$2"
elif [ "\$1" = "-r" -a -e "\$2" ]
then
 psql -f "\$2" -U "$MYSUPERUSER" -h "$HOST" -d "postgres" | grep ERROR
fi
}
TEMPLATE

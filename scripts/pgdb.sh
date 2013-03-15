# pgdb
# Patterns for managing a connection to a PostgreSQL database
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
# See ../templates/pgdb.sh for templates


### FUNCTIONS ###

# generic db function
#
# $1 Database name
# $2 Database user
# $3 Query file
# $4 Option
#    -t/--time  time execution
function pgdb {
if [ "$4" = "-t" -o "$4" = "--time" ]
then
 # Time execution
 date
 if [ -z "$3" ]
 then
  # Open psql session
  psql -U "$2" "$1"
 else [ -e "$3" ]
  # Execute query file
  cat "$3"
  psql -f "$3" -U "$2" "$1"
 fi
 date
elif [ -z "$3" ]
then
 # Open psql session
 psql -U "$2" "$1"
elif [ -e "$3" ]
then
 # Execute query file
 cat "$3"
 psql -f "$3" -U "$2" "$1"
fi }

# generic backup_db function
# backs up all databases
#
# $1 Database superuser
# $2 Output file
function backup_db { pg_dumpall -c -U "$1" > "$2"; }

# generic restore database
#
# $1 Database superuser
# $2 Input file
function restore_db {
if [ -e "$2" ]
then
 psql -f "$2" -U "$1" postgres | grep ERROR
fi
}

# generic dated backups
#
# $1 Database superuser
# $2 Backup prefix (path and/or file-prefix)
function dated_backup_db { backup_db "$1" "$2`date +%F`.sql"; }


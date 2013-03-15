# pgdb
# postgresql database macros

# generic db function
# Access database $1 as user $2
#
# $1 Database name
# $2 Database user
# $3 Query file
# $4 Option
function pgdb {
if [ "$4" = "-t" ]
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
 psql -f "$3" -U "$2" "$1"
fi }

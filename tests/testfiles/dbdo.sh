#!/bin/true

# script to create or destroy various databases for testing; reads external
# SQL files into the database to be tested as needed

## script variables
SQLITE_DB_FILE="camelbox.sqlite.db"

function check_exit_code () {
	local ACTION=$1
	local EXIT_STATUS=$2

	if [ $EXIT_STATUS -gt 0 ]; then
		echo "ERROR: '$ACTION' command exited with status $EXIT_STATUS"
		exit 1
	fi
} # function check_exit_code

function show_usage () {
	echo "dbdo.sh [options]"
	echo "Usage:"
	echo "  -h show this help text"
	echo "  -c create database tables"
	echo "  -z zero out database tables"
	echo "  -d destroy the database file (SQLite only)"
	echo
	echo "Database options:"
	echo "  -s connect via SQLite (database filename: ${SQLITE_DB_FILE})"
	echo "  -f filename to use for the SQLite database file"
	#echo "  -m connect via MySQL client"
	#echo "  -p connect via PostgreSQL client"
	echo
	exit 1
} # function show_usage ()

#### begin main script ####
# call getopts with all of the supported options
while getopts hczdsf:mp VARLIST
do
	case $VARLIST in
		h)  SHOW_HELP="true";;
		c)  ACTION="create";;
        z)  ACTION="zero";;
        d)  ACTION="destroy";;
        s)  DB_TYPE="sqlite";; 
		f)  DB_FILENAME=$OPTARG;;
        m)  DB_TYPE="mysql";;
        p)  DB_TYPE="postgresql";;
	esac
done
shift $(expr $OPTIND - 1)

if [ "x$SHOW_HELP" = "xtrue" ]; then show_usage; fi


if [ "x$ACTION" = "xcreate" ]; then
	# create the database
	sqlite3 -line $SQLITE_DB_FILE '.read sqlite-create.sql'  
	check_exit_code "create db file" $?	

elif [ "x$ACTION" = "xzero" ]; then
	# zero out the tables in the database
	sqlite3 -line $SQLITE_DB_FILE '.read sqlite-zero_tables.sql'
	check_exit_code "slick tables" $?	

elif [ "x$ACTION" = "xdestroy" ]; then
	# remove the actual file
	rm $SQLITE_DB_FILE
	check_exit_code "delete db file" $?

else
	# neither -c (create), -z (zero), or -d (destroy) passed in
	show_usage
fi # if [ $OUTPUT_LIST ]; then

exit 0

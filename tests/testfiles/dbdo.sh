#!/bin/true

# script to create or destroy various databases for testing; reads external
# SQL files into the database to be tested as needed

## script variables
SQLITE_DB_FILE="camelbox.sqlite.db"

function check_exit_code () {
	local ACTION=$1
	local EXIT_STATUS=$2

	if [ $EXIT_STATUS -gt 0 ]; then
		echo "ERROR: $ACTION command exited with status $EXIT_STATUS"
		exit 1
	fi
} # function check_exit_code

function show_usage () {
	echo "dbdo.sh [options]"
	echo "Usage:"
	echo "  -h show this help text"
	echo "  -c create the database file (${SQLITE_DB_FILE})"
	echo "  -d destroy the database file (${SQLITE_DB_FILE})"
	echo
	echo "Database options:"
	echo "  -s SQLite (database filename: ${SQLITE_DB_FILE})"
	echo "  -f filename to use for the SQLite database file"
	echo
	exit 1
} # function show_usage ()

#### begin main script ####
# call getopts with all of the supported options
while getopts cdf:h VARLIST
do
	case $VARLIST in
		c)  ACTION="create";;
        d)  ACTION="destroy";;
		f)  DB_FILENAME=$OPTARG;;
		h)  SHOW_HELP="true";;
	esac
done
shift $(expr $OPTIND - 1)

if [ "x$SHOW_HELP" = "xtrue" ]; then show_usage; fi


if [ "x$ACTION" = "xcreate" ]; then
	# create the database
	sqlite3 -line $SQLITE_DB_FILE '.read sqlite_create.sql'  
	check_exit_code "create" $?	

elif [ "x$ACTION" = "xdestroy" ]; then
	# destroy the database
	sqlite3 -line $SQLITE_DB_FILE '.read sqlite_destroy.sql'
	check_exit_code "destroy" $?	

else
	# neither -c (create) or -d (destroy) passed in
	show_usage
fi # if [ $OUTPUT_LIST ]; then

exit 0

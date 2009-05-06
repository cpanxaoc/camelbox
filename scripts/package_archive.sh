#!/bin/sh

# simple script to package a directory full of files

# usage:
# time sh ~/Documents/src/camelbox-svn/scripts/package.sh package1 package2

## SCRIPT VARIABLES
TIMESTAMP=$(TZ=GMT date +%Y.%j | tr -d '\n')
ARCHIVE_DIR="../archives"
PKGLISTS_DIR="share/pkglists"

BASENAME=$(which basename)
#RELEASE_TIMESTAMP=$(TZ=GMT date +%Y.%j.%H%m | tr -d '\n')

if [ -z $BASENAME ]; then
	echo "ERROR: basename binary required for this script"
	echo "Please install the basename binary and rerun this script"
	exit 1
fi
SCRIPT_NAME=$($BASENAME $0)

## FUNCTIONS
function find_first_free_filename () {
	local FILE_DIR=$1
    local FILE_NAME=$2
	local FILE_EXT=$3
    local FILE_COUNTER=1
    while [ -f $FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT ];
    do
		if [ "x${VERBOSE}" = "xtrue" ]; then
        echo "$FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT exists"
		fi
        FILE_COUNTER=$(($FILE_COUNTER + 1))
    done
    echo "Output file will be: $FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT"

    FREE_FILENAME="$FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT"
} # function find_first_free_filename()

function show_usage () {
	echo "Usage:"
	echo "  -h show this help text"
	echo "  -v verbose output from 'tar'"
	echo
    echo "To generate packages from a list of directories:"
	echo "  ${SCRIPT_NAME} dir1 dir2 dir3"
    echo "To generate packages from a list of directories, with verbose output:"
	echo "  ${SCRIPT_NAME} -v dir1 dir2 dir3"
	echo "Redirect STDERR to STDOUT to capture the output from 'tar'"
	echo
	echo "(Package list file has *NIX forward slashes for path separation)"
} # function show_usage ()

## MAIN SCRIPT
while getopts hv VARLIST
do
	case $VARLIST in
		v) 	VERBOSE="true";;
		h) 	SHOW_HELP="true";;
	esac
done # while getopts
shift $(expr $OPTIND - 1)

if [ "x$SHOW_HELP" = "xtrue" ]; then show_usage; exit 1; fi

if [ "x${VERBOSE}" = "xtrue" ]; then
	TAR_CMD="tar -cv *"
else 
	TAR_CMD="tar -c *"
fi

# parse all of the archive files
for ARCHIVE_NAME in "$@" 
do
    if [ -d $ARCHIVE_NAME ]; then
		if [ ! -d $ARCHIVE_NAME/$PKGLISTS_DIR ]; then
			mkdir -p $ARCHIVE_NAME/$PKGLISTS_DIR
		fi # if [ ! -d pkgfiles ]; then
        echo "Creating archive package '${ARCHIVE_NAME}'"
		if [ "x${VERBOSE}" = "xtrue" ]; then
	    	echo "Checking for existing ${ARCHIVE_NAME}.${TIMESTAMP} files"
		fi
        find_first_free_filename $ARCHIVE_DIR $ARCHIVE_NAME "tar.lzma"
        CURRENT_DIR=$PWD
        cd $ARCHIVE_NAME
		echo "# Package list for: $FREE_FILENAME" \
			| sed '{s|\.\.\/archives\/||;}' > $PKGLISTS_DIR/$ARCHIVE_NAME.txt
	    SYSNAME=$(uname -s | tr -d '\n')
        if [ "x$SYSNAME" = "xDarwin" ]; then
            # Mac OS X, lzma from the MacPorts tree
			find . | sed '{/^\.$/d; s/\.\\//; s/\\/\//g;}' \
				>> $PKGLISTS_DIR/$ARCHIVE_NAME.txt
			if [ "x${VERBOSE}" = "xtrue" ]; then
            	tar -cv * | lzma -z -c > ../$ARCHIVE_DIR/$FREE_FILENAME
			else
            	tar -c * | lzma -z -c 2>/dev/null \
					> ../$ARCHIVE_DIR/$FREE_FILENAME
			fi # if [ "x${VERBOSE}" = "xtrue" ]
	        if [ $? -ne 0 ]; then
    	        echo "ERROR: tar/lzma exited with an error code of $?"
        	    exit 1
	        fi # if [ $? -ne 0 ]
        else 
            # Windows, lzma from the lzma SDK
			xfind . | sed '{ /^\.$/d; s/\.\\//; s/\\/\//g;}' \
				>> $PKGLISTS_DIR/$ARCHIVE_NAME.txt
			if [ "x${VERBOSE}" = "xtrue" ]; then
            	tar -cv * | lzma e -si ../$ARCHIVE_DIR/$FREE_FILENAME
			else 
            	tar -c * | lzma e -si ../$ARCHIVE_DIR/$FREE_FILENAME 2>nul:
			fi # if [ "x${VERBOSE}" = "xtrue" ]	
	        if [ $? -ne 0 ]; then
    	        echo "ERROR: tar/lzma exited with an error code of $?"
        	    exit 1
	        fi # if [ $? -ne 0 ]
        fi # if [ "x$SYSNAME" == "xDarwin" ]
        cd $CURRENT_DIR
    else 
        echo "ERROR: Directory ${ARCHIVE_NAME} does not exist"
        exit 1
    fi # if [ -d $ARCHIVE_NAME ]
done
# - read in a list of directories

# - create a log file
# - enter a directory
# - read the output directory, verify there's not a file with the same name;
# if so, bump up the version #
# - tar it, lzma it, command output to log, file output to user's output
# directory
# - next directory
# - no errors? delete logfile


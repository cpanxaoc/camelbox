#!/bin/sh

# simple script to package a directory full of files

## SCRIPT VARIABLES
TIMESTAMP=$(TZ=GMT date +%Y.%j | tr -d '\n')
ARCHIVE_DIR="../archives"

## FUNCTIONS
function find_first_free_filename () {
	local FILE_DIR=$1
    local FILE_NAME=$2
	local FILE_EXT=$3
    local FILE_COUNTER=1
    while [ -f $FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT ];
    do
        echo "$FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT exists"
        FILE_COUNTER=$(($FILE_COUNTER + 1))
    done
    echo "Output file will be:"
   	echo $FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT

    FREE_FILENAME="$FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT"
} # function find_first_free_filename()

## MAIN SCRIPT

for ARCHIVE_NAME in "$@" 
do
    if [ -d $ARCHIVE_NAME ]; then
        echo "Creating archive package '${ARCHIVE_NAME}'"
	    echo "Checking for existing ${ARCHIVE_NAME}.${TIMESTAMP} files"
        find_first_free_filename $ARCHIVE_DIR $ARCHIVE_NAME "tar.lzma"
        CURRENT_DIR=$PWD
        cd $ARCHIVE_NAME
        SYSNAME=$(uname -s | tr -d '\n')
        if [ "x$SYSNAME" == "xDarwin" ]; then
            # Mac OS X, lzma from the MacPorts tree
            tar -cvf - * | lzma -z -c > ../$ARCHIVE_DIR/$FREE_FILENAME
        else 
            # Windows, lzma from the lzma SDK
            tar -cvf - * | lzma e -si ../$ARCHIVE_DIR/$FREE_FILENAME
        fi # if [ "x$SYSNAME" == "xDarwin" ]
        if [ $? -ne 0 ]; then
            echo "ERROR: tar/lzma exited with an error code of $?"
            exit 1
        fi # if [ $? -ne 0 ]
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


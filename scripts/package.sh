#!/bin/sh

# simple script to package a directory full of files

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

# - create a timestamp
TIMESTAMP=$(TZ=GMT date +%Y.%j | tr -d '\n')
ARCHIVE_DIR="/temp/Camelbox/archives"
PACKAGE_DIR="/temp/Camelbox/package_dirs"

for DIR in "$@" 
do
	echo "${TIMESTAMP}: argument ${DIR}"
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


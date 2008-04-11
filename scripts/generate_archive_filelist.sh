#!/bin/true

# script to generate a list of archive files given a camelbox NSIS installer
# script (camelbox_installer.nsi)

# script accepts the following options:
# - name of the camelbox NSI script
# - name of the filelist to write to

# psuedocode
# - run the find on the camelbox tree
# - the user does their install bits
# - run find on the camelbox tree again
# - diff the two finds
# - (optional) filter out .cpan entries 

BASENAME=$(which basename)
#RELEASE_TIMESTAMP=$(TZ=GMT date +%Y.%j.%H%m | tr -d '\n')

if [ -z $BASENAME ]; then
	echo "ERROR: basename binary required for this script"
	echo "Please install the basename binary and rerun this script"
	exit 1
fi
SCRIPT_NAME=$($BASENAME $0)

function usage () {
	echo "Usage:"
	echo "$SCRIPT_NAME -p previous.txt -n next.txt -f filelist.txt"
	echo "  -f filelist to write output to"
	echo "  -n NSI script to read archive files from"
	echo "  -o overwrite existing files"
	echo "  -r release timestamp"
	echo "  -h this help output"
	exit 1
} # function usage ()

while getopts hf:n:or: VARLIST
do
	case $VARLIST in
		h)  HELP="true";;
		f)  FILELIST=$OPTARG;;	
		n) 	NSI_FILE=$OPTARG;;
		o)  OVERWRITE="true";;
		r) 	RELEASE_TIMESTAMP=$OPTARG;;
	esac
done
shift $(expr $OPTIND - 1)

#echo "$PREV:$NSI_FILE:$FILELIST:$HELP"
#sleep 5s

if [ "x$HELP" = "xtrue" ]; then usage; fi
if [ -z $NSI_FILE -o -z $FILELIST -o -z $RELEASE_TIMESTAMP ]; then usage; fi

#echo "overwrite is $OVERWRITE"
if [ "x$OVERWRITE" != "xtrue" ]; then
	if [ -f $FILELIST ]; then
		echo "ERROR: $FILELIST exists;"
		echo "Cowardly refusing to overwrite existing files"
		echo "Use the '-o' overwrite switch to ignore existing files"
		exit 1
	fi # if [ -e $NSI_FILE -o -e $FILELIST ]
fi # if [ "x$OVERWRITE" != "xtrue" ]

# zsh on windows can't do HERE documents
echo "# This a list of archive files that make up a camelbox install">$FILELIST
echo "# This list is published to make mirroring easier" >> $FILELIST
echo "# This list is valid for the release labeled: " >> $FILELIST
echo "# $RELEASE_TIMESTAMP " >> $FILELIST
echo "#" >> $FILELIST
echo "# To download files for use with the Camelbox" >> $FILELIST
echo "# installer, you would use this URL:" >> $FILELIST
echo "# http://camelbox.googlecode.com/files/" >> $FILELIST
echo "# with the list of files below.  Here's an example:" >> $FILELIST
echo "#" >> $FILELIST
echo '# for FILE in $(grep -v "#" filelist.txt); do' >> $FILELIST
echo '# 	wget http://camelbox.googlecode.com/files/$FILE' >> $FILELIST
echo "# done" >> $FILELIST
echo "#" >> $FILELIST
echo "# This file is commented using the pound '#' symbol;" >> $FILELIST
echo "# if you start a line with a pound symbol, " >> $FILELIST 
echo "# the entire line will be ignored" >> $FILELIST

grep push $NSI_FILE  | grep -v '$0' | grep -v '^#' \
	| sed '{s/.*"\(.*\)"/\1/; s/\r$/\n/;}' | sort >> $FILELIST

exit 0
# fin!

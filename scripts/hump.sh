#!/bin/true

# script to run a before/after diff on the camelbox folder, and generate a
# list of files that have been added to the after snapshot

# script accepts the following options:
# - name of the before filelist
# - name of the after filelist
# - name of the diff filelist
# - whether or not to strip the .cpan directory

# psuedocode
# - run the find on the camelbox tree
# - the user does their install bits
# - run find on the camelbox tree again
# - diff the two finds
# - (optional) filter out .cpan entries 

function usage () {
	echo "Usage:"
	echo "hump.sh -p previous.txt -n next.txt -f filelist.txt"
	echo "  -c show the .cpan directory in filelist output"
	echo "  -f filelist to write output to"
	echo "  -h show this help text"
	echo "  -n next file"
	echo "  -p previous file"
	echo "  -o overwrite existing files"
	echo "When creating the first filelist, all arguments need to be present,"
	echo "but only the '-n next.txt' filelist is used"
	exit 1
} # function usage ()

while getopts cf:hn:op:u VARLIST
do
	case $VARLIST in
		c)  CPAN="true";;
		f)  FILELIST=$OPTARG;;	
		h)  HELP="true";;
		n) 	NEXT=$OPTARG;;
		o)  OVERWRITE="true";;
		p) 	PREV=$OPTARG;;
		u)	UFIND="true";;
	esac
done
shift $(expr $OPTIND - 1)

#echo "$PREV:$NEXT:$FILELIST:$HELP"
#sleep 5s

if [ -z $PREV -o -z $NEXT -o -z $FILELIST ]; then usage; fi
if [ "x$HELP" = "xtrue" ]; then usage; fi

#echo "overwrite is $OVERWRITE"
if [ "x$OVERWRITE" != "xtrue" ]; then
	if [ -f $NEXT -o -f $FILELIST ]; then
		echo "ERROR:"
		if [ -f	$NEXT ]; then echo "exists: $NEXT"; fi
		if [ -f	$FILELIST ]; then echo "exists: $FILELIST"; fi
		echo "Cowardly refusing to overwrite existing files"
		echo "Use the '-o' overwrite switch to ignore existing files"
		exit 1
	fi # if [ -e $NEXT -o -e $FILELIST ]
fi # if [ "x$OVERWRITE" != "xtrue" ]

# do the find
ufind /camelbox | sed -e '{/^\/camelbox$/d; s/\/camelbox[\\]*//;}' | tee $NEXT

# check to see if we just want the ufind only
if [ "x$UFIND" = "xtrue" ]; then
	exit 0
fi

# TODO - the below grep -v "\.cpan" may be redundant, the previous grep in the
# pipe may already snag that match; verify!
# don't strip the .cpan directories
# the file list needs to have forward slashes to keep tar happy
if [ "x$CPAN" = "xtrue" ]; then
	echo "Including .cpan directory in filelist output"
	diff -u $PREV $NEXT | grep "^+[.a-zA-Z]" | sed '{s/^+//; s/\\/\//g;}' \
		| tee $FILELIST
else
	# get rid of the .cpan directories
	echo "Stripping .cpan directory from filelist output"
	diff -u $PREV $NEXT | grep "^+[a-zA-Z]" | grep -v "\.cpan" \
		| sed '{s/^+//; s/\\/\//g;}' | tee $FILELIST
fi # if [ "x$NOCPAN" = "xtrue" ]

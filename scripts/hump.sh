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

if [ -z $PREV -o -z $NEXT -o -z $FILELIST -o "x$HELP" = "xtrue" ]; then
	echo "$PREV:$NEXT:$FILELIST:$HELP"
	echo "Usage:"
	echo "hump.sh -p previous.txt -n next.txt -f filelist.txt"
	echo "When creating the first filelist, all arguments need to be present,"
	echo "but only the '-n next.txt' filelist is used"
	exit 1
fi # if [ -z $PREV -o -z $NEXT -o -z $FILELIST ]
echo "overwrite is $OVERWRITE"
if [ "x$OVERWRITE" != "xtrue" ]; then
	if [ -f $NEXT -o -f $FILELIST ]; then
		echo "$NEXT or $FILELIST exist;"
		echo "Cowardly refusing to overwrite existing files"
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
	diff -u $PREV $NEXT | grep "^+[a-zA-Z]"  | sed '{s/^+//; s/\\/\/g;}' \
		| tee $FILELIST
else
	# get rid of the .cpan directories
	diff -u $PREV $NEXT | grep "^+[a-zA-Z]" | grep -v "\.cpan" \
		| sed '{s/^+//; s/\\/\//g;}' | tee $FILELIST
fi # if [ "x$NOCPAN" = "xtrue" ]

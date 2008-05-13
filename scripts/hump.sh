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
#   - save checksums of files
# - install some software from CPAN, or the user installs software
# - run find on the camelbox tree again
#   - get new checksums
# - diff the two finds, or diff the two checksum lists
# - (optional) filter out .cpan entries 

function file_exists () {
#echo "overwrite is $OVERWRITE"
	if [ "x$OVERWRITE" != "xtrue" ]; then
		if [ -e $1 ]; then
			echo "ERROR: file $1 exists" 
			echo "Cowardly refusing to overwrite existing files"
			echo "Use the '-o' overwrite switch to ignore existing files"
			exit 1
		fi # if [ -e $1 ]
	fi # if [ "x$OVERWRITE" != "xtrue" ]
} # function file_exists ()

function show_examples () {
	echo "Examples:"
	echo "# create a list of files"
	echo "sh hump.sh -n filelist.txt"
	echo
	echo "# create a filelist, next file from 'prev' file"
	echo "sh hump.sh -b prev.txt -a next.txt -f filelist.txt"
	echo
	echo "# install a CPAN module, creating 'prev'/'next' files and filelist"
	echo "sh hump.sh -i JSON -b next.txt -a next.txt -f filelist.txt"
	echo
} # function show_examples

function usage () {
	echo "Usage:"
	echo "hump.sh -p previous.txt -n next.txt -f filelist.txt"
	echo "  -h show this help text"
	echo "  -e show usage examples"
	echo
	echo "  -z create the archive file based on filelist.txt"
	echo "  -c show the .cpan directory in filelist output"
	echo "  -f filelist to write output to"
	echo "  -i install this Perl module from CPAN"
	echo "  -a next file"
	echo "  -b previous file"
	echo "  -o overwrite existing files"
	echo "  -u run the ufind only, then exit; builds initial filelist"
	
	exit 1
} # function usage ()

function empty_var () {
	if [ -z $2 ]; then
		echo "ERROR: switch '$1' empty/not used"
		usage
	fi
} # function empty_var ()

# call getopts with all of the supported options
while getopts a:b:cdf:hi:ouz VARLIST
do
	case $VARLIST in
		a) 	AFTERLIST=$OPTARG;;
		b) 	BEFORELIST=$OPTARG;;
		c)  CPAN="true";;
		d)  DIFF="true";;
		f)  FILELIST=$OPTARG;;	
		h)  HELP="true";;
		i)	CPAN_INSTALL=$OPTARG;;
		o)  OVERWRITE="true";;
		u)	UFIND="true";;
		z)  ARCHIVE="true";;
	esac
done
shift $(expr $OPTIND - 1)

# for debugging
#echo "$BEFORELIST:$AFTERLIST:$FILELIST:$HELP"
#sleep 5s

if [ "x$HELP" = "xtrue" ]; then usage; fi

empty_var "-a (after list)" $AFTERLIST
#file_exists $AFTERLIST

# install a module from CPAN?
if [ -n $CPAN_INSTALL ]; then
	perl -MCPAN -e "install $CPAN_INSTALL"
	if [ $? -ne 0 ]; then 
		echo "Install of $CPAN_INSTALL failed; exiting..."
		exit 1
	fi # if [ $? -ne 0 ]
fi # if [ -n $CPAN_INSTALL ]

# do the find
# FIXME abstract this; we can run find as many times as we want/need depending
# on what we're trying to do;
# - if there's no filelists, run it once
# - if there are no filelists, and we're installing a CPAN module, run it
# twice
# - if there are filelists and we're installing a CPAN module, run it once?
ufind /camelbox | sed -e '{/^\/camelbox$/d; s/\/camelbox[\\]*//;}' \
	| tee $AFTERLIST

# check to see if we just want the ufind only
if [ "x$UFIND" = "xtrue" ]; then
	exit 0
fi

empty_var "-b (before list)" $BEFORELIST
#file_exists $BEFORELIST
empty_var "-f (output filelist)" $FILELIST
file_exists $FILELIST

# TODO - the below grep -v "\.cpan" may be redundant, the previous grep in the
# pipe may already snag that match; verify!
# don't strip the .cpan directories
# the file list needs to have forward slashes to keep tar happy
if [ "x$CPAN" = "xtrue" ]; then
	echo "Including .cpan directory in filelist output"
	diff -u $BEFORELIST $AFTERLIST | grep "^+[.a-zA-Z]" \
		| sed '{s/^+//; s/\\/\//g;}' | tee $FILELIST
else
	# get rid of the .cpan directories
	echo "Stripping .cpan directory from filelist output"
	diff -u $BEFORELIST $AFTERLIST | grep "^+[a-zA-Z]" | grep -v "\.cpan" \
		| sed '{s/^+//; s/\\/\//g;}' | tee $FILELIST
fi # if [ "x$NOCPAN" = "xtrue" ]

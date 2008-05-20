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

# a starting directory, if the user doesn't pass one in
START_DIR="/camelbox"

function file_exists () {
#echo "overwrite is $OVERWRITE"
	if [ "x$OVERWRITE" != "xtrue" ]; then
		if [ -e $1 ]; then
			echo "ERROR: file $1 exists" 
			echo "Cowardly refusing to overwrite existing files"
			echo "Use the '-w' overwrite switch to ignore existing files"
			exit 1
		fi # if [ -e $1 ]
	fi # if [ "x$OVERWRITE" != "xtrue" ]
} # function file_exists ()

function show_examples () {
	echo "Examples:"
	echo "# create a list of files"
	echo "sh hump.sh -o filelist.txt"
	echo
	echo "# create a filelist and 'after' file from 'before' file"
	echo "sh hump.sh -b before.txt -a after.txt -o filelist.txt"
	echo
	echo "# install a CPAN module, creating 'before/after' files and filelist"
	echo "sh hump.sh -i JSON -b before.txt -a after.txt -o filelist.txt"
	echo
    exit 1
} # function show_examples

function show_usage () {
	echo "Usage:"
	echo "  -h show this help text"
	echo "  -e show usage examples"
	echo
    echo "To get a simple list of files:"
	echo "  -o output list - Generate a simple list of files"
    echo
    echo "To get a list of files that are installed for an application:"
	echo "  -b before filelist - Generate a 'before install' list"
	echo "  -a after filelist - Generate an 'after install' list"
	echo "  -i install this Perl module from CPAN (optional)"
    echo
    echo "Miscellaneous Options"
    echo '  -d start in this directory instead of "C:\\camelbox"'
	echo "  -z create the archive file based on filelist.txt"
	echo "  -c show the .cpan directory in filelist output"
    echo	
	exit 1
} # function show_usage ()

function check_empty_var () {
	if [ -z $2 ]; then
		echo "ERROR: switch '$1' empty/not used"
		show_usage
	fi
} # function check_empty_var ()

function ufind () {
    # sed removes the 'camelbox/' prefix from all files
    # and the 'camelbox/' directory itself
    ufind $START_DIR | sed -e '{/^\/camelbox$/d; s/\/camelbox[\\]*//;}' \
	    | tee $1
} # function ufind



#### begin main script ####
# call getopts with all of the supported options
while getopts a:b:cd:ehi:o:wuz VARLIST
do
	case $VARLIST in
		a) 	AFTERLIST=$OPTARG;;
		b) 	BEFORELIST=$OPTARG;;
		c)  CPAN="true";;
        d)  START_DIR=$OPTARG;;
		e)  SHOW_EXAMPLES="true";;
		h)  SHOW_HELP="true";;
		i)	CPAN_INSTALL=$OPTARG;;
        o)  OUTPUT_LIST=$OPTARG;;
		w)  OVERWRITE="true";;
		u)	UFIND="true";;
		z)  ARCHIVE="true";;
	esac
done
shift $(expr $OPTIND - 1)

# for debugging
#echo "$BEFORELIST:$AFTERLIST:$OUTPUT_LIST:$HELP"
#sleep 5s

if [ "x$SHOW_HELP" = "xtrue" ]; then show_usage; fi
if [ "x$SHOW_EXAMPLES" = "xtrue" ]; then show_examples; fi


if [ "x$BEFORELIST" != "x" -a "x$AFTERLIST" != "x" ]; then
    # do the find
    check_empty_var "-b (before list)" $BEFORELIST
    file_exists $BEFORELIST
    check_empty_var "-a (after list)" $AFTERLIST
    file_exists $AFTERLIST
    ufind $AFTERLIST
    check_empty_var "-o (output list)" $OUTPUT_LIST
    file_exists $OUTPUT_LIST

    # install a module from CPAN?
    if [ -n $CPAN_INSTALL ]; then
    	perl -MCPAN -e "install $CPAN_INSTALL"
    	if [ $? -ne 0 ]; then 
    		echo "Install of $CPAN_INSTALL failed; exiting..."
    		exit 1
    	fi # if [ $? -ne 0 ]
    fi # if [ -n $CPAN_INSTALL ]

    # TODO - the below grep -v "\.cpan" may be redundant, the previous grep in
    # the pipe may already snag that match; verify!
    # don't strip the .cpan directories
    # the file list needs to have forward slashes to keep tar happy
    if [ "x$CPAN" = "xtrue" ]; then
    	echo "Including .cpan directory in package filelist output"
    	diff -u $BEFORELIST $AFTERLIST | grep "^+[.a-zA-Z]" \
    		| sed '{s/^+//; s/\\/\//g;}' | tee $OUTPUT_LIST
    else
    	# get rid of the .cpan directories
    	echo "Stripping .cpan directory from package filelist output"
    	diff -u $BEFORELIST $AFTERLIST | grep "^+[a-zA-Z]" | grep -v "\.cpan" \
    		| sed '{s/^+//; s/\\/\//g;}' | tee $OUTPUT_LIST
    fi # if [ "x$NOCPAN" = "xtrue" ]
elif [ "x$OUTPUT_LIST" != "x" ]; then
    check_empty_var "-o (output list)" $OUTPUT_LIST
    file_exists $OUTPUT_LIST
    ufind $OUTPUT_LIST
    exit 0
else
	# neither -o (output list) or -b/-a (before/after list) passed in
	show_usage
fi # if [ $OUTPUT_LIST ]; then

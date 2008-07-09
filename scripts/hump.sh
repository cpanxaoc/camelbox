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
TIMESTAMP=$(TZ=GMT date +%Y.%j | tr -d '\n')

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

    OUTPUT_FILE="$FILE_DIR/$FILE_NAME.$TIMESTAMP.$FILE_COUNTER.$FILE_EXT"
} # function find_first_free_filename()

function exists_check () {
	if [ ! -e $1 ]; then
		echo "ERROR: file $1 does not exist" 
		exit 1
	fi # if [ -e $1 ]
} # function exists_check ()

function overwrite_check () {
#echo "overwrite is $OVERWRITE"
	if [ "x$OVERWRITE" != "xtrue" ]; then
		if [ -e $1 ]; then
			echo "ERROR: file $1 exists" 
			echo "Cowardly refusing to overwrite existing files"
			echo "Use the '-w' overwrite switch to ignore existing files"
			exit 1
		fi # if [ -e $1 ]
	fi # if [ "x$OVERWRITE" != "xtrue" ]
} # function overwrite_check ()

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
	echo "# create a filelist and and a package from that filelist"
	echo "sh hump.sh -b before.txt -a after.txt -o filelist.txt -p pkg_name"
	echo
	echo "# create an md5sum filelist (list of files with checksums)"
	echo "sh hump.sh -m filename -t TIMESTAMP -d /path/to/search"
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
	echo "  -b before filelist - A pre-generated 'before install' list"
	echo "  -a after filelist - Generate an 'after install' list"
	echo "  -i install this Perl module from CPAN (optional)"
    echo
	echo "To get a list of files with MD5 checksums (for verifying downloads)"
	echo "  -m generate a filelist with MD5 sums"
	echo "  -t use this timestamp for the output file"
	echo
    echo "Miscellaneous Options"
    echo '  -d start in this directory instead of "C:\\camelbox"'
	echo "  -p create a tarball using the output filelist"
	echo "  -z create the archive file based on filelist.txt"
	echo "  -c show the .cpan directory in filelist output"
    echo	
	exit 1
} # function show_usage ()

function check_empty_var () {
	echo "checking for $2"
	if [ -z $2 ]; then
		echo "ERROR: switch '$1' empty/not used"
		show_usage
	fi
} # function check_empty_var ()

function run_ufind () {
    # sed removes the 'camelbox/' prefix from all files
    # and the 'camelbox/' directory itself
    ufind $START_DIR | sed -e '{/^\/camelbox$/d; s/\/camelbox[\\]*//;}' \
	    | tee $1
} # function run_ufind

#### begin main script ####
# call getopts with all of the supported options
while getopts a:b:cd:ehi:m:o:p:t:wuz VARLIST
do
	case $VARLIST in
		a) 	AFTERLIST=$OPTARG;;
		b) 	BEFORELIST=$OPTARG;;
		c)  CPAN="true";;
        d)  START_DIR=$OPTARG;;
		e)  SHOW_EXAMPLES="true";;
		h)  SHOW_HELP="true";;
		i)	CPAN_INSTALL=$OPTARG;;
		m)  MD5_LIST=$OPTARG;;
        o)  OUTPUT_LIST=$OPTARG;;
		p)  PACKAGE_FILE=$OPTARG;;
		t)  TIMESTAMP=$OPTARG;;
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
    exists_check $BEFORELIST
    
    check_empty_var "-o (output list)" $OUTPUT_LIST
    overwrite_check $OUTPUT_LIST

    # install a module from CPAN?
    if [ "x$CPAN_INSTALL" != "x" ]; then
    	perl -MCPAN -e "install $CPAN_INSTALL"
    	if [ $? -ne 0 ]; then 
    		echo "Install of $CPAN_INSTALL failed; exiting..."
    		exit 1
    	fi # if [ $? -ne 0 ]
    fi # if [ -n $CPAN_INSTALL ]

	check_empty_var "-a (after list)" $AFTERLIST
    overwrite_check $AFTERLIST
    run_ufind $AFTERLIST

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
    overwrite_check $OUTPUT_LIST
    run_ufind $OUTPUT_LIST
elif [ "x$MD5_LIST" != "x" ]; then
  	ufind $START_DIR -maxdepth 1 -type f | xargs md5sum \
		>> $MD5_LIST.$TIMESTAMP.txt
else
	# neither -o (output list) or -b/-a (before/after list) passed in
	show_usage
fi # if [ $OUTPUT_LIST ]; then

if [ "x$OUTPUT_LIST" != "x" -a "x$PACKAGE_FILE" != "x" ]; then
	# feed the output list to tar, then compress it
	overwrite_check $PACKAGE_FILE
	find_first_free_filename "/temp" $PACKAGE_FILE "tar"
	echo "Creating package tarball"
	# $OUTPUT_FILE comes from find_first_free_filename
	CURRENT_PWD=$PWD
	cd $START_DIR
	tar -cvf - -T"$OUTPUT_LIST" > "/temp/$PACKAGE_FILE.tar"
	cd $CURRENT_PWD
fi # if [ "x$OUTPUT_LIST" != "x" -a "x$PACKAGE_FILE" != "x" ]; then

exit 0

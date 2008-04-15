#!/usr/bin/perl

# $Id$
# Copyright (c)2008 by Brian Manning <elspicyjack at gmail dot com>
#
# compare the contents of two archive files side-by-side or in list format

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; version 2 dated June, 1991.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program;  if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111, USA.

# FIXME
# - create a set of external modules, or call to internal Perl-ish modules
# that will list the contents of various archive formats
#   - start with lzma first

=pod

=head1 NAME

B<archive_diff.pl> - compare files listed in two archives

=head1 VERSION

The CVS version of this file is $Revision: 1.15 $. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl archive_diff.pl -1 first_filelist.txt -2 second_filelist.txt 

=head2 Script Options

 --help|-h              Show this help message
 --verbose|-v           Verbose script output
 --first-file|-1st      Filename of the First filelist
 --second-file|-2nd     Filename of the second filelist
 --write|-w             Write diff output to file (diff.YYYY.JJJ.XX.txt)
 --noscreen-out         Disable output to the screen (-w recommended)
 --nocommon-list        Don't write/display the list of common files    
 --nofirst-list         Don't write/display the unique first list files    
 --nosecond-list        Don't write/display the unique second list files 
 --nocolorlog           Disable colorized log output

=head1 DESCRIPTION

B<archive_diff.pl> compares the files listed in two archives, checking for
files that are in one archive and not the other and vice versa.

=cut

#### Package 'Archive' ####
package Archive;
use Date::Parse;
use Log::Log4perl qw(get_logger);
use Moose; # comes with 'strict' and 'warnings'
use Moose::Util::TypeConstraints;

=pod

=head2 Module Archive

The Archive object grabs information from an archive of some kind and allows
this information to be queried.  The L<Archive> object has the following
attributes:

=over 5

=item attrib

The archive attributes.  Contained in an object of L<Archive::Attributes>
type.

=item filename 

The name of the archive file.  The file is checked to see if it exists and is
readable when an object is created from this class.

=item contents

A pointer to an L<Archive::FileList> object which is used to store filenames
from the archive.

=item count_pulse

How many lines to parse before the throbber (user work being done indicator)
updates itself.  Defaults to 10 lines per pulse.

=back

=cut

# a subtype for holding the name of a file in the archive
# this should make it so that the file is checked when the object is created
# Str is from Moose::Util::TypeConstraints
subtype ArchiveFilename
    => as Str
    => where { ( -r $_ ) };

has q(attrib) => ( is => q(rw), isa => q(Archive::Attributes));
has q(archfilename) => (is => q(rw), isa => q(ArchiveFilename), required => 1);
has q(filelist) => ( is => q(rw), isa => q(Archive::FileList) );
has q(count_pulse) => ( is => q(rw), isa => q(Int), default => 10 );

=pod

=head3 BUILD()

This method is called automatically, it initializes the L<Archive::FileList>
object so it can store individual L<Archive::File> records.  

=cut

sub BUILD {
    my $self = shift;
    my $logger = get_logger();
    $logger->debug(q(Entering Archive->BUILD() ));
    $self->filelist(Archive::FileList->new());
} # sub BUILD

=pod

=head3 parse()

Parses (lists) the contents of the archive, and populates the appropriate
object attributes.

=cut 

sub parse { 
    my $self = shift;

    my $logger = get_logger();


	if ( $self->archfilename() =~ /\.7z\.txt$/ ) {
		# try to process the list as a 7zip filelist
		$self->process_7zip_list();
	} else {
		# fall back to a regular text file list instead
		$self->process_text_list();
	} # if ( $self->archfilename() =~ /\.7z\.txt$/ )
} # sub parse

=pod

=head3 process_text_list()

Parse a text file containing a list of files, one file per line.  The text
file would most likely be generated using the C<find> command.

=cut

# FIXME 
# - add something to this method that parses the archive attributes, and then
# populates the object with those archive attributes

sub process_text_list { 
	my $self = shift;
    my $logger = get_logger();

    my $total_lines;

    # turn off line buffering on STDOUT; this makes the throbber work
    $| = 1;
    my $throbber = Throbber->new( count_pulse => $self->count_pulse() );

    # open the file and read it's contents
    open(FH, q(<) . $self->archfilename);
    while (<FH>) {
        my $line = $_;
        # skip blank lines
        next if ( $line =~ /^$/ );
		chomp($line);
		#$line =~ s/\r$//g;
		# create the archive file object
        my $archive_file = Archive::File->new( name => $line );
		$logger->debug(q(Adding ) . $archive_file->name 
       		. q( to filelist object));
		$self->filelist->add(   key => $archive_file->name(),
        						object => $archive_file );
		$logger->debug(q(there are now ) . $self->filelist->get_count()
        	. q( records in self->filelist));
		$total_lines++;
        $throbber->throb(total_lines => $total_lines);
    } # while (<FH>)
	$logger->info(qq(Total files in archive: ) . $total_lines);
    # turn line buffering back on on STDOUT
    $| = 0;
} # sub process_text_list

=pod

=head3 process_7zip_list()

Parse the output of the C<7za l> command, which should list the contents of a
7-zip archive.

=cut

# FIXME 
# - add something to this method that parses the archive attributes, and then
# populates the object with those archive attributes

sub process_7zip_list { 
	my $self = shift;
    my $logger = get_logger();

    my $total_lines;

    # turn off line buffering on STDOUT; this makes the throbber work
    $| = 1;
    my $throbber = Throbber->new( count_pulse => $self->count_pulse() );

    # open the file and read it's contents
    open(FH, q(<) . $self->archfilename);
    while (<FH>) {
        my $line = $_;
        # skip blank lines
        next if ( $line =~ /^$/ );
        # if the line starts with a date string
        if ( $line =~ /^\d\d\d\d-\d\d-\d\d/ ) {
            chomp($line);
            # found a file entry
            $line =~ s/  +/ /g;
            $line =~ s/\r$//g;
            my @splitline = split(/ /, $line);
            if ( $logger->is_debug() ) {
                $logger->debug(join(q(:), @splitline));
                $logger->debug(q(this line has ) . scalar(@splitline) 
                    . q( fields));
            } # if ( $logger->is_debug() )
            # create the archive file object
            my $archive_file = Archive::File->new( 
                # str2time comes from Date::Parse
                timestamp => str2time($splitline[0] . q( ) . $splitline[1]),
                attributes => $splitline[2],
                orig_size => $splitline[3],
            );
            # some records have 5 fields, some have 6 (extra field is
            # compressed file size).  compensate
            if ( scalar(@splitline) == 5 ) {
                $archive_file->{name} = $splitline[4];
            } elsif ( scalar(@splitline) == 6 ) {
                $archive_file->{comp_size} = $splitline[4];
                $archive_file->{name} = $splitline[5];
            } else {
				$logger->fatal(q(Problem with parsing LZMA archive file:));
            	$logger->fatal(q(archive file list unrecognized));
                exit 1;
            } # if ( scalar(@splitline) == 5 )
            $logger->debug(q(Adding ) . $archive_file->name 
                . q( to filelist object));
            $self->filelist->add(   key => $archive_file->name(),
                                    object => $archive_file );
            $logger->debug(q(there are now ) . $self->filelist->get_count()
                . q( records in self->filelist));
            $total_lines++;
            $throbber->throb(total_lines => $total_lines);
        } # if ( $line =~ /^\d\d\d\d-\d\d-\d\d/ )
    } # while (<FH>)
	$logger->info(qq(Total files in archive: ) . $total_lines);
    # turn line buffering back on on STDOUT
    $| = 0;
} # sub process_7zip_list

#### end Package 'Archive' ####

#### Package 'Archive::Diff' ####
package Archive::Diff;
use Log::Log4perl qw(get_logger);
use Moose; # comes with 'strict' and 'warnings'
use Moose::Util::TypeConstraints;
use Time::Local;

=pod

=head2 Module Archive::Diff

This object takes two L<Archive> objects as arguments, and when queried using
the object methods, will return a formatted list that shows the differences in
the contents of the two archives.  This module has the following attributes:

=over 5

=item first

The first archive to be compared.

=item second

The second archive to be compared.

=item common

An archive that contains a list of files that are common to both the first and
second archives.

=back

=cut

has q(first) => ( is => q(rw), isa => q(Archive), required => 1 );
has q(second) => ( is => q(rw), isa => q(Archive), required => 1 );
has q(common) => ( is => q(rw), isa => q(Archive::FileList) );

=pod

=head3 BUILD()

Initializes the common L<Archive::FileList> object.

=cut

sub BUILD {
    my $self = shift;
    $self->common( Archive::FileList->new() ); 
}  # sub BUILD

=pod

=head3 simple_stats()

Shows simple statistics about each file contained inside of the
L<Archive::Diff> object.

=cut

sub simple_stats {
	my $self = shift;
    my $logger = get_logger();

	$logger->info(q(The first filename is:));
    $logger->info($self->first->archfilename);
    $logger->info(q(The second filename is:));
    $logger->info($self->second->archfilename);
    $logger->info(q(There are ) . $self->first->filelist->get_count()
        . qq( files in the first Archive object));
    $logger->info(q(There are ) . $self->second->filelist->get_count()
        . qq( files in the second Archive object));
    $logger->info(q(There are ) . $self->common->get_count()
        . qq( files in the 'common' Archive object));
} # sub simple_diff

=pod

=head3 simple_diff()

Compares the lists of files in the first and second archive objects, prints
three lists; the list of common files, the list of files in the first object
only, and the list of files in the second object only.

=cut

sub simple_diff {
    my $self = shift;
    my $logger = get_logger();

    $logger->info(q(Running a diff on the first and second files...));
    # get a list of files from the first filelist
    foreach my $firstkey ( $self->first->filelist->get_keys() ) {
        # for each file in that list, see if the same file exists in the
        # second filelist
        $logger->debug(qq(simple_diff: Checking $firstkey));
        if ( $self->second->filelist->exists(key => $firstkey) ) { 
            $logger->debug(qq(do_diff: matched $firstkey));
            $self->common->add( 
                filename => $firstkey, 
                object => $self->first->filelist->get( key => $firstkey ),
            );
            $self->first->filelist->del(key => $firstkey);
            $self->second->filelist->del(key => $firstkey);
        } # if ( $self->second->exists(key => $firstkey)
    } # foreach my $firstkey ( $self->first->get_keys() )
} # sub do_diff

#### end Package 'Archive::Diff' ####

#### Package 'Archive::Attributes' ####
package Archive::Attributes;
use Moose; # comes with 'strict' and 'warnings'
use Moose::Util::TypeConstraints;

=pod 

=head2 Module Archive::Attributes

Contains metadata attributes for an archive file.  

=over 5

=item version

The version of the program that created this archive.  May or may not come from
the archive itself;  an asterisk B<*> denotes the version number of the program
on the system, as the archive itself does not hold any version information.

=back

=cut

has q(version) => ( is => q(rw), isa => q(Str) );

#### end Package 'Archive::Attributes' ####

#### Package 'Archive::FileList' ####
package Archive::FileList;
use Log::Log4perl qw(get_logger);
use Moose; # comes with 'strict' and 'warnings'
use Moose::Util::TypeConstraints;

=pod 

=head2 Module Archive::FileList

An object that keeps a list of L<Archive::File> objects keyed by filename.
The object has the following attributes:

=over 5

=item _filelist

An internal holder of the file list hash.  Use the get_keys() method to obtain
the list of files being held by this hash.

=back 

=cut

has q(_filelist) => ( is => q(rw), isa => q(HashRef) );

=pod

=head3 BUILD

This method is called automatically, it initializes the _filelist hash.

=cut

sub BUILD {
    my $self = shift;
    my $logger = get_logger();
    $logger->debug(q(Entering Archive::FileList->BUILD));

    $self->_filelist({});
} # sub BUILD

=pod

=head3 add([key|filename] => $filename, [object|value] => Archive::File object)

Adds a file from the archive to the L<Archive::FileList> object using the
filename as a key and the L<Archive::File> object as the value.

=cut

sub add {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my ($filename, $fileobj);
    my %filelist = %{$self->_filelist()};
    # since we support two different signatures for passing in the
    # Archive::File object...
    if ( exists $args{key} ) { $filename = $args{key}; }
    if ( exists $args{filename} ) { $filename = $args{filename}; }
    if ( exists $args{value} ) { $fileobj = $args{value}; }
    if ( exists $args{object} ) { $fileobj = $args{object}; }
    die q(File name/object not passed in to add method) 
        unless ( defined $fileobj && defined $filename );
    # verify we got an Archive::File object; blessed is imported from Moose
    my $fileobj_type = blessed $fileobj;
    if ( $fileobj_type eq q(Archive::File) ) {
        # now see if that filename is already in the file list
        if ( exists($filelist{$filename}) ) {
            # yes, it exists; throw a warning
            $logger->warn(q(File: ) . $fileobj->name());
            $logger->warn(q( already exists in filelist));
        } else {
            # no, it doesn't exist; add it
            $filelist{$filename} = $fileobj;
            # reassign the temp list to the object
            $self->_filelist({%filelist});
        } # if ( exists($filehash{$fileobj->name()} )
    } # if ( $fileobj_type eq q(Archive::File) )
} # sub add

=pod

=head3 del([key|filename] => $filename)

Deletes a file from the L<Archive::FileList> object using the filename as a
key.

=cut

sub del {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my ($filename);
    my %filelist = %{$self->_filelist()};
    # since we support two different signatures for passing in the
    # Archive::File object...
    if ( exists $args{key} ) { $filename = $args{key}; }
    if ( exists $args{filename} ) { $filename = $args{filename}; }
    die q(File name/object not passed in to add method) 
        unless ( defined $filename );
    # verify we got an Archive::File object; blessed is imported from Moose
    if ( exists($filelist{$filename}) ) {
        # yes, it exists; delete the key
        delete $filelist{$filename};
        # reassign the temp list to the object
        $self->_filelist({%filelist});
    } else {
        # no, it doesn't exist; throw an error
        $logger->error(qq(key $filename));
        $logger->error(q(does not exists in the filelist));
    } # if ( exists($filelist{$filename}) )
} # sub del

=pod

=head3 delete([key|filename] => $filename)

A synonym for the B<del()> method.

=cut

sub delete {
    my $self = shift;
    $self->del(@_);
} # sub delete

=pod 

=head3 get_count()

Returns a count of how many L<Archive::File> objects are currently being
stored in the L<Archive::FileList> object.

=cut

sub get_count {
    my $self = shift;

    my %filelist = %{$self->_filelist};
    return scalar(keys(%filelist));
} # sub count

=pod

=head3 get_keys()

Returns a sorted list of filenames that are stored inside the
L<Archive::FileList> object.

=cut

sub get_keys {
    my $self = shift;
    return sort($self->get_unsorted_keys);
} # sub keys

=pod

=head3 get_unsorted_keys()

Returns an unsorted list of filenames that are stored inside the
L<Archive::FileList> object.

=cut

sub get_unsorted_keys {
    my $self = shift;
    my %filelist = %{$self->_filelist};
    return keys(%filelist);
} # sub unsorted_keys

=pod

=head3 get([key|filename] => $key)

Returns the L<Archive::File> object specified by the contents of $key.  Will
throw a warning if there is no L<Archive::File> object stored that matches the
$key.

=cut

sub get {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my ($filename, $fileobj);
    my %filelist = %{$self->_filelist()};
    # since we support two different signatures for passing in the
    # Archive::File object...
    if ( exists $args{key} ) { $filename = $args{key}; }
    if ( exists $args{filename} ) { $filename = $args{filename}; }
    if ( exists $filelist{$filename} ) {
        return $filelist{$filename};
    } else {
        $logger->warn(qq(key $filename));
        $logger->warn(q(does not exist in filelist));
        return 0;
    } # if ( exists $filelist{$filename} )
} # sub get

=pod

=head3 exists([key|filename] => $key)

Returns false by default.  Returns true if the string specified in $key is an
L<Archive::File> object is in the filelist.  

=cut

sub exists {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my ($filename, $fileobj);
    my %filelist = %{$self->_filelist()};
    # since we support two different signatures for passing in the
    # Archive::File object...
    if ( exists $args{key} ) { $filename = $args{key}; }
    if ( exists $args{filename} ) { $filename = $args{filename}; }
    if ( exists $filelist{$filename} ) {
        return 1;
    } else {
        return 0;
    } # if ( exists $filelist{$filename} )
} # sub get

#### end Package 'Archive::FileList' ####

#### Package 'Archive::File' ####
package Archive::File;
use Moose; # comes with 'strict' and 'warnings'
use Moose::Util::TypeConstraints;

=pod 

=head2 Module Archive::File

An object that holds information about a file in an archive.  You would most
likely create as many L<Archive::File> objects as you had individual files and
directories in an archive.  L<Archive::File> has the following attributes:

=over 5 

=item timestamp

The timestamp of the file as stored in the archive.

=item attributes

The attributes stored with the file in the archive.

=item  orig_size

The uncompressed size of the file stored in the archive.

=item comp_size

The compressed size of the file (if given by the compression program)

=item name

The name of the file that is a member of this L<Archive>.

=back

=cut

# these are stored in the order that they are retrieved from a 7zip archive
has q(timestamp) => ( is => q(rw), isa => q(Int) );
has q(attributes) => ( is => q(rw), isa => q(Str) );
has q(orig_size) => ( is => q(rw), isa => q(Int) );
has q(comp_size) => ( is => q(rw), isa => q(Int) );
has q(name) => ( is => q(rw), isa => q(Str) );

#### end Package 'Archive::File' ####

#### Package 'Throbber' ####
package Throbber;
use Moose; # comes with 'strict' and 'warnings'

=pod

=head2 Module Throbber

Moves some text on the screen while processing is going on in the background.
The L<Throbber> object has the following attributes:

=over 5

=item count_pulse

How many changes in state before generating a 'pulse' that is visible to the
user.

=item _beats

How many changes in state that have occured since the last 'pulse'.

=back 

=cut

has q(count_pulse) => ( is => q(rw), isa => q(Int), default => 10 );
has q(_beats) => ( is => q(rw), isa => q(Int), default => 1);

=pod

=head3 throb($number)

Tells the L<Throbber> object to see if it needs to manipulate the text on the
screen.  The L<Throbber> object does this so the user knows that the computer
is busy processing data.  The $number value is the number of lines processed
so far.

=cut

sub throb {
    my $self = shift;
    my %args = @_;

    if ( defined $args{total_lines} ) {
        if ( ( $args{total_lines} % $self->count_pulse() ) == 0 ) {
            print qq(self->_beats is ) . $self->_beats() . qq(\r);
            if ( $self->_beats == 1 ) { print q(- ); } 
            elsif ( $self->_beats == 2 ) { print q(\ ); } 
            elsif ( $self->_beats == 3 ) { print q(| ); } 
            elsif ( $self->_beats == 4 ) { 
                print q(/ ); 
                # reset the throbber beat counter
                $self->_beats(0);
            } # if ( $self->_beats == 1 )
            $self->_beats($self->_beats() + 1);
            print q(Total Lines counted: ) . $args{total_lines} . qq(\r);
        } # if ( ( $args{total_lines} % $self->count_pulse() ) == 0 )
    } # if ( defined $args{total_lines} )
} # sub throb

#### end Package 'Throbber' ####

#### Package 'main' ####
package main;

use strict;
use warnings;
use Getopt::Long;
use Log::Log4perl qw(get_logger);
use Log::Log4perl::Level;

use Pod::Usage;

my ( $colorlog, $screen_out, $common_list, $first_list, $second_list );
# colorize Log4perl output by default 
$colorlog = 1;
# show the diff report output by default
$screen_out = 1;
# show the common, first and second lists of files by default
$common_list = 1;
$first_list = 1;
$second_list = 1;

my ($VERBOSE, $first_file, $second_file, 
        $first_obj, $second_obj, $write_diffs );
my $goparse = Getopt::Long::Parser->new();
$goparse->getoptions(   q(verbose|v)                    => \$VERBOSE,
                        q(help|h)                       => \&ShowHelp,
                        q(first-file|first|1st|1=s)     => \$first_file,
                        q(second-file|second|2nd|2=s)   => \$second_file,
                        q(colorlog!)                    => \$colorlog,
                        q(write|w)                      => \$write_diffs,
                        q(screen-out|sc|so!)            => \$screen_out,
                        q(common-list|common|cl|co!)    => \$common_list,
                        q(first-list|fl|1l!)            => \$first_list,
                        q(second-list|sl|2l!)           => \$second_list,
                    ); # $goparse->getoptions

# always turn off color logs under Windows, the terms don't do ANSI
if ( $^O =~ /MSWin32/ ) { $colorlog = 0; } 

# set up the logger
my $logger_conf = qq(log4perl.rootLogger = INFO, Screen\n);
if ( $colorlog ) {
    $logger_conf .= qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::ScreenColoredLevels\n);
} else {
    $logger_conf .= qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::Screen\n);
} # if ( $Config->get(q(colorlog)) )

$logger_conf .= qq(log4perl.appender.Screen.stderr = 1\n)
    . qq(log4perl.appender.Screen.layout = PatternLayout\n)
    . q(log4perl.appender.Screen.layout.ConversionPattern = %d %p %m%n)
    . qq(\n);
#log4perl.appender.Screen.layout.ConversionPattern = %d %p> %F{1}:%L %M - %m%n
# create the logger object
Log::Log4perl::init( \$logger_conf );
my $logger = get_logger("");
# change the log level from INFO if the user requests more gar-bage
if ( $VERBOSE ) { $logger->level($DEBUG); }

# check to make sure we can read the input files
# if they're both readable, read them and bless them into objects
if ( defined $first_file ) {
    # read in the file and bless it into an Archive object
    $first_obj = eval { Archive->new( archfilename => $first_file ); };
    if ( $@ ) { &FileReadDie($@); }
} else {
    $logger->fatal(q(First file not specified with --first-file switch));
    &HelpDie;
} # if ( defined $first_file )

if ( defined $second_file ) {
    # read in the file and bless it into an Archive object
    $second_obj = eval { Archive->new( archfilename => $second_file ); };
    if ( $@ ) { &FileReadDie($@); }
} else {
    $logger->fatal(q(Second file not specified with --second-file switch));
    &HelpDie;
} # if ( defined $first_file ) 

# bad hack; makes the split() into an array, then accesses the last element of
# that array
my $program_name = (split(/\//,$0))[-1];

$logger->info(qq(=-=-=-=-=-= Begin $program_name =-=-=-=-=-=));
$logger->info(qq(Parsing first archive file));
$first_obj->parse();
$logger->info(qq(Parsing second archive file));
$second_obj->parse();

# create the diff object prior to entering the below closure blocks
my $diff = Archive::Diff->new( first => $first_obj, second => $second_obj );
$logger->info(qq(=-=-=-=-=-= Archive Diff Report =-=-=-=-=-=));
$logger->info(qq(=-=-=-=-=-= 'Before' Report =-=-=-=-=-=));
$diff->simple_stats();
$diff->simple_diff();
$logger->info(qq(=-=-=-=-=-= 'After' Report =-=-=-=-=-=));
$diff->simple_stats();

# print to the screen first
if ( $screen_out ) {
    if ( $common_list ) {
        $logger->info(qq(=-=-=-=-=-= Common File List =-=-=-=-=-=));
        foreach ( $diff->common->get_keys() ) { $logger->info($_); }
    } # if ( $common_list )
    if ( $first_list ) {
        $logger->info(qq(=-=-=-=-=-= 'First' File List =-=-=-=-=-=));
        foreach ( $diff->first->filelist->get_keys() ) { $logger->info($_); }
    } # if ( $first_list )
    if ( $second_list ) {
        $logger->info(qq(=-=-=-=-=-= 'Second' File List =-=-=-=-=-=));
        foreach ( $diff->second->filelist->get_keys() ) { $logger->info($_); }
    } # if ( $second_list )
} # if ( $screen_out )

if ( $write_diffs ) {
    # get the date for creating an output file 
    my $date = qx/date +%Y.%j/;
    chomp($date);
    my $outfile;
    # loop across these numbers in order to find a free filename
    foreach ( 1..99 ) {
        $outfile = q(diffs.) . $date . sprintf(q(.%02d), $_) . q(.txt);
        if ( ! -e $outfile ) { last; }
    } # foreach ( 1..99 )
    # found a free filename, open the filehandle and write the diff file 
    $logger->info(qq(Writing diff list output to $outfile));
    open(DIFF_FH, q(>) . $outfile);

    # files common between both objects
    if ( $common_list ) {
        print DIFF_FH qq(=-=-=-=-=-= Common File List =-=-=-=-=-=\n);
        foreach ( $diff->common->get_keys() ) { print DIFF_FH $_ . qq(\n); }
    } # if ( $common_list )
    
    # files that are only in the first object
    if ( $first_list ) {
        print DIFF_FH qq(=-=-=-=-=-= 'First' File List =-=-=-=-=-=\n);
        print DIFF_FH qq(First file name:\n);
        print DIFF_FH $diff->first->archfilename() . qq(\n);
        foreach ( $diff->first->filelist->get_keys() ) { 
            print DIFF_FH $_ . qq(\n); 
        } # foreach ( $diff->first->filelist->get_keys() )
    } # if ( $first_list )

    # files that are only in the second object
    if ( $second_list ) {
        print DIFF_FH qq(=-=-=-=-=-= 'Second' File List =-=-=-=-=-=\n);
        print DIFF_FH qq(Second file name:\n);
        print DIFF_FH $diff->second->archfilename() . qq(\n);
        foreach ( $diff->second->filelist->get_keys() ) { 
            print DIFF_FH $_ . qq(\n); 
        } # foreach ( $diff->second->filelist->get_keys() )
    } # if ( $second_list ) 

    # we're done, close the filehandle
    close(DIFF_FH);
} # if ( $write_diffs )

exit 0;

sub HelpDie {
    my $logger = get_logger();
    $logger->fatal(qq(Use '$0 --help' to view script options));
    exit 1;
} # sub HelpDie 

sub FileReadDie {
    my $error_msg = shift;
    my $logger = get_logger();
    $logger->fatal(qq(Hmmm, something happened trying to read a file));
    if ( $logger->is_debug() ) { 
        print $error_msg; 
    } else {
        $logger->fatal(qq(Use --verbose for more error output));
    } # if ( $logger->is_debug() )
    &HelpDie;
} # sub FileReadDie

# simple help subroutine
sub ShowHelp {
# shows the POD documentation (short or long version)
    my $whichhelp = shift;  # retrieve what help message to show
    shift; # discard the value

    # call pod2usage and have it exit non-zero
    # if if one of the 2 shorthelp options were not used, call longhelp
    if ( ($whichhelp eq q(help))  || ($whichhelp eq q(h)) ) {
        pod2usage(-exitstatus => 1);
    } else {
        pod2usage(-exitstatus => 1, -verbose => 2);
    } # if ( ($whichhelp eq q(help))  || ($whichhelp eq q(h)) )
} # sub ShowHelp

#### end Package main ####

=pod

=head1 AUTHOR

Brian Manning E<lt>elspicyjack at gmail dot comE<gt>

=cut

# vi: set sw=4 ts=4 cin:
# end of line

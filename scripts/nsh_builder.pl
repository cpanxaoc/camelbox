#!/usr/bin/env perl

# $Id$
# $Date$
#
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

# A script to generate the camelbox_filelist.nsh NSIS script with the
# checksums in the right place for SnarfUnpack to use when downloading
# packages

#==========================================================================
# Copyright (c)2008 by Brian Manning <elspicyjack at gmail dot com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
#==========================================================================

# things to keep track of for the NSIS package list:
#
# for each file:
# - Which package group the file belongs to (toplevel, core, dev, "Core
# Gtk2-Perl Packages"
# - The filename match pattern (qr/gtk-core-bin/)
# - The Section name of the package ("Core GTK Binaries")
# - The Section_ID name (gtk-core-bin_id)
# - The SectionIn list (used with selecting groups of packages at
# installtime)
# 
# for package groups:
# - short name of the group
# - long/display name of the group
# - group members (package files)

=pod

=head1 NAME

B<nsh_builder.pl> - Generate Camelbox filelists of one or more types

=head1 VERSION

The SVN version of this file is $Revision$. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl nsh_builder.pl [options]

 --help|-h          Show this help message
 --verbose|-v       Verbose script output
 --startdir|-s      Start searching for files in this directory
 --timestamp|-t     Timestamp to use with output filenames
 --jsonfile|-j      JSON file that describes packages and groups

 Example usage:

 perl nsh_builder.pl --jsonfile file.json --startdir . \
     --timestamp 200x.xxx.x

=head1 PACKAGES

=cut

#### Package 'Hump::JSON::Node' ####
package Hump::JSON::Node;

use strict;
use warnings;

my %node_hash;

=pod

=head2 Hump::JSON::Node

An individual JSON node, which will have one or more key/value pairs as read
from the JSON file.

=cut

sub new {
    my $class = shift;
    my %args = @_;

    if ( ! defined($args{jsonvar}) ) {
        warn qq(ERROR: Hump::JSON::Node was created without passing\n);
        die qq('jsonvar' hash reference);
    } # if ( ! defined($args{jsonvar}) )

	# the file exists, bless it into an object
	my $self = bless({ 	
        jsonvar => $args{jsonvar}, 
		verbose => $args{verbose} }, 
        $class);

    # 'cast' the jsonvar argument into a hash
    foreach my $jsonkey ( %{$args{jsonvar}} ) {
        $self->set(key => $jsonkey, value => $args{jsonvar}{$jsonkey});
    } # foreach my $jsonkey ( %{$args{jsonvar}} )
    # return the object to the caller
    return $self;
} # sub new

=pod 

=head3 new( jsonvar => {JSON variable reference}, verbose => {0|1} )

Creates a L<Hump::JSON::Node> object.  Takes the following arguments:

=over 4

=item jsonvar 

A reference to the hash containing the key/value pairs to be stored in the
L<Hump::JSON::Node> object.

=item verbose 

Verbose debugging output.  (0 = false, 1 = true; default = 0) 

=back

=cut

sub set {
    my $self = shift;
    my %args = @_;

    die qq(ERROR: set method called without 'key'/'value' arguments)
        unless ( exists $args{key} && exists $args{value} );

    # so store it already
    $node_hash{$args{key}} = $args{value};
} # sub set

=pod 

=head3 set( key => {key}, value => {value} )

Sets values in an L<Hump::JSON::Node> object.  Takes the following
arguments:

=over 4

=item key 

Key to use in object hash.

=item value 

Value to store with key in object hash.

=back

=cut

sub get {
    my $self = shift;
    my %args = @_;

    die qq(ERROR: get method called without 'key' argument)
        unless ( defined $args{key} );

    if ( exists $node_hash{$args{key}} ) {
        return $node_hash{$args{key}};
    } else {
        warn qq(WARNING: Key ) . $args{key} 
            . qq( does not exist in this object\n);
    } # if ( exists $node_hash{$args{key}} )
} # sub get

=pod 

=head3 get( key => {key} )

Gets values from an L<Hump::JSON::Node> object.  Takes the following
arguments:

=over 4

=item key 

Key describing value to retrieve from object hash.

=back

If the key does not exist in the L<Hump::JSON::Node> hash, a warning will be
given.

=cut

#### Package 'Hump::JSON::Manifest' ####
package Hump::JSON::Manifest;
# a package manifest containing a list of package groups and individual
# packages
use strict;
use warnings;

my @_manifest;

sub new {
    my $class = shift;
    my %args = @_;

    if ( ! defined($args{manifest}) ) {
        warn qq(ERROR: Hump::JSON::Manifest was created without passing\n);
        die qq('manifest' hash reference);
    } # if ( ! defined($args{jsonvar}) )

	# the file exists, bless it into an object
	my $self = bless({ verbose => $args{verbose} }, $class);

    @_manifest = @{$args{manifest}};
    return $self;
} # sub new 

# FIXME PODs please

sub get_manifest {
# return the list of packages described in the JSON file
    return @_manifest; 
} # sub get_manifest

# FIXME PODs please

sub dump_manifest {
    foreach my $manifest_key ( @_manifest ) {
        print qq(manifest: $manifest_key\n);
    } # foreach my $manifest_key ( @{$manifest} ) 
} # sub dump_manifest    

# FIXME PODs please

#### Package 'Hump::JSON::Objects' ####
package Hump::JSON::Objects;
# a hash of package objects
use strict;
use warnings;

my %_object_hash;
my $_object_type;

=pod

=head2 Hump::JSON::Objects

An object that stores one or more L<Hump::JSON::Node> objects.  The objects
could be either individual Camelbox packages, or the package group
descriptions.

=cut

sub new {
    my $class = shift;
    my %args = @_;

    if ( ! defined($args{objects}) ) {
        warn qq(ERROR: Hump::JSON::Objects object created without passing\n);
        die qq('objects' hash reference);
    } # іf ( ! defined($args{objects}) ) 

    if ( ! defined($args{object_type}) ) {
        warn qq(ERROR: Hump::JSON::Objects object created without passing\n);
        die "'object_type' string (a description of the object) ";
    } # іf ( ! defined($args{objects}) ) 
    $_object_type = $args{object_type};

    # bless an objects object
	my $self = bless({ verbose => $args{verbose} }, $class);

    # loop across all of the nodes in the JSON object; add them to the
    # internal objects hash using the key in the JSON object as the key in the
    # internal objects hash
    foreach my $object_id ( keys(%{$args{objects}}) ) {
        $_object_hash{$object_id} 
            = Hump::JSON::Node->new( 
                    jsonvar => $args{objects}{$object_id} );
    } # foreach my ( keys(%{$self->get_packages()}) )

    print qq(Picked up ) . scalar(keys(%_object_hash)) . qq( )
        . $_object_type . qq( objects\n)
        if ( $args{verbose} );

    return $self;
} # sub new

=pod 

=head3 new( jsonvar => {JSON variable reference}, verbose => {0|1} )

Creates a L<Hump::JSON::Node> object.  Takes the following key/value pairs
as arguments:

=over 4

=item jsonvar 

A reference to the hash containing the key/value pairs to be stored in the
L<Hump::JSON::Node> object.

=item verbose

Verbose debugging output.  (0 = false, 1 = true; default = 0) 

=back

=cut

sub get_package {
    my $self = shift;
    my %args = @_;

    if ( defined $args{object_id} 
            && exists $_object_hash{$args{object_id}} ) {
        return $_object_hash{$args{object_id}};
    } else {
        warn qq(package ) . $args{object_id} . qq(not defined/empty);
    }# if ( exists $object_hash{$args{object_id}} )
} # sub get_package

=pod 

=head3 get_package( object_id => {package name} )

Returns the package identified by B<object_id>.  Warns with an error if
B<object_id> does not exist.

=cut

sub get_packages {
    my $self = shift;

    if ( scalar(keys(%_object_hash)) > 0 ) {
        return sort(keys(%_object_hash));
    } else {
        warn qq(Warning: No packages are stored in the package hash\n);
    } # if ( scalar(keys(%object_hash)) > 0 )
} # sub get_package

=pod 

=head3 get_package( object_id => {package name} )

Returns the package identified by B<object_id>.  Warns with an error if
B<object_id> does not exist.

=cut

sub dump_packages {
    my $self = shift;
    foreach my $package_key ( $self->get_packages() ) {
        print qq(package: $package_key\n);
    } # foreach my $package_key ( $package_obj->get_packages() )
} # sub dump_packages

=pod 

=head3 get_package( package_id => {package name} )

Returns the package identified by B<package_id>.  Warns with an error if
B<package_id> does not exist.

=cut

#### Package 'Hump::JSON::Distribution' ####
package Hump::JSON::Distribution;
use strict;
use warnings;
use JSON;

sub new {
	my $class = shift;
	my %args = @_;
	
    die qq(ERROR: JSON filelist undefined) unless defined($args{jsonfile});

	if ( ! -f $args{jsonfile} ) {
		die(qq(ERROR: JSON file ) . $args{jsonfile} . q( does not exist));
	} # if ( -f $args{jsonfile} )

	# the file exists, bless it into an object
	my $self = bless({ 	jsonfile => $args{jsonfile}, 
						verbose => $args{verbose} }, $class);
	open(FH, $self->{jsonfile}) 
		|| die qq(Can't open file ) . $self->{jsonfile} . qq(: $!);
	binmode(FH);
    my $parser = JSON->new->ascii->pretty->allow_nonref;
    my $json_string;
    while(<FH>) {
        $json_string .= $_;
    } # while(<FH>)
	$self->{jsonobj} = $parser->decode($json_string);
    $self->{_manifest_obj} = Hump::JSON::Manifest->new(
            manifest    => $self->{jsonobj}{manifest},
            verbose     => $self->{verbose} );

    $self->{_package_obj} = Hump::JSON::Objects->new( 
            objects     => $self->{jsonobj}{packages},
            object_type => q(package),
            verbose     => $self->{verbose} );
	return $self;
} # sub new

sub get_package_obj {
# return the list of packages described in the JSON file
    my $self = shift;
    return $self->{_package_obj};
} # sub get_package_obj

sub get_manifest_obj {
# return the package manifest described in the JSON file
    my $self = shift;
    return $self->{_manifest_obj};
} # sub get_manifest_obj

#### Package 'Hump::File::Stat' ####
package Hump::File::Stat;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $filename = shift;
	my $self = bless ({ filename => $filename }, $class);
} # sub new

=pod

=head2 Module Hump::File::Stat

A wrapper around the Perl C<stat()> function.  Has the same attributes as
what's returned from the C<stat()> function, but with a little nicer naming
convention.  The following attributes are defined:  C<device>, C<inode>,
C<mode>, C<num_hardlinks>,  C<uid>, C<gid>, C<rdev> (for block/character
devices), C<size>, C<atime>, C<mtime>, C<ctime>, C<blocksize>, C<blocks>
(actual number of blocks allocated).

=cut

#### Package 'Hump::File' ####
package Hump::File;
use strict;
use warnings;
use Digest::MD5;

=pod

=head2 Module Hump::File

A file on the filesystem.  Has the following attributes:

=over 5

=item stat

A C<Hump::File::Stat> object, which is a wrapper around the Perl C<stat()>
function.

=item filename 

The name of the archive file.  The file is checked to see if it exists and is
readable when an object is created from this class.

=item md5sum

The MD5 checksum for the file.  Not available for directories.

=item crcsum

The CRC32 checksum for the file.  Not available for directories.

=back

=cut

sub new {
	my $class = shift;
	my %args = @_;
	
	if ( ! -f $args{filename} ) {
		die(qq(ERROR: filename ) . $args{filename} . q( does not exist));
	} # if ( -f $args{filename} )

	# the file exists, bless it into an object
	my $self = bless({ 	filename => $args{filename}, 
						verbose => $args{verbose} }, $class);
	open(FH, $self->{filename}) 
		|| die qq(Can't open file ) . $self->{filename} . qq(: $!);
	binmode(FH);
	$self->{md5sum} = Digest::MD5->new->addfile(*FH)->hexdigest;
	$self->{unpacked_size} = $self->get_unpacked_size();
	return $self;
} # sub new

sub verbose  {
	my $self = shift;
	return $self->{verbose};
} # sub verbose

sub filename {
	my $self = shift;
	return $self->{filename};
} # sub filename

sub md5sum { 
	my $self = shift;
	return $self->{md5sum};
} # sub md5sum

sub get_unpacked_size {
	my $self = shift;

	my $total_unarchived_size = 0;

    my $cmd;
    if ( $^O eq q(MSWin32) ) {
    	$cmd = q(lzma -so d ) . $self->filename . q( 2>nul: | tar -tv);
    } else {
    	$cmd = q(lzma -c -d ) . $self->filename . q( 2>/dev/null | tar -tv);
    } # if ( $^O eq q(MSWin32) )
	my $archive_list = qx/$cmd/;
	chomp($archive_list);
	if ( length($archive_list) > 0 ) {
		#print "archive list is\n";
		#print "$archive_list\n";
		my @split_list = split(/\n/, $archive_list);
		# work on one line at a time
		foreach my $line ( @split_list ) {
			$line =~ s/  +/ /g;
			my $archive_file_size = (split(/ /, $line))[2];
			# skip empty files/directories
			next if ( $archive_file_size == 0 );
			my $archive_file_name = (split(/ /, $line))[5];
			print(qq(Size of file $archive_file_name is $archive_file_size\n))
				if ( $self->verbose );
			$total_unarchived_size += $archive_file_size;
		} # foreach my $line ( @split_list )
	} else {
		warn(q(Hmmm.  Something went wrong with lzma/tar command:));
		warn(qq($cmd));
	} # if ( length($archive_list) > 0 )
	return $total_unarchived_size;
} # sub get_unpacked_size

#### end package Hump::File ####

#### begin package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use File::Find::Rule;
use Pod::Usage;

my $o_colorlog = 1;
my $VERBOSE = 0;
my ($o_timestamp, $o_startdir, $o_jsonfile);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions(  q(verbose|v)                    => \$VERBOSE,
                        q(help|h)                       => \&ShowHelp,
                        q(timestamp|t=s)                => \$o_timestamp,
                        q(startdir|s=s)                 => \$o_startdir,
						q(jsonfile|j:s)                 => \$o_jsonfile,
                    ); # $go_parse->getoptions

# verify the start directory exists
if ( ! defined $o_startdir ) { 
	warn(qq(ERROR: start directory needed for searching;\n));
	&HelpDie;
} # if ( ! defined $o_startdir )

# script operations:
# - read in the JSON document
# - match each file requested in the JSON document with the file located in
# the %archive_filelist hash; the filename in the hash may have to be
# mangled/shortened so it will match what's listed in the JSON file
# - print out the NSH file, with the groups and archive files in thier right
# places
# - print out a report of extra files found on the filesystem, as well as
# patterns in the JSON file that didn't have a corresponding file on the
# filesystem

# read in the JSON distro file
my $distro = Hump::JSON::Distribution->new( 
				verbose => $VERBOSE,
                jsonfile => $o_jsonfile );

# get the manifest of this NSIS packages list
my $manifest = $distro->get_manifest_obj();
$manifest->dump_manifest;

# grab the packages object
my $packages = $distro->get_package_obj();
# pump and dump
$packages->dump_packages();

# get the list of packages in the JSON file
#my $groups = $distro->get_groups;
# get the list of packages in the JSON file
#my $packages = $distro->get_packages;

exit 1;
if ( ! -d $o_startdir ) {
	die(qq(ERROR: start directory $o_startdir does not exist));
} # if ( ! -d $o_startdir )

my @files = File::Find::Rule->file()->name(q(*.lzma))->in($o_startdir);

die(qq(ERROR: No *.lzma files found in $o_startdir\n)) 
	unless ( scalar(@files) > 0 );

print qq(Found ) . scalar(@files) . qq( files in $o_startdir\n);

# build a list of files that can have files removed when they match filenames
# contained in the JSON document
my %archive_filelist;
foreach my $archive_file (@files) {
	my $humpfile = Hump::File->new( verbose => $VERBOSE, 
									filename => $archive_file );
    $archive_filelist{$humpfile->filename()} = $humpfile;
    #print q(file: ) . $humpfile->filename() . qq(\n);
    #print qq(md5sum: ) . $humpfile->md5sum() . qq(\n);
	# shorten it to kilobytes, this is what NSIS is expecting
    #my $unpacked_size_in_kilobytes = sprintf("%d",
    #	$humpfile->get_unpacked_size / 1000);
    #print qq(total size of archive when unpacked: ) 
    #	. $unpacked_size_in_kilobytes . qq(k\n);
} # foreach my $archive_file (@files)

exit 0;

#### end main ####

#### main subroutines ####

sub HelpDie {
    die(qq(Use '$0 --help' to view script options\n));
    exit 1;
} # sub HelpDie 

sub ShowHelp {
# shows the POD documentation (short or long version)
    my $whichhelp = shift;  # retrieve what help message to show
    shift; # discard the value

    # call pod2usage and have it exit non-zero
    # if if one of the 2 shorthelp options were not used, call longhelp
    if ( ($whichhelp eq q(help))  || ($whichhelp eq q(h)) ) {
        pod2usage(-exitstatus => 1,
			-message => qq(Hint: 'perldoc $0' to see full help text));
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

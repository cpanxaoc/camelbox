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

package Hump::MiscHandlers;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = bless ({}, $class);
} # sub new

sub header {
    # FIXME perl-ify this
    my $date = qx/date +%Y.%j.%H%mZ | tr -d '\n'/;
    print <<"HEREDOC"
#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/nsh_builder.pl)
# DATE:     $date 
#
# COMMENT:  automatically generated file; edit at your own risk

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

#### SECTIONS ####
HEREDOC
} 

sub sec_writeuninstaller {
    print <<'HEREDOC'
Section "-WriteUninstaller"
    SectionIn RO
    SetOutPath "$INSTDIR"
    CreateDirectory "$INSTDIR\bin"
    writeUninstaller "$INSTDIR\camelbox_uninstaller.exe"
    #writeUninstaller "$INSTDIR\bin\camelbox_uninstaller.exe"
SectionEnd ; WriteUninstaller 
HEREDOC
}  # sub sec_writeuninstaller

sub sec_environmentvariables {
    print <<'HEREDOC'

SectionGroup /e "Environment Variables"
    Section "Add Camelbox to PATH variable"
        SectionIn 1 2 3 4 5 6 7 8 9
        StrCpy $1 "$INSTDIR\bin"
        Push $1
        DetailPrint "Adding to %PATH%: $1"
        Call AddToPath
    SectionEnd
SectionGroupEnd ; "Environment Variables"
HEREDOC
} # sub sec_environmentvariables

sub sec_uninstall {
    print <<'HEREDOC'
Section "Uninstall"
    SectionIn RO
    # delete the uninstaller first
    DetailPrint "Removing installer files"
    #delete "${INSTALL_PATH}\bin\camelbox_uninstaller.exe"
    delete "${INSTALL_PATH}\camelbox_uninstaller.exe"
    # remove the binpath
    StrCpy $1 "${INSTALL_PATH}\bin"
    Push $1
    DetailPrint "Removing from %PATH%: $1"
    Call un.RemoveFromPath
    # then delete the other files/directories
    DetailPrint "Removing ${INSTALL_PATH}"
    RMDir /r ${INSTALL_PATH}
SectionEnd ; Uninstall
HEREDOC
} # sub sec_uninstall

sub footer {
    print <<'HEREDOC'
# blank subsection
#   Section "some-package (extra notes, etc.)"
#       AddSize  # kilobytes
#       push "package-name.YYYY.JJJ.V.tar.lzma"
#       SectionGetText ${some-package_id} $0
#       push $0
#       Call SnarfUnpack
#   SectionEnd

# vim: filetype=nsis paste
HEREDOC
} # sub footer

#### Package 'Hump::JSON::Node' ####
package Hump::JSON::Node;
use strict;
use warnings;

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
		verbose => $args{verbose},
        node_hash => {},
        }, 
        $class);

    # 'cast' the jsonvar argument into a hash and then enumerate over it to
    # gain access to the keys stored inside
    foreach my $jsonkey ( keys(%{$args{jsonvar}}) ) {
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

sub keys {
    my $self = shift;
    # return a list of keys
    return keys(%{$self->{node_hash}});
} # sub set

=pod 

=head3 keys()

Returns the keys of a L<Hump::JSON::Node> object.

=cut

sub set {
    my $self = shift;
    my %args = @_;

    die qq(ERROR: set method called without 'key'/'value' arguments)
        unless ( exists $args{key} && exists $args{value} );

    # so store it already
    warn qq(Hump::JSON::Node->set: ) 
        . $args{key} . q(:) . $args{value} . qq(\n)
        if ( $self->{verbose} );
    $self->{node_hash}->{$args{key}} = $args{value};
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

    if ( exists $self->{node_hash}->{$args{key}} ) {
        return $self->{node_hash}->{$args{key}};
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


#### Package 'Hump::JSON::Objects' ####
package Hump::JSON::Objects;
# a hash of package objects
use strict;
use warnings;

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

    # bless an objects object
	my $self = bless({ 
            verbose => $args{verbose} , 
            object_type => $args{object_type},
            objects => {},
            }, $class);

    # loop across all of the nodes in the JSON object; add them to the
    # internal objects hash using the key in the JSON object as the key in the
    # internal objects hash
    foreach my $object_id ( keys(%{$args{objects}}) ) {
        warn qq(- creating node for $object_id\n) if ( $self->{verbose} );
        $self->{objects}->{$object_id} 
            = Hump::JSON::Node->new( 
                    verbose => $self->{verbose},
                    jsonvar => $args{objects}{$object_id} );
    } # foreach my ( keys(%{$self->get_objects()}) )

    print qq(Picked up ) . scalar( $self->get_object_count() ) . qq( )
        . $self->{object_type} . qq( objects\n)
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

sub object_exists {
    my $self = shift;
    my %args = @_;

    if ( defined $self->{objects}
            && exists $self->{objects}->{$args{object_id}} ) {
        return 1;
    } else {
        return 0;
    } # if ( exists $object_hash{$args{object_id}} )
} # sub get_object

=pod 

=head3 object_exists( object_id => {package name} )

Returns true (1) if the object identified by B<object_id> exists in the
objects hash.  Returns false (0) otherwise.

=cut

sub get_object {
    my $self = shift;
    my %args = @_;

    if ( defined $self->{objects}
            && exists $self->{objects}->{$args{object_id}} ) {
        return $self->{objects}->{$args{object_id}};
    } else {
        warn qq(package ) . $args{object_id} . qq( not defined/empty);
    }# if ( exists $object_hash{$args{object_id}} )
} # sub get_object

=pod 

=head3 get_object( object_id => {package name} )

Returns the package identified by B<object_id>.  Warns with an error if
B<object_id> does not exist.

=cut

sub get_objects {
    my $self = shift;

    if ( scalar(keys(%{$self->{objects}}) > 0 )  ) {
        return sort(keys(%{$self->{objects}}));
    } else {
        warn qq(Warning: No objects are stored in the object hash\n);
    } # if ( scalar(keys($self->{objects}) > 0 ) 
} # sub get_objects

=pod 

=head3 get_objects()

Returns the keys to all of the objects stored in the %_object_hash

=cut

sub get_object_count {
    my $self = shift;

    if ( scalar(keys(%{$self->{objects}}) > 0 )  ) {
        return scalar(keys(%{$self->{objects}}));
    } else {
        return 0;
    } # if ( scalar(keys($self->{objects}) > 0 ) 
} # sub get_objects

=pod 

=head3 get_object_count()

Returns the integer count of all of the objects contained in the object hash
attribute.

=cut

sub dump_objects {
    my $self = shift;
    foreach my $object_key ( $self->get_objects() ) {
        print $self->{object_type} . qq(: $object_key\n);
    } # foreach my $object_key ( $self->get_objects() )
} # sub dump_objects

=pod 

=head3 dump_objects()

Prints the keys to all of the objects in the object hash, prefixed by the
object type.

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

    $self->{_group_obj} = Hump::JSON::Objects->new( 
            objects     => $self->{jsonobj}{groups},
            object_type => q(group),
            verbose     => $self->{verbose} );
	return $self;
} # sub new

sub get_manifest_obj {
# return the package manifest described in the JSON file
    my $self = shift;
    return $self->{_manifest_obj};
} # sub get_manifest_obj

sub get_group_obj {
# return the list of groups described in the JSON file
    my $self = shift;
    return $self->{_group_obj};
} # sub get_group_obj

sub get_package_obj {
# return the list of packages described in the JSON file
    my $self = shift;
    return $self->{_package_obj};
} # sub get_package_obj

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
	
    if ( exists $args{filename} && exists $args{file_regex} ) {
        warn qq(ERROR: use either 'filename' *OR* 'file_regex'\n);
        die qq( parameters when creating a Hump::File object (not both)\n);
    } elsif ( exists $args{filename} ) {
    	if ( ! -f $args{filename} ) {
	    	die(qq(ERROR: filename ) . $args{filename} . q( does not exist));
    	} # if ( -f $args{filename} )
    } elsif ( exists $args{file_regex} ) {
        
    } elsif ( defined $args{pretend} ) {
        # pretend that all of the files exist (for testing)
        
    } # if ( exists $args{filename} )
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

#### begin package Hump::WriteBlocks ####
package Hump::WriteBlocks;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = bless ({}, $class);
} # sub new

sub output_section { 
    my $self = shift;
    my %args = @_;

    my $indent = q();
    if ( exists $args{indent} ) { $indent = q(    ); }
    # a Hump::JSON::Node object
    my $package = $args{package_obj};
    # a scalar string
    my $pkg_id = $args{package_id};

    print $indent . qq(Section ") 
        . $package->get(key => q(description)) . qq(" $pkg_id\n);
    print $indent . q(    SectionIn ) 
        . join(q( ), @{$package->get(key => q(sectionin_list))}) . qq(\n);
    print $indent . qq(SectionEnd ; $pkg_id\n);
} # sub output_section

sub output_group {
    my $self = shift;
    my %args = @_;

    # FIXME check for the '/e' switch (expand group) here
    my $group = $args{group_obj};
    my $packages = $args{packages};
    print qq(\nSectionGroup ") 
        . $group->get(key => q(description)) . qq("\n);
    foreach my $section_item ( 
        @{$group->get(key => q(sections_list))} ) {
            my $group_package = $packages->get_object(
                                object_id => $section_item );
            $self->output_section( 
                                indent => 1,
                                package_obj => $group_package,
                                package_id => $section_item,
            ); # $self->output_section
        } # foreach my $section_item
        print qq(SectionGroupEnd ; ) 
            . $group->get(key => q(description)) . qq(\n);
} # sub output_group

#### begin package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use File::Find::Rule;
use Pod::Usage;

my $o_colorlog = 1;
my $VERBOSE = 0;
my ($o_timestamp, $o_startdir, $o_jsonfile, $o_pretend);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions(  q(verbose|v)                    => \$VERBOSE,
                        q(help|h)                       => \&ShowHelp,
                        q(timestamp|t=s)                => \$o_timestamp,
                        q(startdir|s=s)                 => \$o_startdir,
						q(jsonfile|j:s)                 => \$o_jsonfile,
						q(pretend|p)                    => \$o_pretend,
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

# handlers for non-package and non-group entries in the manifest
my $mischandler = Hump::MiscHandlers->new();
# object that writes blocks of NSIS scripting
my $writeblocks = Hump::WriteBlocks->new();
# file/package operations
my $pa

# get the manifest of this NSIS packages list
my $manifest = $distro->get_manifest_obj();

# get the list of groups in the JSON file
my $groups = $distro->get_group_obj();

# grab the packages object
my $packages = $distro->get_package_obj();

if ( $VERBOSE ) {
    $manifest->dump_manifest;
    $groups->dump_objects();
    $packages->dump_objects();
} # if ( $VERBOSE )

# walk the manifest list, going through each group, package or special
# handler, and outputting the NSIS script info for each type of object
foreach my $manifest_key ( $manifest->get_manifest() ) {
    if ( $manifest_key =~ /^group/ ) {

        # $current_group is a Hump::JSON::Node
        my $current_group = $groups->get_object( object_id => $manifest_key );
        if ( $VERBOSE ) {
            warn qq(group object '$manifest_key'\n);
            warn q(  keys: ) . join(q(:), $current_group->keys()) . qq(\n);
        } # if ( $VERBOSE )
        $writeblocks->output_group( 
                        packages => $packages,
                        group_obj => $current_group, 
        ); # $writeblocks->output_group



    } elsif ( $packages->object_exists(object_id => $manifest_key) ) {
        warn(qq(package object '$manifest_key'\n)) if ( $VERBOSE);
        # $current_package is a Hump::JSON::Node
        my $current_package = $packages->get_object(
                                object_id => $manifest_key );
        warn q(  keys: ) . join(q(:), $current_package->keys()) . qq(\n)
            if ( $VERBOSE );
        $writeblocks->output_section(
                        package_id      => $manifest_key,
                        package_obj     => $current_package,
        ); # $writeblocks->output_section
    } else {
        warn qq(handler object '$manifest_key'\n) if ( $VERBOSE );
        if ( $mischandler->can($manifest_key) ) {
            $mischandler->$manifest_key;
            print qq(\n);
        } else {
            warn qq(Warning: don't know how to '$manifest_key');
        } # if ( $mischandlers->can($manifest_key) )
    } # if ( $manifest_key =~ /^group/ )
} # foreach my $manifest_key ( $manifest->get_objects() )

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

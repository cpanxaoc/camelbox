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

B<nsh_builder.pl> - Generate Camelbox NSIS filelists

=head1 SYNOPSIS

 perl nsh_builder.pl [options]

 --help|-h          Show this help message
 --verbose|-v       Verbose script output
 --startdir|-s      Start searching for archive files in this directory
 --jsonfile|-j      JSON file that describes packages and groups
 --outfile|-o       Write the NSH script output to this file

 --nocolorlog       Turn off ANSI colors for logging messages
 --debug            Even more verbose script execution

 Color logging is disabled by default on the 'MSWin32' platform.

 Example usage:

 perl nsh_builder.pl --jsonfile file.json --startdir .

=head1 PACKAGES

=cut

package Hump::BlockHandlers;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);
use Date::Format; # formats the header below

sub new {
	my $class = shift;
    my %args = @_;
    my $logger = get_logger();
    
    $logger->logcroak(qq(Output filehandle parameter missing)) 
        unless ( defined $args{output_filehandle} );

    # create the object
	my $self = bless ({ 
        output_filehandle => $args{output_filehandle},
    }, $class);
} # sub new

sub header {
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};
	my @gmtime = gmtime;
	my $date = strftime(q(%Y.%j.%H%MZ), @gmtime );
    print $OUT_FH <<"HEREDOC"
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
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};

    print $OUT_FH <<'HEREDOC'
Section "-WriteUninstaller"
    SectionIn RO
    SetOutPath "$INSTDIR"
    CreateDirectory "$INSTDIR\bin"
    writeUninstaller "$INSTDIR\camelbox_uninstaller.exe"
	CreateDirectory "$INSTDIR\share\pkglists"
	File "/oname=$INSTDIR\share\pkglists\_version_list.txt" ${VERSIONS_FILE}
SectionEnd ; WriteUninstaller 
HEREDOC
}  # sub sec_writeuninstaller

sub sec_environmentvariables {
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};

    print $OUT_FH <<'HEREDOC'

SectionGroup /e "Camelbox Environment"
    Section "Add Camelbox to PATH variable"
        SectionIn 1 2 3 4 5 6 7 8 9
        StrCpy $1 "$INSTDIR\bin"
        Push $1
        DetailPrint "Adding to %PATH%: $1"
        Call AddToPath
    SectionEnd
	Section "Create Camelbox URL Files"
        SectionIn 1 2 3 4 5 6 7 8
		DetailPrint "Creating Camelbox URL Files"
		Call CreateCamelboxURLs
	SectionEnd
	Section "Create Perl URL Files"
        SectionIn 1 2 3 4 5 6 7 8
		DetailPrint "Creating Perl URL Files"
		Call CreatePerlURLs
	SectionEnd
	Section "Create Start Menu Shortcuts"
        SectionIn 1 2 3 4 5 6 7 8
		DetailPrint "Creating Start Menu Shortcuts"
		Call CreateCamelboxShortcuts
	SectionEnd
SectionGroupEnd ; "Camelbox Environment"
HEREDOC
} # sub sec_environmentvariables

sub sec_uninstall {
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};

    print $OUT_FH <<'HEREDOC'
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
    DetailPrint "Removing Camelbox Start Menu"
	IfFileExists "$SMPROGRAMS\Camelbox\*.*" 0 ExitNice
		RMDir /r $SMPROGRAMS\Camelbox
    DetailPrint "Removing ${INSTALL_PATH}"
	IfFileExists "${INSTALL_PATH}\*.*" 0 ExitNice 
    	RMDir /r ${INSTALL_PATH}
	ExitNice:
SectionEnd ; Uninstall
HEREDOC
} # sub sec_uninstall

sub footer {
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};

    print $OUT_FH <<'HEREDOC'
Section "-Open Browser"
	StrCmp 	$openUsingCamelbox_state ${BST_CHECKED} 0 ExitOpen
		# yep, it was checked, fork a browser window open
		IfFileExists "C:\camelbox\share\urls\Using_Camelbox.URL" 0 ExitOpen 
			Exec "$PROGRAMFILES\Internet Explorer\iexplore.exe C:\camelbox\share\urls\Using_Camelbox.URL"
	ExitOpen:
		Return
SectionEnd

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
use Log::Log4perl qw(get_logger);

=pod

=head2 Hump::JSON::Node

An individual JSON node, which will have one or more key/value pairs as read
from the JSON file.

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    if ( ! defined($args{jsonvar}) ) {
        $logger->error(qq(Hump::JSON::Node was created without passing));
        $logger->logcroak(qq('jsonvar' hash reference\n ));
    } # if ( ! defined($args{jsonvar}) )

	# the file exists, bless it into an object
	my $self = bless({ 	
        jsonvar => $args{jsonvar}, 
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

=head3 new( jsonvar => {JSON variable reference} )

Creates a L<Hump::JSON::Node> object.  Takes the following arguments:

=over 4

=item jsonvar 

A reference to the hash containing the key/value pairs to be stored in the
L<Hump::JSON::Node> object.

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
    my $logger = get_logger();

    $logger->logcroak(qq(set method called without 'key'/'value' arguments))
        unless ( exists $args{key} && exists $args{value} );

    # so store it already
    $logger->debug(qq(Hump::JSON::Node->set: ) 
        . $args{key} . q(:) . $args{value});
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
    my $logger = get_logger();

    $logger->logcroak(qq(ERROR: get method called without 'key' argument))
        unless ( defined $args{key} );

    if ( exists $self->{node_hash}->{$args{key}} ) {
        return $self->{node_hash}->{$args{key}};
    } else {
        $logger->error(qq(Key ) . $args{key} 
            . qq( does not exist in this object));
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
use Log::Log4perl qw(get_logger);

=pod

=head2 Hump::JSON::Objects

An object that stores one or more L<Hump::JSON::Node> objects.  The objects
could be either individual Camelbox packages, or the package group
descriptions.

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    if ( ! defined($args{objects}) ) {
        $logger->error(qq(Hump::JSON::Objects object created without passing));
        $logger->logcroak(qq('objects' hash reference));
    } # if ( ! defined($args{objects}) ) 

    if ( ! defined($args{object_type}) ) {
        $logger->error(qq(Hump::JSON::Objects object created without passing));
        $logger->logcroak("'object_type' string (a description of the object)");
    } # if ( ! defined($args{objects}) ) 

    # bless an objects object
	my $self = bless({ 
            object_type => $args{object_type},
            objects => {},
            }, $class);

    # loop across all of the nodes in the JSON object; add them to the
    # internal objects hash using the key in the JSON object as the key in the
    # internal objects hash
    foreach my $object_id ( keys(%{$args{objects}}) ) {
        $logger->info(qq(creating node for $object_id));
        $self->{objects}->{$object_id} 
            = Hump::JSON::Node->new( jsonvar => $args{objects}{$object_id} );
    } # foreach my ( keys(%{$self->get_objects()}) )

    $logger->warn(qq(Picked up ) . scalar( $self->get_object_count() ) . qq( )
        . $self->{object_type} . qq( objects));

    return $self;
} # sub new

=pod 

=head3 new( jsonvar => {JSON variable reference} )

Creates a L<Hump::JSON::Node> object.  Takes the following key/value pairs
as arguments:

=over 4

=item jsonvar 

A reference to the hash containing the key/value pairs to be stored in the
L<Hump::JSON::Node> object.

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
    my $logger = get_logger();

    if ( defined $self->{objects}
            && exists $self->{objects}->{$args{object_id}} ) {
        return $self->{objects}->{$args{object_id}};
    } else {
        $logger->error(qq(package ) . $args{object_id} 
			. qq( not defined/empty));
		die;
    } # if ( exists $object_hash{$args{object_id}} )
} # sub get_object

=pod 

=head3 get_object( object_id => {package name} )

Returns the package identified by B<object_id>.  Warns with an error if
B<object_id> does not exist.

=cut

sub get_objects {
    my $self = shift;
    my $logger = get_logger();

    if ( scalar(keys(%{$self->{objects}}) > 0 )  ) {
        return sort(keys(%{$self->{objects}}));
    } else {
        $logger->warn(qq(No objects are stored in the object hash));
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
        warn $self->{object_type} . qq(: $object_key\n);
    } # foreach my $object_key ( $self->get_objects() )
} # sub dump_objects

=pod 

=head3 dump_objects()

Prints the keys to all of the objects in the object hash to STDERR, prefixed
by the object type.

=cut

#### Package 'Hump::JSON::Manifest' ####
package Hump::JSON::Manifest;
# a package manifest containing a list of package groups and individual
# packages
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

my @_manifest;

sub new {
    my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    if ( ! defined($args{manifest}) ) {
        $logger->warn(qq(Hump::JSON::Manifest was created without passing));
        $logger->logcroak(qq('manifest' hash reference));
    } # if ( ! defined($args{manifest}) )

	# the file exists, bless it into an object
	my $self = bless({}, $class);

    @_manifest = @{$args{manifest}};
    return $self;
} # sub new 

=pod 

=head3 new( manifest => {manifest list} )

Creates a L<Hump::JSON::Manifest> object.

=over 4

=item manifest

A list of manifest 'keywords' as arguments.

=back

=cut

sub get_manifest {
# return the list of packages described in the JSON file
    return @_manifest; 
} # sub get_manifest

=pod

=head3 get_manifest()

Returns the manifest list.

=cut

sub dump_manifest {
    foreach my $manifest_key ( @_manifest ) {
         warn qq(manifest: $manifest_key\n);
    } # foreach my $manifest_key ( @{$manifest} ) 
} # sub dump_manifest    

=pod

=head3 dump_manifest()

Prints the manifest list to STDERR.

=cut

#### Package 'Hump::JSON::Distribution' ####
package Hump::JSON::Distribution;
use strict;
use warnings;
use JSON::PP;
use Log::Log4perl qw(get_logger);

sub new {
	my $class = shift;
	my %args = @_;
    my $logger = get_logger();
	
    $logger->logcroak(qq(JSON filelist undefined))
        unless ( defined($args{jsonfile}) );

    $logger->logcroak(qq(JSON file ) . $args{jsonfile} . qq( does not exist))
        unless ( -f $args{jsonfile} );

	# the file exists, bless it into an object
	my $self = bless({ 	jsonfile => $args{jsonfile} }, $class);
	open(FH, $self->{jsonfile}) 
        || $logger->logcroak(qq(Can't open file ) 
        . $self->{jsonfile} . qq(: $!));
	binmode(FH);
    my $parser = JSON::PP->new->ascii->pretty->allow_nonref;
    my $json_string;
    while(<FH>) {
        $json_string .= $_;
    } # while(<FH>)
	$self->{jsonobj} = $parser->decode($json_string);
    $self->{_manifest_obj} = Hump::JSON::Manifest->new(
            manifest    => $self->{jsonobj}{manifest},
    );

    $self->{_package_obj} = Hump::JSON::Objects->new( 
            objects     => $self->{jsonobj}{packages},
            object_type => q(package),
	);

    $self->{_group_obj} = Hump::JSON::Objects->new( 
            objects     => $self->{jsonobj}{groups},
            object_type => q(group),
	);
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
use Log::Log4perl qw(get_logger);

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
    my $logger = get_logger();
	
    if ( exists $args{filename} && exists $args{file_regex} ) {
        $logger->warn(qq(use either 'filename' *OR* 'file_regex' parameters));
        $logger->logcroak(qq( when creating a Hump::File object (not both)) );
    } elsif ( exists $args{filename} ) {
        $logger->logcroak(qq(filename ) . $args{filename} 
            . qq( does not exist\n ))
        	unless ( -f $args{filename} );
    } # if ( exists $args{filename} )
	# the file exists, bless it into an object
	my $self = bless({ 	filename => $args{filename}, }, $class);
	open(FH, $self->{filename}) || $logger->logcroak(qq(Can't open file ) 
        . $self->{filename} . qq(: $!));
	binmode(FH);
	$self->{md5sum} = Digest::MD5->new->addfile(*FH)->hexdigest;
    $self->{unpacked_size} = $self->calculate_unpacked_size();
	# assigning a scalar from a returned list
	$self->{archived_size} = (stat($args{filename}))[7];
	return $self;
} # sub new

sub filename {
	my $self = shift;
	return $self->{filename};
} # sub filename

sub md5sum { 
	my $self = shift;
	return $self->{md5sum};
} # sub md5sum

sub get_archived_size {
	my $self = shift;
	return $self->{archived_size};
} # sub get_archived_size

sub get_unpacked_size {
	my $self = shift;
	return $self->{unpacked_size};
} # sub get_unpacked_size

sub get_unpacked_kilobytes {
	my $self = shift;

	my $kbytes = $self->{unpacked_size};
	return sprintf("%0d", $kbytes / 1000);
} # sub get_unpacked_kilobytes

sub calculate_unpacked_size {
	my $self = shift;
    my $logger = get_logger();

	my $total_unarchived_size = 0;

    my $tarlzma_cmd;
    $logger->info(q(Obtaining unpacked size of) . $self->filename() );
	# windows devices have different names than the unix ones
    if ( $^O eq q(MSWin32) ) {
    	$tarlzma_cmd = q(lzma -so d ) . $self->filename() 
            . q( 2>nul: | tar -tv 2>nul:);
    } else {
    	$tarlzma_cmd = q(lzma d -so ) . $self->filename() 
            . q( 2>/dev/null | tar -tv 2>/dev/null);
    } # if ( $^O eq q(MSWin32) )
	my $archive_list = qx/$tarlzma_cmd/;
	chomp($archive_list);
	if ( length($archive_list) > 0 ) {
		my @split_list = split(/\n/, $archive_list);
		# work on one line at a time
		foreach my $line ( @split_list ) {
			$line =~ s/  +/ /g;
			my $archive_file_size = (split(/ /, $line))[2];
			# skip empty files/directories
			next if ( $archive_file_size == 0 );
			my $archive_file_name = (split(/ /, $line))[5];
			$logger->debug(qq(Size of file $archive_file_name is )
                . qq($archive_file_size\n));
			$total_unarchived_size += $archive_file_size;
		} # foreach my $line ( @split_list )
	} else {
		$logger->warn(q(Hmmm.  Something went wrong with lzma/tar command:));
        $logger->warn(qq($tarlzma_cmd));
	} # if ( length($archive_list) > 0 )
	return $total_unarchived_size;
} # sub get_unpacked_size

#### Package Hump::ArchiveFileList ####
package Hump::ArchiveFileList;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

sub new {
	my $class = shift;
    my %args = @_;
    my $logger = get_logger();

	my $self = bless ({ files => {} }, $class);

    $logger->logcroak(qq(Hump::ArchiveFileList::new called )
        . qq(without 'startdir' argument)) 
        unless ( exists $args{startdir} );

    my @archive_files = File::Find::Rule->file()
        ->name(q(*.lzma))->in($args{startdir});

    $logger->logcroak(q(No *.lzma files found in ) . $args{startdir}) 
	    unless ( scalar(@archive_files) > 0 );

	$logger->warn(qq(Found ) . scalar(@archive_files) 
   		. qq( files in ) . $args{startdir});

    # build a list of files that can have files removed when they match
    # filenames contained in the JSON document
    foreach my $current_file (@archive_files) {
    	my $humpfile = Hump::File->new( filename => $current_file );
        $self->add_file(humpfile => $humpfile);
    } # foreach my $current_file (@files)
    return $self;
} # sub new

sub add_file {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my $humpfile = $args{humpfile};
    my $short_filename = (split(q(/), $humpfile->filename()))[-1];
    if ( $logger->is_debug ) {
        $logger->debug(q(file: ) . $humpfile->filename());
        $logger->debug(q(short name: ) . $short_filename);
        $logger->debug(qq(md5sum: ) . $humpfile->md5sum());
        $logger->debug(qq(total size of archive when unpacked: ) 
 			. $humpfile->get_unpacked_kilobytes() . q(k));
    } # if ( $logger->is_debug )


    # add the humpfile object to the files hash
    $self->{files}->{$short_filename} = $humpfile;
} # sub add_file

=pod

=head3 add_file(humpfile => $humpfile)

Add a L<Hump::File> object to the L<Hump::ArchiveFileList> object.  This
method will strip the path from the file so that the filename is stored as the
key to the Hump::File object.

=cut

sub get_file_object {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(get_file called without a filename argument)) 
        unless ( $args{filename} );

	if ( ! defined $self->{files}->{$args{filename}} ) {
	    $logger->error(qq(get_file requested for file that does not exist));
		$logger->logcroak(q(requested file was ) . $args{filename} );
	} # if ( ! defined $self->{files}->{$args{filename}} )
    return $self->{files}->{$args{filename}};
} # sub get_file

sub get_filename_regex {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(q(get_file_regex called without a regular expression))
        unless ( $args{regex} );
    my @keys = keys(%{$self->{files}});
    my @matches = grep(/$args{regex}\..*/, @keys);
    $logger->info(q(matching ) . $args{regex});
    if ( scalar(@matches) > 0 ) {
        $logger->info(q(get_file_regex matches: ) . join(q(:), @matches) );
        my $newest_match = (sort(@matches))[-1];
        $newest_match =~ s/.*\/(.*lzma)$/$1/;
        $logger->info(qq(newest match is $newest_match));
        return $newest_match;
    } else {
        $logger->warn(q(no matches found for ') . $args{regex} . q('));
		die;
    } # if ( scalar(@matches) > 0 )
} # sub get_file_regex

#### Package Hump::WriteBlocks ####
package Hump::WriteBlocks;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

my $total_unpacked_size;
my $total_archived_size;

sub new {
	my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(Hump::ArchiveFileList object required as 'filename')) 
        unless ( defined $args{filelist} );

    $logger->logcroak(qq(Packages object requird as 'packages'))
	    unless ( defined $args{packages} ); 

    $logger->logcroak(qq(Output filehandle parameter missing)) 
        unless ( defined $args{output_filehandle} );

	my $self = bless ({ 
            filelist            => $args{filelist},
            packages            => $args{packages},
            output_filehandle   => $args{output_filehandle},
    }, $class); # my $self = bless
    return $self;
} # sub new

sub output_section { 
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my $indent = q();
    if ( exists $args{indent} ) { $indent = q(    ); }
    # a Hump::JSON::Node object
    my $package = $args{package_obj};
    # a scalar string
    my $pkg_id = $args{package_id};
    # a list of file objects
    my $filelist = $self->{filelist};
    my $filename = $filelist->get_filename_regex(regex => $pkg_id);
    my $file_obj = $filelist->get_file_object(filename => $filename);
    my $OUT_FH = $self->{output_filehandle};

	$total_unpacked_size += $file_obj->get_unpacked_size();
	$total_archived_size += $file_obj->get_archived_size();

    # section heading
    print $OUT_FH $indent . qq(Section ") 
        . $package->get(key => q(description)) 
        . qq(" ) . $pkg_id . qq(_id\n);
    # list of sections this file belongs to
    print $OUT_FH $indent . q(    SectionIn ) 
        . join(q( ), @{$package->get(key => q(sectionin_list))}) . qq(\n);
    # filesize for AddSize
    print $OUT_FH $indent . q(    AddSize ) 
        . $file_obj->get_unpacked_kilobytes() . qq(\n);
    # push the name of the file onto the stack
    print $OUT_FH $indent . qq(    push "$filename"\n);
    # the MD5 checksum 
    print $OUT_FH $indent . qq(    push ") 
        . $file_obj->md5sum() . qq("\n);
    # get the ID of this section...
    print $OUT_FH $indent . q(    SectionGetText ${) 
        . $pkg_id . q(_id} $0) . qq(\n);
    # push that onto the stack
    print $OUT_FH $indent . q(    push $0) . qq(\n);
    # grab the file, unpack it
    print $OUT_FH $indent . qq(    Call SnarfUnpack\n);
    # end of this section
    print $OUT_FH $indent . qq(SectionEnd ; $pkg_id\n);
} # sub output_section

sub output_group {
    my $self = shift;
    my %args = @_;

    my $group = $args{group_obj};
    my $packages = $self->{packages};
    my $OUT_FH = $self->{output_filehandle};

    # check for the '/e' switch (expand group) 
	if ( $group->get(key => q(expanded_flag)) == 1 ) {
	    print $OUT_FH qq(\nSectionGroup /e ") 
   			. $group->get(key => q(description)) . qq("\n);
	} else {
	    print $OUT_FH qq(\nSectionGroup ") 
   			. $group->get(key => q(description)) . qq("\n);
	} # if ( $group->get(key => q(expanded_flag)) == 1 )
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
        print $OUT_FH qq(SectionGroupEnd ; ) 
            . $group->get(key => q(description)) . qq(\n);
} # sub output_group

sub get_archived_size {
	return $total_archived_size;
} # sub get_archived_size

sub get_unpacked_size {
	return $total_unpacked_size;
} # sub get_unpacked_size

#### begin package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use File::Find::Rule;
use Pod::Usage;
use Carp;
use Log::Log4perl qw(get_logger);
use Log::Log4perl::Level;

my $o_verbose = 0;
my $o_debug = 0;
my $o_colorlog = 1;

my ($o_startdir, $o_jsonfile, $o_outfile, $o_dump_blocks);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions( 
	q(verbose|v)                    => \$o_verbose,
	q(debug|d)                    	=> \$o_debug,
    q(help|h)                       => \&ShowHelp,
    q(startdir|s:s)                 => \$o_startdir,
	q(jsonfile|j=s)                 => \$o_jsonfile,
    q(outfile|o:s)                  => \$o_outfile,
    q(colorlog!)                    => \$o_colorlog,
); # $go_parse->getoptions

# always turn off color logs under Windows, the terms don't do ANSI
if ( $^O =~ /MSWin32/ ) { $o_colorlog = 0; }

# set up the logger
my $logger_conf = qq(log4perl.rootLogger = WARN, Screen\n);
if ( $o_colorlog ) {
    $logger_conf .= qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::ScreenColoredLevels\n);
} else {
    $logger_conf .= qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::Screen\n);
} # if ( $Config->get(q(o_colorlog)) )

$logger_conf .= qq(log4perl.appender.Screen.stderr = 1\n)
    . qq(log4perl.appender.Screen.layout = PatternLayout\n)
#. q(log4perl.appender.Screen.layout.ConversionPattern = %d %p %m%n)
    . q(log4perl.appender.Screen.layout.ConversionPattern = %p -> %m%n)
    . qq(\n);
#log4perl.appender.Screen.layout.ConversionPattern = %d %p> %F{1}:%L %M - %m%n
# create the logger object
Log::Log4perl::init( \$logger_conf );
my $logger = get_logger("");

# this is fugly, but it works
my $program_name = (split(/\//,$0))[-1];
$logger->warn(qq(==== $program_name ====));

# change the log level from INFO if the user requests more gar-bage
if ( $o_verbose ) { $logger->level($INFO); }
if ( $o_debug ) { $logger->level($DEBUG); }

# verify the start directory was passed in and exists
if ( ! defined $o_startdir ) { 
	$logger->warn(qq(start directory needed for searching;));
	&HelpCroak;
} # if ( ! defined $o_startdir )

if ( ! -d $o_startdir ) {
	$logger->croak(qq(start directory $o_startdir does not exist));
} # if ( ! -d $o_startdir )

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

$logger->warn(qq(Reading JSON distribution file '$o_jsonfile'));
# read in the JSON distro file
my $distro = Hump::JSON::Distribution->new( jsonfile => $o_jsonfile );

# get the manifest of this NSIS packages list
my $manifest = $distro->get_manifest_obj();

# get the list of groups in the JSON file
my $groups = $distro->get_group_obj();

# grab the packages object
my $packages = $distro->get_package_obj();

if ( $o_verbose ) {
    $manifest->dump_manifest;
    $groups->dump_objects();
    $packages->dump_objects();
} # if ( $o_verbose )

# if an output file was specified, set that up now; otherwise, use STDOUT
# create a scalar for holding the output filehandle
my $OUT_FH;
if ( $o_outfile ) {
    if ( ! open($OUT_FH, qq(>$o_outfile)) ) {
        $logger->warn(qq(Can't open output file $o_outfile for writing;));
        $logger->logcroak($!);
    } # if ( ! open($OUT_FH, qq(>$o_outfile)) )
} else {
    $OUT_FH = *STDOUT;
} # if ( $o_outfile )

# walk the manifest list, going through each group, package or special
# handler, and outputting the NSIS script info for each type of object
# handlers for non-package and non-group entries in the manifest
my $block_handler = Hump::BlockHandlers->new( output_filehandle => $OUT_FH );

# file/package operations
$logger->warn(qq(Cataloging archive files in '$o_startdir'));
my $filelist = Hump::ArchiveFileList->new( startdir	=> $o_startdir );

# object that writes blocks of NSIS scripting
my $writeblocks = Hump::WriteBlocks->new( 
        filelist            => $filelist, 
        packages            => $packages,
        output_filehandle   => $OUT_FH
); # my $writeblocks = Hump::WriteBlocks->new

foreach my $manifest_key ( $manifest->get_manifest() ) {
    if ( $manifest_key =~ /^group/ ) {
        # $current_group is a Hump::JSON::Node
        my $current_group = $groups->get_object( object_id => $manifest_key );
        $logger->info(qq(group object '$manifest_key'));
        $logger->info(q(  keys: ) . join(q(:), $current_group->keys()) );
        $writeblocks->output_group( group_obj => $current_group);
    } elsif ( $packages->object_exists(object_id => $manifest_key) ) {
        $logger->info(qq(package object '$manifest_key'));
        # $current_package is a Hump::JSON::Node
        my $current_package = $packages->get_object(
                                object_id => $manifest_key );
        $logger->info(q(  keys: ) . join(q(:), $current_package->keys()) );
        $writeblocks->output_section(
                        package_id      => $manifest_key,
                        package_obj     => $current_package,
        ); # $writeblocks->output_section
    } else {
        $logger->warn(qq(Writing handler object '$manifest_key'));
        if ( $block_handler->can($manifest_key) ) {
            $block_handler->$manifest_key;
            print $OUT_FH qq(\n);
        } else {
            $logger->error(qq(don't know how to '$manifest_key'));
        } # if ( $block_handler->can($manifest_key) )
    } # if ( $manifest_key =~ /^group/ )
} # foreach my $manifest_key ( $manifest->get_objects() )

my $packed_ratio 
	= $writeblocks->get_archived_size() / $writeblocks->get_unpacked_size();
$logger->warn(qq(Unpacked size: ) . $writeblocks->get_unpacked_size());
$logger->warn(qq(Archived size: ) . $writeblocks->get_archived_size());
$logger->warn(qq(Compression Ratio: ) . sprintf(q(%0.2f), $packed_ratio));
exit 0;

#### end main ####

#### main subroutines ####

sub HelpCroak {
    croak(qq(Use '$0 --help' to view script options\n ));
    exit 1;
} # sub HelpCroak 

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

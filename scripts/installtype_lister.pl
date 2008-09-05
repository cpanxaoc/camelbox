#!/usr/bin/env perl

# $Id: nsh_builder.pl 256 2008-05-27 08:43:26Z elspicyjack $
# $Date: 2008-05-27 01:43:26 -0700 (Tue, 27 May 2008) $
#
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

# A script to list which packages get installed with which install types; a
# sort of simple dependency checker.

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

B<installtype_lister.pl> - Show what packages get installed from different
install types

=head1 VERSION

The SVN version of this file is $Revision: 256 $. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl installtype_lister.pl [options]

=head2 Script Options

 --help|-h          Show this help message
 --verbose|-v       Verbose script output
 --jsonfile|-j      JSON file to parse to build the list of packages vs.
                    install types

=cut

#### Package 'Generic::Something' ####
package Generic::Something;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $filename = shift;
	my $self = bless ({ filename => $filename }, $class);

} # sub new
=pod

=head2 Module Generic::Something

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

A C<Generic::Something> object, which is a wrapper around the Perl C<stat()>
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
	my $filename = shift;
	
	if ( ! -f $filename ) {
		die(qq(ERROR: filename $filename does not exist));
	} # if ( -f $filename )

	# the file exists, bless it into an object
	my $self = bless({ filename => $filename }, $class);
	open(FH, $self->{filename}) 
		|| die qq(Can't open file ) . $self->{filename} . qq(: $!);
	binmode(FH);
	$self->{md5sum} = Digest::MD5->new->addfile(*FH)->hexdigest;
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

#### end package Hump::File ####

#### begin package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use File::Find::Rule;
use Pod::Usage;

my $o_colorlog = 1;
my ($VERBOSE, $o_timestamp, $o_startdir);
my ($o_plaintext, $o_md5list, $o_nshlist, $o_install);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions(  q(verbose|v)                    => \$VERBOSE,
                        q(help|h)                       => \&ShowHelp,
                        q(timestamp|t=s)                => \$o_timestamp,
                        q(startdir|s=s)                 => \$o_startdir,
                        q(plaintext|p:s)                => \$o_plaintext,
                        q(md5list|m:s)                  => \$o_md5list,
                        q(nshlist|n:s)                  => \$o_nshlist,
                        q(install|i=s)                  => \$o_install,
                    ); # $go_parse->getoptions

# verify the start directory exists
if ( ! defined $o_startdir ) { 
	warn(qq(ERROR: start directory needed for searching;\n));
	&HelpDie;
} # if ( ! defined $o_startdir )

if ( ! -d $o_startdir ) {
	die(qq(ERROR: start directory $o_startdir does not exist));
} # if ( ! -d $o_startdir )

my @files = File::Find::Rule->file()->in($o_startdir);

print qq(Found ) . scalar(@files) . qq( files in $o_startdir\n);

foreach my $idx (0..9) {
	my $humpfile = Hump::File->new( $files[$idx] );
	print qq(md5sum: ) . $humpfile->md5sum() . q(; file: ) 
		. $humpfile->filename() . qq(\n);
} # foreach my $idx (0..9)

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

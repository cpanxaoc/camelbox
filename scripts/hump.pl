#!/usr/bin/env perl

# $Id$
# $Date$
#
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

# A script to generate different types of filelists; a plaintext filelist, a
# filelist with MD5sums, and the camelbox_filelist.nsh NSIS script with the
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

B<generate_filelists.pl> - Generate filelists of one or more types

=head1 VERSION

The SVN version of this file is $Revision$. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl hump.pl [options]

=head2 Script Options

 --help|-h              Show this help message
 --verbose|-v           Verbose script output
 --timestamp|-t         Timestamp to use with output filenames
 --plaintext|-p         Generate a plain list of files (with header)
                        Output file will be saved as filelist.DATETIME.txt
 --md5list|-m           Generate an MD5 checksummed list of files 
                        Output file will be saved as filelist.DATETIME.md5.txt
 --nshlist|-n           Generate an NSIS script listing of files
                        Output file will be saved as filelist.DATETIME.nsh

=cut

#### Package 'ArchiveFile' ####
package ArchiveFile;
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
} 

#### Package 'PackageGroup' ####
package PackageGroup;
use Moose; # comes with 'strict' and 'warnings'
use Moose::Util::TypeConstraints;

package main;

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

my ($VERBOSE);
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

sub HelpDie {
    my $logger = get_logger();
    $logger->fatal(qq(Use '$0 --help' to view script options));
    exit 1;
} # sub HelpDie 

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

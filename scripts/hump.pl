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

B<hump.pl> - Generate Camelbox filelists of one or more types

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
                        Use for creating packages
 --md5list|-m           Generate an MD5 checksummed list of files 
                        Output file will be saved as filelist.DATETIME.md5.txt
                        Use for creating md5sum files for releases
 --nshlist|-n           Generate an NSIS script listing of files
                        Output file will be saved as filelist.DATETIME.nsh
                        Use for creating a NSIS filelist file
 --install|-i           Install this module from CPAN; run a plaintext
                        filelist both before and after the CPAN module is
                        installed, and output the list of files that have been
                        added or changed

=cut

#### Package 'Hump::File::Stat' ####
package Hump::File::Stat;
use Log::Log4perl qw(get_logger);
use Moose;
use Moose::Util::TypeConstraints;

=pod

=head2 Module Hump::File

A wrapper around the Perl C<stat()> function.  Has the following attributes:

=over 4

=item



=cut

#### Package 'Hump::File' ####
package Hump::File;
use Log::Log4perl qw(get_logger);
use Moose;
use Moose::Util::TypeConstraints;

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

=item crc32sum

The CRC32 checksum for the file.  Not available for directories.

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

#### Package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

my ($VERBOSE, $o_timestamp, $o_plaintext, $o_md5list, $o_nshlist);
my ($o_install, $o_colorlog);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions(  q(verbose|v)                    => \$VERBOSE,
                        q(help|h)                       => \&ShowHelp,
                        q(timestamp|t=s)                => \$o_timestamp,
                        q(plaintext|p:s)                => \$o_plaintext,
                        q(md5list|m:s)                  => \$o_md5list,
                        q(nshlist|n:s)                  => \$o_nshlist,
                        q(install|i=s)                  => \$o_install,
                        q(colorlog!)                    => \$o_colorlog,
                    ); # $go_parse->getoptions

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

# create the logger object
Log::Log4perl::init( \$logger_conf );
my $logger = get_logger("");
# change the log level from INFO if the user requests more gar-bage
if ( $VERBOSE ) { $logger->level($DEBUG); }

# more crap here

#### main subroutines ####

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

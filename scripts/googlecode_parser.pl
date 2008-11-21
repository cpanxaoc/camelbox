#!/usr/bin/env perl

# $Id: nsh_builder.pl 256 2008-05-27 08:43:26Z elspicyjack $
# $Date: 2008-05-27 01:43:26 -0700 (Tue, 27 May 2008) $
#
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

# A script to read the google code filelist and parse download stats; store
# stats in a database so you can track changes over time 

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

=pod

=head1 NAME

B<googlecode_parser.pl> - Parse the downloads page on Google Code's website
to get some statistics on what's being downloaded

=head1 VERSION

The SVN version of this file is $Revision: 256 $. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl googlecode_parser.pl [options]

=head2 Script Options

 --help|-h          Show this help message
 --verbose|-v       Verbose script output

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

#### begin package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

my ($VERBOSE, $o_timestamp, $o_startdir);
my ($o_plaintext, $o_md5list, $o_nshlist, $o_install);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions(  q(verbose|v)                    => \$VERBOSE,
                        q(help|h)                       => \&ShowHelp,
                    ); # $go_parse->getoptions


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

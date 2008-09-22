#!/usr/bin/perl

# $Id: win32_filenames_test.pl 203 2008-04-21 21:58:07Z elspicyjack $
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

=pod

=head1 NAME

B<kid_demo.pl> - Demo that searches for library files on Windows like the
Kid.pm module does.

=head1 VERSION

The SVN version of this file is $Revision: 203 $. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl kid_demo.pl

=head2 Script Options

None.

=head1 DESCRIPTION

Quick demonstration of how you should search for different library extensions
on Windows.

=cut

use strict;
use warnings; # disabled, this script will exercise a few warnings otherwise

my @extension_list = qw( lib dll a );
foreach my $extension ( @filenames ) { 

	if ( -f $file ) {
		print qq(Exists:        $file\n);
	} else {
		print qq(Doesn't Exist: $file\n);
	} # if ( -f $file )
} # foreach my $file ( @filenames )

exit 0;

=pod

=head1 AUTHOR

Brian Manning E<lt>elspicyjack at gmail dot comE<gt>

=cut

# vi: set sw=4 ts=4 cin:
# end of line

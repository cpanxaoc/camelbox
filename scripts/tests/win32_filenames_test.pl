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

=pod

=head1 NAME

B<win32_filename_test.pl> - Demo of how slashes are handled on Windows

=head1 VERSION

The SVN version of this file is $Revision$. See the top of this file for
the author's version number.

=head1 SYNOPSIS

 perl win32_filename_test.pl

=head2 Script Options

None.

=head1 DESCRIPTION

Quick demonstration of how Perl on Windows works with forward/backward slashes
in filenames.

=cut

use strict;
# use warnings; # disabled, this script will exercise a few warnings otherwise

my @filenames = (
'C:\boot.ini', # works
'C:/boot.ini', # ditto
q(C:\boot.ini), # works, a wee bit more readable
q(C:/boot.ini), # same deal
"C:/boot.ini", # works
"C:\boot.ini", # fails, the backslash is interpolated by Perl
"C:\\boot.ini", # works, backslash is escaped from Perl
qq(C:/boot.ini), # works
qq(C:\boot.ini), # fails, the backslash is interpolated by Perl
qq(C:\\boot.ini), # works, backslash is escaped from Perl
q(C:\Documents and Settings\Administrator\Start Menu\desktop.ini), # works
qq(C:\\Documents and Settings\\Administrator\\Start Menu\\desktop.ini), # works
qq(C:\Documents and Settings\Administrator\Start Menu\desktop.ini), # nope
'C:\Documents and Settings\Administrator\Start Menu\desktop.ini', # works
"C:\\Documents and Settings\\Administrator\\Start Menu\\desktop.ini", # works
"C:\Documents and Settings\Administrator\Start Menu\desktop.ini", # nope
);

foreach my $file ( @filenames ) { 

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

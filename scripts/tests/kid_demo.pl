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

my @searchargs = ( q(-LC:/camelbox/lib), q(-lcairo), q(-lmsvcrt),
	q(-lmoldname), q(-lkernel32), q(-luser32), q(-lgdi32),
   	q(-lwinspool), q(-lcomdlg32), q(-ladvapi32), q(-lshell32),
   	q(-lole32), q(-loleaut32), q(-lnetapi32), q(-luuid),
   	q(-lws2_32), q(-lmpr), q(-lwinmm), q(-lversion),
   	q(-lodbc32), q(-lodbccp32) ); 
my @searchpath_list = ( q(C:/camelbox/lib/CORE) );
my @extension_list = qw( .lib .dll .a );
my @library_list;

# parse all of the arguments first
foreach my $searcharg ( @searchargs ) {
	# if it's a -L argument, it's another directory to search
	if ( $searcharg =~ s/^-L(.*)$/$1/ ) {
		print "adding $1 to search path\n";
		push ( @searchpath_list, $1 );
 	} elsif ( $searcharg =~ s/^-l(.*)$/$1/ ) {
		print "adding $1 to list of libraries to hunt\n";
		push ( @library_list, $1 );
	} # foreach my $file ( @filenames )
} # foreach my $searcharg ( @searchargs )

# now match library arguments with actual files
foreach my $library_file ( @library_list ) { 
	my @possible_files;
	foreach my $extension ( @extension_list ) {
		push(@possible_files, $library_file . $extension);
	} 
	foreach my $search_path ( @searchpath_list ) {
		foreach my $possible_file ( @possible_files ) {
			my $file = $search_path . q(/) . $possible_file;
			if ( -f $file ) {
				print qq(Exists:        $file\n);
			} else {
				print qq(Doesn't Exist: $file\n);
			} # if ( -f $file )
		} # foreach my $library_file ( @library_list )
	} # foreach my $extension ( @filenames ) 
} # foreach my $library_file ( @library_list )

exit 0;

=pod

=head1 AUTHOR

Brian Manning E<lt>elspicyjack at gmail dot comE<gt>

=cut

# vi: set sw=4 ts=4 cin:
# end of line

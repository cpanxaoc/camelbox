#!/usr/bin/env perl

# $Id: perlscript.pl,v 1.7 2008-01-24 07:06:47 brian Exp $
# Copyright (c)2014 by Brian Manning
#
# perl script that reads registry entries on Windows hosts
# NOTE: the registry entries must exist, or the script will die
# use Registry Editor to verify the keys exist before panicing

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

SomeScript

=head1 DESCRIPTION

B<SomeScript> does I<Something>

=cut

our $VERSION = q(0.1);

package main;

use strict;
use warnings;

################
# SomeFunction #
################
sub SomeFunction {
} # sub SomeFunction

use Data::Dumper;
use Win32API::Registry qw( :Func :ALL );
use Win32::TieRegistry ( Delimiter => q(/), ArrayValues => 1);
my $reg = $Registry->Delimiter(q(/));
my $diskKey =
    $Registry->{q(LMachine/SYSTEM/MountedDevices/)}
    or die "Can't read MountedDevices: $^E\n";
#my $tsKey =
#    $Registry->{q(LMachine/SYSTEM/CurrentControlSet/Control/TerminalServer/)};
#my $terminal_server_enabled = $tsKey->{q(/fDenyTSConnections)};
#if ( defined $terminal_server_enabled ) {
#    print qq(Terminal server is enabled: $terminal_server_enabled\n);
#} else {
#    print qq(Terminal server key does not exist\n);
#}

my ($key, $type, $data);
RegOpenKeyEx( HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control", 0, KEY_READ, $key )
  or  die "Can't open HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control: ",
          regLastError(),"\n";
RegQueryValueEx( $key, "CurrentUser", [], $type, $data, [] )
  or  die "Can't read HKEY_L*MACHINE\\SYSTEM\\CurrentControlSet\\Control\\CurrentUser",
          regLastError(),"\n";

my @disk_keys = keys(%$diskKey);
print Dumper $key;
print Dumper $type;
print Dumper $data;
#print Dumper $tsKey;
print Dumper @disk_keys;

=pod

=head1 CONTROLS

=over 5

=item B<Description of Controls>

=over 5

=item B<A Control Here>

This is a description about A Control.

=item B<Another Control>

This is a description of Another Control

=back

=back

=head1 FUNCTIONS

=head2 SomeFunction()

SomeFunction() is a function that does something.

=head1 VERSION

Version 0.1

=head1 AUTHOR

Brian Manning E<lt>elspicyjack at gmail dot comE<gt>

=cut

# vi: set ft=perl sw=4 ts=4 cin:
# end of line
1;


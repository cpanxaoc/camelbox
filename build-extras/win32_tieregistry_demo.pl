#!/usr/bin/env perl

# $Id: perlscript.pl,v 1.7 2008-01-24 07:06:47 brian Exp $
# Copyright (c)2014 by Brian Manning
#
# perl script that does something

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

use Win32::TieRegistry ( Delimiter => q(/), ArrayValues => 1);
my $reg = $Registry->Delimiter(q(/));
my $tsKey =
    $Registry->{q(LMachine/SYSTEM/CurrentControlSet/Control/TerminalServer)};
my $terminal_server_enabled = $tsKey->{q(/fDenyTSConnections)};
print qq(Terminal server is enabled: $terminal_server_enabled\n);

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


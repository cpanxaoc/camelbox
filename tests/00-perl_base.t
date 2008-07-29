#!/usr/bin/perl

# a stub file for writing tests

use strict;
use warnings;
use Test::More qw(no_plan);

# the Config module is part of the Perl distribution
BEGIN { use_ok( q(Config) ) };

ok($Config{version} eq q(5.10.0), q(Perl $Config{version} is 5.10.0));
ok($Config{prefix} eq q(C:\camelbox), 
	q($Config{prefix} points to Camelbox base directory));
# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

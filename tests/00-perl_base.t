#!/usr/bin/perl

# basic test file for Perl (and Camelbox)

use strict;
use warnings;
use Test::More tests => 4;

# the Config module is part of the Perl distribution
BEGIN { use_ok( q(Config) ) };

ok($Config{version} eq q(5.10.0), q(Perl $Config{version} is 5.10.0));
ok($Config{prefix} eq q(C:\camelbox), 
	q($Config{prefix} points to Camelbox base directory));
# just for shits and giggles
ok($Config{_a} eq q(.a), q(Import libraries end with '.a' extension));

# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

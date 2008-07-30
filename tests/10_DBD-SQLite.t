#!/usr/bin/perl

# a stub file for writing tests

use strict;
use warnings;
use Test::More qw(no_plan);

# the Config module is part of the Perl distribution
BEGIN { use_ok( q(DBI) ) };

my $dbh = DBI->connect("dbi:SQLite:dbname=/temp/sqlite_test.db", "", "");
#isa_ok($dbh, q(DBI));
ok($dbh->{sqlite_version}, q(SQLite version is ) . $dbh->{sqlite_version});
# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

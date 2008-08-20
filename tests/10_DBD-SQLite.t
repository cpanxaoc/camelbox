#!/usr/bin/perl

# test for DBD::SQLite

use strict;
use warnings;
use Test::More qw(no_plan);

# the Config module is part of the Perl distribution
BEGIN { use_ok( q(DBI) ) };
my $db_testfile = q(camelbox.sqlite.db);

my $dbh = DBI->connect(qq(dbi:SQLite:dbname=$db_testfile), q(), q());
#isa_ok($dbh, q(DBI));
ok($dbh->{sqlite_version}, q(SQLite version is ) . $dbh->{sqlite_version});
my $sth = $dbh->prepare( q(CREATE TABLE camelbox_test )
	. q(( number INTEGER, text TEXT )) );
ok($sth->execute(), q(Executed CREATE statement));

# clean up
unlink qw(camelbox.sqlite.db);
ok( ! -f $db_testfile, q(Deleted database test file));
# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

#!/usr/bin/perl

# test for DBD::SQLite

use strict;
use warnings;
use Test::More tests => 15;
#use Test::More qw(no_plan);

# load up the DBI module
BEGIN { use_ok( q(DBI) ) };
my $db_testfile = q(camelbox.sqlite.db);

# CREATE DATABASE
my $dbh = DBI->connect(qq(dbi:SQLite:dbname=$db_testfile), q(), q());
ok($dbh, q(Database handle to SQLite database successfully created));
ok($dbh->{sqlite_version}, q(SQLite version is ) . $dbh->{sqlite_version});

# CREATE TEST TABLE
my $sth = $dbh->prepare(
   	q( CREATE TABLE camelbox_test (string TEXT, number INTEGER) ) );
ok($sth->execute, q(Executed CREATE statement));

# INSERT DATA INTO TABLE
$sth = $dbh->prepare(q(INSERT INTO camelbox_test VALUES ('hello!', 10)) );
ok($sth->execute, q(Executed INSERT statement 'hello!'/10) );

$sth = $dbh->prepare(q(INSERT INTO camelbox_test VALUES ('goodbye', 20)) );
ok($sth->execute, q(Executed INSERT statement 'goodbye'/20) );

# SELECT DATA FROM TABLE AND COMPARE
$sth = $dbh->prepare(
	q(SELECT string, number FROM camelbox_test WHERE number = 20) );
ok($sth->execute, q(Executed SELECT: number = 20) );
my @row = $sth->fetchrow_array();
ok($row[0] eq q(goodbye) && $row[1] == 20, 
	q(Selected row returned: ') . $row[0] . q(/) . $row[1] . q(') );

$sth = $dbh->prepare(
	q(SELECT string, number FROM camelbox_test WHERE string = 'hello!') );
ok($sth->execute, q(Executed SELECT: string = 'hello!') );
@row = $sth->fetchrow_array();
ok($row[0] eq q(hello!) && $row[1] == 10, 
	q(Selected row returned: ') . $row[0] . q(/) . $row[1] . q(') );

# CLEAN UP
ok($sth->finish, q(Closed the statement handle with $sth->finish ) );
ok(! undef $sth, q(undef'ed $sth));
ok($dbh->disconnect, q(Closed the database handle with $dbh->disconnect ) );
ok(! undef $dbh, q(undef'ed $dbh));
unlink qw(camelbox.sqlite.db);
ok( ! -f $db_testfile, qq(Deleted database test file '$db_testfile'));

# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

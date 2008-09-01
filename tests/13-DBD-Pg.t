#!/usr/bin/perl

# test for DBD::SQLite

use strict;
use warnings;
use Test::More tests => 17;
#use Test::More qw(no_plan);

# load up the DBI module
BEGIN { use_ok( q(DBI) ) };
my $db_host = q(127.0.0.1);
my $db_port = 15432;
my $db_name = q(camelbox);
my $db_user = q(camelbox);
my $db_pass;
if ( exists $ENV{PGPASSWORD} ) {
    $db_pass = $ENV{PGPASSWORD};
} else {
    die(q(Environment variable 'PGPASSWORD' is not set; exiting...));
} # if ( exists $ENV{PGPASSWORD} )

my @rows; # returned rows

# CREATE DATABASE
my $dbh = DBI->connect(
    qq(dbi:Pg:database=$db_name;)
    . qq(host=$db_host;port=$db_port), 
    qq($db_user), qq($db_pass) );
ok($dbh,  q(Database handle to PostgreSQL database successfully created));

# send a ping to the database to test it
my $db_ping_rv = $dbh->ping;
ok($db_ping_rv > 0, qq(Database ping returned success: $db_ping_rv));

# check the PostgreSQL version; this checks the connection as well
my $db_version = $dbh->{pg_server_version};
ok($db_version, q(PostgreSQL version is ) . $db_version);

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
@rows = $sth->fetchrow_array();
ok($rows[0] eq q(goodbye) && $rows[1] == 20, 
	q(Selected row returned: ') . $rows[0] . q(/) . $rows[1] . q(') );

$sth = $dbh->prepare(
	q(SELECT string, number FROM camelbox_test WHERE string = 'hello!') );
ok($sth->execute, q(Executed SELECT: string = 'hello!') );
@rows = $sth->fetchrow_array();
ok($rows[0] eq q(hello!) && $rows[1] == 10, 
	q(Selected row returned: ') . $rows[0] . q(/) . $rows[1] . q(') );

# DROP TABLE
$sth = $dbh->prepare( q(DROP TABLE camelbox_test) );
ok($sth->execute, q(Executed DROP TABLE));

# SELECT ON EMPTY TABLE
$dbh->{PrintError} = 0;
$sth = $dbh->prepare( q(SELECT string, number )
    . q(FROM camelbox_test WHERE number = 20) );     
ok(! $sth->execute, q(Executed SELECT with an empty table));

# CLEAN UP
ok($sth->finish, q(Closed the statement handle with $sth->finish ) );
ok(! undef $sth, q(undef'ed $sth));
ok($dbh->disconnect, q(Closed the database handle with $dbh->disconnect ) );
ok(! undef $dbh, q(undef'ed $dbh));
# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

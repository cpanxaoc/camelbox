#!/usr/bin/perl

# test for DBD::SQLite

use strict;
use warnings;
use Test::More tests => 17;
#use Test::More qw(no_plan);

# load up the DBI module
BEGIN { use_ok( q(DBI) ) };
my $db_host = q(127.0.0.1);
my $db_port = 3306;
my $db_name = q(camelbox);
my $db_user = q(camelbox);
my $db_pass;
if ( exists $ENV{DB_MYSQL_PASS} ) {
    $db_pass = $ENV{DB_MYSQL_PASS};
} else {
    die(q(Environment variable 'DB_MYSQL_PASS' is not set; exiting...));
} # if ( exists $ENV{DB_MYSQL_PASS} )

my @rows; # returned rows

# CREATE DATABASE
my $dbh = DBI->connect(
    qq(dbi:mysql:database=$db_name;)
    . qq(host=$db_host;port=$db_port), 
    qq($db_user), qq($db_pass) );
ok($dbh,  q(Database handle to MySQL database successfully created));

# check the MySQL version; this checks the connection as well
my $sth = $dbh->prepare( q(SELECT VERSION();) );
ok($sth->execute, q(Executed SELECT VERSION() query));
@rows = $sth->fetchrow_array();
ok($rows[0], q(MySQL version is ) . $rows[0]);

# CREATE TEST TABLE
$sth = $dbh->prepare(
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
ok(! $sth->execute, q(Executed SELECT after DROPping table));

# CLEAN UP
ok($sth->finish, q(Closed the statement handle with $sth->finish ) );
ok(! undef $sth, q(undef'ed $sth));
ok($dbh->disconnect, q(Closed the database handle with $dbh->disconnect ) );
ok(! undef $dbh, q(undef'ed $dbh));
# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

#!/usr/bin/env perl

# script to test out SQLite support

# create a new database with:
# sqlite3 test.db
# create table table1 ( column1 TEXT );
# insert into table1 values ("this is some text");
# select * from table1; # should get 'this is some text'

# now test it with perl
  use DBI qw(:sql_types);
  my $dbh = DBI->connect("dbi:SQLite:test.db");
  
  my $sth = $dbh->prepare("select * from table1;");
  $sth->execute;
  my @rows = $sth->fetchrow_array;
  foreach (@rows) {
	  print qq(row: ) . $_ . qq(\n);
  }
  exit 0;

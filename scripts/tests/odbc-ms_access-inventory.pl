#!/usr/bin/perl

# script to test an ODBC DSN on Windows

use strict;
use warnings;
use DBI;

my $dbh = DBI->connect(q(dbi:ODBC:DSN=SIT_Inventory), undef, undef);

my $sql = q|SELECT count (*) from Inventory|;

my $sth = $dbh->prepare($sql);

my $rv = $sth->execute();

print qq(Return value from statement handle execution is $rv\n);

print qq(Values returned for query\n '$sql' are:\n);

my @row = $sth->fetchrow_array();
foreach my $col ( @row ) {
	print qq(\t) . $col . qq(\n);
} # foreach my $col ( @row )


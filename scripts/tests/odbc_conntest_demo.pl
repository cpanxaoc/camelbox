#!/usr/bin/env perl

# script to test out ODBC support

# make sure you have a DSN set up already
# 1) Start -> Settings -> Control Panel -> Administrative Tools 
# -> Data Sources (ODBC) (on Windows XP)
# 2) Click the 'System DSN' tab
# 3) Click the 'Add' button
# 4) Choose an ODBC driver to use; note, there are duplicates of all of the
# drivers, the duplicates are for other languages (Spanish, German).  Which
# driver you choose will affect the sort order returned during queries.
# 5) Click 'Finish' to set up your DSN
# 6) Set up the Data Source Name and Description, and point the dialog to your
# *.csv file (if that's which driver you are using)

# now test it with perl
  use DBI qw(:sql_types);
  my $DSN=q(httpd-procs);
  my $dbh = DBI->connect("dbi:ODBC:$DSN", undef, undef, {RaiseError=>1}) 
  	or die qq($DBI::errstr);
  
my %InfoTests = (
	'SQL_DRIVER_NAME', 6,
	'SQL_DRIVER_VER', 7,
	'SQL_CURSOR_COMMIT_BEHAVIOR', 23,
	'SQL_ALTER_TABLE', 86,
	'SQL_ACCESSIBLE_PROCEDURES', 20,
);

foreach $SQLInfo (sort keys %InfoTests) {
   $ret = 0;
   $ret = $dbh->func($InfoTests{$SQLInfo}, GetInfo);
   print "$SQLInfo ($InfoTests{$SQLInfo}):\t$ret\n";
}

$dbh->disconnect;

exit 0;

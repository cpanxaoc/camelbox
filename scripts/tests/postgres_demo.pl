#!/usr/bin/env perl

# script to quickly demo MySQL 

	use DBI;
	$database = "your_db";
	$hostname = "localhost";
	$port = "3306";
	$user = "someuser";
	$password = 'funny_password';

	# set up the DSN
    $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

    $dbh = DBI->connect($dsn, $user, $password);

    $sth = $dbh->prepare("SELECT * FROM some table limit 10");

	$sth->execute;
	$num_rows = $sth->rows;
	while ($ref = $sth->fetchrow_hashref() ) {
		print "row: id = " . $ref->{column1} 
			. "; filename = " . $ref->{column2} . "\n";
	} # while ($ref = $sth->fetchrow_hashref() )
	$sth->finish;
	exit 0;

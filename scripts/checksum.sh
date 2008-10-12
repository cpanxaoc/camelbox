#!/bin/sh

# build a new DBD::OCBC tarball, then run CPAN::Checksum on it
tar -cvf - DBD-ODBC-1.17 | gzip -9 -c - > DBD-ODBC-1.17.tar.gz
perl -e 'use CPAN::Checksums qw(updatedir); my $success = updatedir($ENV{PWD});'


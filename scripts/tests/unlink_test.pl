#!/usr/bin/perl

# a stub file for writing tests

use strict;
use warnings;
my $file = q(unlink_test.txt);
open( FH, qq(> $file) );
print FH qq(this is a test of unlinking a file\n);
close(FH);
if ( -f $file ) { print qq(Before delete: file '$file' exists\n); }
unlink $file;
if ( -f $file ) { print qq(After delete: file '$file' exists\n); }

# vi: set filetype=perl sw=4 ts=4 cin:
# end of line

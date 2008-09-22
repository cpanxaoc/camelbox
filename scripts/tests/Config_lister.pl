#!/usr/bin/perl

# dump Config
use strict;
use warnings;
use Config;

foreach my $key ( sort(keys(%Config)) ) {
    if ( defined $Config{$key} ) {
        print qq($key : ) . $Config{$key} . qq(\n);
    } else {
        print qq($key : UNDEF\n);
    } # if ( defined $Config{$key} )
} # foreach my $key ( sort(keys(%Config)) )

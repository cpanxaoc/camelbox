#!/usr/bin/env perl

# demo script to load a JSON data structure
use strict;
use warnings;
use JSON;
use Data::Dumper;

my $parser = JSON->new->ascii->pretty->allow_nonref;

my $json_string;

while ( <STDIN> ) {
    # add the line to the JSON string
    $json_string .= $_;
} # while ( <STDIN> )

my $object = $parser->decode($json_string);
my $dumper = Data::Dumper->new([$object]);
print $dumper->Dump . qq(\n);

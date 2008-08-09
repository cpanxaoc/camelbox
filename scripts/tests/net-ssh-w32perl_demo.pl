#!/usr/bin/env perl

use Net::SSH::W32Perl;
my $ssh = Net::SSH::W32Perl->new($host);
$ssh->login($user, $pass);
my($stdout, $stderr, $exit) = $ssh->cmd($cmd);


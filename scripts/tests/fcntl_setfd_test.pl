#!/usr/bin/env perl

# test to validate the issue seen in
# http://code.google.com/p/camelbox/issues/detail?id=3

use Fcntl;

open (TESTFILE, "> testfile.txt");
fcntl(TESTFILE, &Fcntl::F_SETFD, &Fcntl::FD_CLOEXEC);

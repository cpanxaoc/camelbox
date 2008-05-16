#!/usr/bin/perl
# $Id$

# A script to print out a bunch of info about the current Perl environment
# by Brian Manning (elspicyjack {at} gmail &sdot; com)

# The original script most likely appears in the Perl Cookbook from O'Reilly.

# if the script detects that it's running as under a CGI environment (the
# REQUEST_METHOD environment variable is set), it will wrap the plaintext
# output in the correct HTML tags so the browser will render it in the same
# manner as if the script were running in a shell.

my @found_modules; # a list of modules that were found in @INC paths
my $i=1;	# a counter

# are we CGI?
if ( exists $ENV{'REQUEST_METHOD'} ) {
    print "Content-type: text/html","\n\n";
    print "<html><body><pre>\n";
} # if ( exists $ENV{'REQUEST_METHOD'} )

print "##################################################################\n";
print "# Perl Executable Name (\$^X)                                    #\n";
print "##################################################################\n";
print qq(Executable name: $^X\n);

print "##################################################################\n";
print "# Perl Runtime Environment (\%ENV)                                #\n";
print "##################################################################\n";

# print the runtime environment
foreach my $key ( sort(keys(%ENV)) ) {
    print(sprintf("%2d", $i) . qq( $key = ) . $ENV{$key} . qq(\n));
	$i++;	
} # while (($key, $val) = each %ENV)
print "\n";

$i=1;	# reset counter

# print the @INC array
print "##################################################################\n";
print "# Perl Module Include Paths (\@INC)                               #\n";
print "##################################################################\n";
printf qq(%2d %s\n), $i++, $_ for sort(@INC);
print "\n";

$i=0;	# reset counter

# print installed modules
print "##################################################################\n";
print "# Installed Perl Modules (\&modules in \@INC)                      #\n";
print "##################################################################\n";
# NOTES
#   1. Prune man, pod, etc. directories
#   2. Skip files with a suffix other than .pm
#   3. Format the filename so that it looks more like a module
#   4. Print it
use File::Find;
foreach $start ( @INC ) { find(\&modules, $start); }

# reset counter
my $i=1;
foreach $module ( sort(@found_modules) ) {
    printf qq(%4d %s\n), $i++, $module;
} # foreach $module ( sort(@found_modules) )

# print the butt-end of the HTML if this is CGI
if ( exists $ENV{'REQUEST_METHOD'} ) {
    print "</body></html>\n";
} # if ( exists $ENV{'REQUEST_METHOD'} ) {

exit 0;

### modules ###
sub modules {
	if (-d && /^[a-z]/) { $File::Find::prune = 1; return; }
		return unless /\.pm$/;
       	my $filename = "$File::Find::dir/$_";
      	$filename =~ s!^$start/!!;
       	$filename =~ s!\.pm$!!;
        $filename =~ s!/!::!g;
        push(@found_modules, $filename);
		$i++;
} # sub modules


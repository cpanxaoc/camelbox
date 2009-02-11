#!/usr/bin/env perl

# $Id: shortcut_nsh_builder.pl 502 2008-10-30 08:10:22Z elspicyjack $
# $Date: 2008-10-30 01:10:22 -0700 (Thu, 30 Oct 2008) $
#
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

# A script to generate the camelbox_shortcuts.nsh NSIS script with the
# right files in the right places

# FIXME
# - come up with a program group object which would consume the program group
# part of the JSON blob when fed that blob
# - come up with a shortcut object, which would consume the shortcuts
# contained inside of a program group, and then return a reference to each
# shortcut object that the program group object could store in a list, and
# sort on as desired

#==========================================================================
# Copyright (c)2008 by Brian Manning <elspicyjack at gmail dot com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
#==========================================================================

# what goes in to a shortcut list block
#   "program group folder": { // no '.lnk' on the end of the shortcut name
#       "shortcut1 name" : {
#           // this could also be shortened and $INSTALL_PATH used when the
#           // .nsh file is created
#           "target": "C:\path\to\target.exe",
#           "params": "/a /r /g /s",
#           "iconfile": "C:\path\to\iconfile.exe",
#           "iconidx": "0",
#           "startopts": "SW_SHOWNORMAL",
#           "magickeys": "",
#           "description": "The text that goes in the description field"
#       } // shortcut1
#   } // program group folder

=pod

=head1 NAME

B<shortcut_nsh_builder.pl> - Generate Camelbox NSIS filelists

=head1 SYNOPSIS

 perl shortcut_nsh_builder.pl [options]

 --help|-h          Show this help message
 --verbose|-v       Verbose script output
 --jsonfile|-j      JSON file that describes shortcuts to create
 --outfile|-o       Output file to write NSH script to

 --nocolorlog       Turn off ANSI colors for logging messages
 --debug            Even more verbose script execution

 Color logging is disabled by default on the 'MSWin32' platform.

 Example usage:

 perl shortcut_nsh_builder.pl --jsonfile file.json

=head1 PACKAGES

=head2 Hump::BlockHandlers

Handles the blocks of text that need to be written to the output file.

=cut

package Hump::BlockHandlers;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);
use Date::Format; # formats the header below

sub new {
	my $class = shift;
    my %args = @_;
    my $logger = get_logger();
    
    $logger->logcroak(qq(Output filehandle parameter missing)) 
        unless ( defined $args{output_filehandle} );

    # create the object
	my $self = bless ({ 
        output_filehandle => $args{output_filehandle},
    }, $class);
} # sub new

=pod

=head3 new( output_filehandle => {filehandle to write data to} )

Creates a L<Hump::BlockHandlers> object.  Takes the following arguments:

=over 4

=item output_filehandle

The filehandle to write NSH text to.

=back

=cut

sub header {
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};
	my @gmtime = gmtime;
	my $date = strftime(q(%Y.%j.%H%MZ), @gmtime );
    #my $date = qx/date +%Y.%j.%H%M/;
    #chomp $date;
    print $OUT_FH <<"HEADER"
#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   shortcut_nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/shortcut_nsh_builder.pl)
# DATE:     $date 
#
# COMMENT:  automatically generated file; edit at your own risk

#==========================================================================
# Copyright (c)2008 by Brian Manning <elspicyjack at gmail dot com>
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
#==========================================================================

HEADER
} 

=pod

=head3 header( )

Write the NSH file header, which contains the URL to the source repository, copyright and licence information.

=cut

#### Package 'Hump::Shortcut' ####
package Hump::Shortcut;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

=pod

=head2 Hump::Shortcut

An individual Windows shortcut object, which will have one or more shortcut
attributes as read from the JSON file.

=cut

my @_shortcut_keys = qw( params iconfile target 
        magickeys iconidx startopts description );

sub new {
    my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    if ( ! defined($args{shortcut_hash}) ) {
        $logger->error(qq(Hump::Shortcut was created without passing));
        $logger->logcroak(qq('shortcut_hash' hash reference\n ));
    } # if ( ! defined($args{jsonvar}) )

	# the file exists, bless it into an object
	my $self = bless({ 	
        shortcut_hash => $args{shortcut_hash}, 
        node_hash => {},
        }, 
        $class);

    # 'cast' the shortcut_hash argument into a hash and then enumerate over it
    # to gain access to the keys stored inside
    my %shash = %{$args{shortcut_hash}};
    foreach my $skey ( @_shortcut_keys ) {
        $self->set(key => $skey, value => $shash{$skey});
    } # foreach my $jsonkey ( %{$args{jsonvar}} )
    # return the object to the caller
    return $self;
} # sub new

=pod 

=head3 new( shortcut_hash => { hash containing shortcut attributes } )

Creates a L<Hump::Shortcut> object.  Takes the following arguments:

=over 4

=item shortcut_hash

A reference to the hash containing the key/value pairs that will be used to
create the Windows shortcut.

=back

=cut

sub keys {
    return @_shortcut_keys;
} # sub keys

=pod 

=head3 keys()

Returns the keys of a L<Hump::Shortcut> object.

=cut

sub set {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(set method called without 'key'/'value' arguments))
        unless ( exists $args{key} && exists $args{value} );

    # so store it already
    $logger->debug(qq(Hump::Shortcut->set: ) 
        . $args{key} . q(:) . $args{value});
    $self->{node_hash}->{$args{key}} = $args{value};
} # sub set

=pod 

=head3 set( key => {key}, value => {value} )

Sets values in an L<Hump::Shortcut> object.  Takes the following
arguments:

=over 4

=item key 

Key to use in object hash.

=item value 

Value to store with key in object hash.

=back

=cut

sub get {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(ERROR: get method called without 'key' argument))
        unless ( defined $args{key} );

    if ( exists $self->{node_hash}->{$args{key}} ) {
        return $self->{node_hash}->{$args{key}};
    } else {
        $logger->error(qq(Key ) . $args{key} 
            . qq( does not exist in this object));
    } # if ( exists $node_hash{$args{key}} )
} # sub get

=pod 

=head3 get( key => {key} )

Gets values from an L<Hump::Shortcut> object.  Takes the following
arguments:

=over 4

=item key 

Key describing value to retrieve from object hash.

=back

If the key does not exist in the L<Hump::Shortcut> hash, a warning will be
given.

=cut

#### Package 'Hump::ShortcutGroup' ####
package Hump::ShortcutGroup;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

=pod

=head2 Hump::ShortcutGroup

A group of Windows shortcut objects, typically all placed inside of a folder.

=cut

my @_shortcut_group_keys = qw( name );

sub new {
    my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    if ( ! defined($args{shortcut_hash}) ) {
        $logger->error(qq(Hump::ShortcutGroup was created without passing));
        $logger->logcroak(qq('shortcut_hash' hash reference\n ));
    } # if ( ! defined($args{jsonvar}) )

	# the file exists, bless it into an object
	my $self = bless({ 	
        shortcut_hash => $args{shortcut_hash}, 
        node_hash => {},
        }, 
        $class);

    # 'cast' the shortcut_hash argument into a hash and then enumerate over it
    # to gain access to the keys stored inside
    my %shash = %{$args{shortcut_hash}};
    foreach my $skey ( @_shortcut_keys ) {
        $self->set(key => $skey, value => $shash{$skey});
    } # foreach my $jsonkey ( %{$args{jsonvar}} )
    # return the object to the caller
    return $self;
} # sub new

=pod 

=head3 new( shortcut_hash => { hash containing shortcut attributes } )

Creates a L<Hump::Shortcut> object.  Takes the following arguments:

=over 4

=item shortcut_hash

A reference to the hash containing the key/value pairs that will be used to
create the Windows shortcut.

=back

=cut

sub keys {
    return @_shortcut_keys;
} # sub keys

=pod 

=head3 keys()

Returns the keys of a L<Hump::Shortcut> object.

=cut

sub set {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(set method called without 'key'/'value' arguments))
        unless ( exists $args{key} && exists $args{value} );

    # so store it already
    $logger->debug(qq(Hump::Shortcut->set: ) 
        . $args{key} . q(:) . $args{value});
    $self->{node_hash}->{$args{key}} = $args{value};
} # sub set

=pod 

=head3 set( key => {key}, value => {value} )

Sets values in an L<Hump::Shortcut> object.  Takes the following
arguments:

=over 4

=item key 

Key to use in object hash.

=item value 

Value to store with key in object hash.

=back

=cut

sub get {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(ERROR: get method called without 'key' argument))
        unless ( defined $args{key} );

    if ( exists $self->{node_hash}->{$args{key}} ) {
        return $self->{node_hash}->{$args{key}};
    } else {
        $logger->error(qq(Key ) . $args{key} 
            . qq( does not exist in this object));
    } # if ( exists $node_hash{$args{key}} )
} # sub get

=pod 

=head3 get( key => {key} )

Gets values from an L<Hump::Shortcut> object.  Takes the following
arguments:

=over 4

=item key 

Key describing value to retrieve from object hash.

=back

If the key does not exist in the L<Hump::Shortcut> hash, a warning will be
given.

=cut

#### Package 'Hump::JSON::Shortcuts' ####
package Hump::JSON::Shortcuts;
use strict;
use warnings;
use JSON::PP;
use Log::Log4perl qw(get_logger);

sub new {
	my $class = shift;
	my %args = @_;
    my $logger = get_logger();
	
    $logger->logcroak(qq(JSON filelist undefined))
        unless ( defined($args{jsonfile}) );

    $logger->logcroak(qq(JSON file ) . $args{jsonfile} . qq( does not exist))
        unless ( -f $args{jsonfile} );

	# the file exists, bless it into an object
	my $self = bless({ 	jsonfile => $args{jsonfile} }, $class);
	open(FH, $self->{jsonfile}) 
        || $logger->logcroak(qq(Can't open file ) 
        . $self->{jsonfile} . qq(: $!));
	binmode(FH);
    my $parser = JSON::PP->new->ascii->pretty->allow_nonref;
    my $json_string;
    my $json_line_count;
    while(<FH>) {
        $json_string .= $_;
        $json_line_count++;
    } # while(<FH>)
    $logger->warn(qq(Read $json_line_count lines));
	$self->{jsonobj} = $parser->decode($json_string);
    # return the decoded data
	return $self;
} # sub new

sub get_all_program_groups {
    my $self = shift;
    my $logger = get_logger();

    my %program_groups = %{$self->{jsonobj}};
    $logger->warn(qq(program groups are:));
    $logger->warn(join(q(|), keys(%program_groups)));
    return keys(%program_groups);
} # sub get_all_program_groups

sub get_program_group_data {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my $pg = $args{program_group};
    die qq(program_group argument to get_program_group_data is undefined)
        unless ( defined $pg );
    $logger->warn(q(Got project group ) . $pg);
    #$pg =~ s/\\/\\\\/g; 
    use Data::Dumper;
    my %jsonobj = %{$self->{jsonobj}};
    my $program_group = $jsonobj{$pg};
    my @program_group_keys = keys(%{$program_group});
    #print Dumper $program_group;
    $logger->warn(q(joined program group keys: ) 
        . join(q(|), @program_group_keys) );
    my %pghash = %{$program_group};
    my @return;
    foreach my $pgkey ( @program_group_keys ) {
        my $hashref = $pghash{$pgkey};
        $logger->warn(qq(dumping shortcut $pgkey));
        push (@return, $hashref);
        #print Dumper $hashref;
    } 
#    return $program_group;
    return @return;
} # sub get_all_program_groups

sub dump_objects {
    my $self = shift;

    use Data::Dumper;
    print Dumper $self->{jsonobj};
} # sub dump_objects

#### Package Hump::WriteBlocks ####
package Hump::WriteBlocks;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

my $total_unpacked_size;
my $total_archived_size;

sub new {
	my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(Output filehandle parameter missing)) 
        unless ( defined $args{output_filehandle} );

	my $self = bless ({ 
            output_filehandle   => $args{output_filehandle},
    }, $class); # my $self = bless
    return $self;
} # sub new

sub write_group {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    my $OUT_FH = $self->{output_filehandle};
} # sub output_group

#### begin package main ####
package main;

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Carp;
use Log::Log4perl qw(get_logger);
use Log::Log4perl::Level;

my $o_verbose = 0;
my $o_debug = 0;
my $o_colorlog = 1;

my ($o_startdir, $o_jsonfile, $o_outfile, $o_dump_blocks);
my $go_parse = Getopt::Long::Parser->new();
$go_parse->getoptions( 
	q(verbose|v)                    => \$o_verbose,
	q(debug|d)                    	=> \$o_debug,
    q(help|h)                       => \&ShowHelp,
	q(jsonfile|j=s)                 => \$o_jsonfile,
    q(outfile|o:s)                  => \$o_outfile,
    q(colorlog!)                    => \$o_colorlog,
); # $go_parse->getoptions

# always turn off color logs under Windows, the terms don't do ANSI
if ( $^O =~ /MSWin32/ ) { $o_colorlog = 0; }

# set up the logger
my $logger_conf = qq(log4perl.rootLogger = WARN, Screen\n);
if ( $o_colorlog ) {
    $logger_conf .= qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::ScreenColoredLevels\n);
} else {
    $logger_conf .= qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::Screen\n);
} # if ( $Config->get(q(o_colorlog)) )

$logger_conf .= qq(log4perl.appender.Screen.stderr = 1\n)
    . qq(log4perl.appender.Screen.layout = PatternLayout\n)
#. q(log4perl.appender.Screen.layout.ConversionPattern = %d %p %m%n)
    . q(log4perl.appender.Screen.layout.ConversionPattern = %p -> %m%n)
    . qq(\n);
#log4perl.appender.Screen.layout.ConversionPattern = %d %p> %F{1}:%L %M - %m%n
# create the logger object
Log::Log4perl::init( \$logger_conf );
my $logger = get_logger("");

# this is fugly, but it works
my $program_name = (split(/\//,$0))[-1];
$logger->warn(qq(==== $program_name ====));

# change the log level from INFO if the user requests more gar-bage
if ( $o_verbose ) { $logger->level($INFO); }
if ( $o_debug ) { $logger->level($DEBUG); }

# script operations:
# - read in the JSON document
# - print out the NSH file, with the shortcut groups and shortcuts in thier
# right places

$logger->logcroak(qq(JSON filelist undefined))
    unless ( defined($o_jsonfile) );

$logger->logcroak(qq(JSON file '$o_jsonfile' does not exist))
    unless ( -f $o_jsonfile );
$logger->warn(qq(Reading JSON shortcuts file '$o_jsonfile'));
# read in the JSON shortcuts file
my $shortcuts = Hump::JSON::Shortcuts->new( jsonfile => $o_jsonfile );

if ( $o_verbose ) {
    $shortcuts->dump_objects();
} # if ( $o_verbose )

# if an output file was specified, set that up now; otherwise, use STDOUT
# create a scalar for holding the output filehandle
my $OUT_FH;
if ( $o_outfile ) {
    if ( ! open($OUT_FH, qq(>$o_outfile)) ) {
        $logger->warn(qq(Can't open output file $o_outfile for writing;));
        $logger->logcroak($!);
    } # if ( ! open($OUT_FH, qq(>$o_outfile)) )
} else {
    $OUT_FH = *STDOUT;
} # if ( $o_outfile )

# object that writes blocks of NSIS scripting
my $writeblocks = Hump::WriteBlocks->new( 
        shortcuts           => $shortcuts,
        output_filehandle   => $OUT_FH
); # my $writeblocks = Hump::WriteBlocks->new

# loop over all of the program groups
foreach my $pg ( $shortcuts->get_all_program_groups() ) {
   #$writeblocks->write_group(program_group => $program_group);
    my $pg_obj = $shortcuts->get_program_group_data(program_group => $pg);
    $logger->warn(qq(Calling get_program_group_data with $pg));
} 
exit 0;

#### end main ####

#### main subroutines ####

sub HelpCroak {
    croak(qq(Use '$0 --help' to view script options\n ));
    exit 1;
} # sub HelpCroak 

sub ShowHelp {
# shows the POD documentation (short or long version)
    my $whichhelp = shift;  # retrieve what help message to show
    shift; # discard the value

    # call pod2usage and have it exit non-zero
    # if if one of the 2 shorthelp options were not used, call longhelp
    if ( ($whichhelp eq q(help))  || ($whichhelp eq q(h)) ) {
        pod2usage(-exitstatus => 1,
			-message => qq(Hint: 'perldoc $0' to see full help text));
    } else {
        pod2usage(-exitstatus => 1, -verbose => 2);
    } # if ( ($whichhelp eq q(help))  || ($whichhelp eq q(h)) )
} # sub ShowHelp

#### end Package main ####

=pod

=head1 AUTHOR

Brian Manning E<lt>elspicyjack at gmail dot comE<gt>

=cut

# vi: set sw=4 ts=4 cin:
# end of line

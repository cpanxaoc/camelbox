#!/usr/bin/env perl

# $Id: shortcut_nsh_builder.pl 502 2008-10-30 08:10:22Z elspicyjack $
# $Date: 2008-10-30 01:10:22 -0700 (Thu, 30 Oct 2008) $
#
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

# A script to generate the camelbox_shortcuts.nsh NSIS script with the
# right files in the right places

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
#   "program group folder": { 
#       "shortcut1 name" : { // no '.lnk' on the end of the shortcut name 
#           // this could also be shortened and $INSTDIR used when the
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

B<shortcut_nsh_builder.pl> - Generate Camelbox NSIS Windows shortcut file

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
    my $year = strftime(q(%Y), @gmtime);
    #chomp $date;
    print $OUT_FH <<"HEADER";
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
# Copyright (c) $year by Brian Manning <elspicyjack at gmail dot com>
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

HEADER

	print $OUT_FH <<'MOREHEADER'; 
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

# for the StartPage
var d_Shortcuts
var dS_StatusBox
var dialog_output

# custom page for displaying the status of shortcut creation
Function ShortcutsDialog
	# http://forums.winamp.com/showthread.php?threadid=297163
	# every time you use a nsDialogs macro, you need to pop the return value
	# off of the stack; sometimes you can save and reuse this value (it's a
	# reference to a dialog window for example)
	nsDialogs::Create /NOUNLOAD 1018
	Pop $d_Shortcuts

	# coordinates for dialogs
	# 1 - some number; see docs
	# 2 - horizontal offset
	# 3 - vertical offset
	# 4 - box width
	# 5 - box height

	nsDialogs::CreateControl /NOUNLOAD ${__NSD_Text_CLASS} ${DEFAULT_STYLES}|${WS_TABSTOP}|${ES_AUTOHSCROLL}|${ES_MULTILINE}|${WS_VSCROLL} ${__NSD_Text_EXSTYLE} 0 13u 100% -13u ""
	#${NSD_CreateText} 0 13u 100% -13u ""
	pop $dS_StatusBox

	# change the dialog background to white
	SetCtlColors $dS_StatusBox "" 0xffffff

	StrCpy $dialog_output "The following shortcuts were created:"

MOREHEADER
} 

=head3 header( )

Write the NSH file header, which contains the URL to the source repository, copyright and licence information.

=cut

sub footer {
    my $self = shift;
    my $OUT_FH = $self->{output_filehandle};
    print $OUT_FH <<'FOOTER';
	${NSD_SetText} $dS_StatusBox $dialog_output
	nsDialogs::Show

#	Call CreateShortcuts

	FailBail:
		push $0
		Call ShortcutErrorExit
FunctionEnd

Function ShortcutErrorExit
	# pop the error message off of the stack
	pop $0
	DetailPrint "Installer encountered the following fatal error:"
	abort "$0; Aborting..."
FunctionEnd

# files with icons in them
# taken from: http://nsis.sourceforge.net/Many_Icons_Many_shortcuts
# C:\Windows\system32\shell32.dll
# C:\Windows\system32\accwiz.exe
# C:\Windows\system32\progman.exe
# C:\Windows\explorer.exe
# C:\Windows\system32\cdfview.dll
# C:\Windows\system32\compstui.dll
# C:\Windows\system32\dmdskres.dll
# C:\Windows\system32\pifmgr.dll
# C:\Windows\system32\wmploc.dll
# C:\Windows\system32\moricons.dll

Function ShortCutFeedback
# use SendMessage with a text box to give the user feedback about creating
# shortcuts and where they're being created
# does nothing
Nop
FunctionEnd

Function CheckShortcutFileExists
# - check that the file that the shortcut will point to exists; if not, exit
# - check that the directory exists; if not, create it
# - check that the shortcut file exists; if not, create it
FunctionEnd

# vim: filetype=nsis paste

FOOTER
} # sub footer

=head3 footer( )

Write the NSH file footer, which contains some miscellaneous functions.

=cut

#### Package 'Hump::Shortcut' ####
package Hump::Shortcut;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

=head2 Hump::Shortcut

An individual Windows shortcut object, which will have one or more shortcut
attributes as read from the JSON file.

=cut

#my @_shortcut_keys = qw( params iconfile target 
#        magickeys iconidx startopts description );

my @_shortcut_keys;

sub new {
    my $class = shift;
    my %args = @_;
    my $logger = get_logger();

    if ( ! defined($args{shortcut_hash}) ) {
        $logger->error(qq(Hump::Shortcut was created without passing));
        $logger->logcroak(qq('shortcut_hash' hash reference\n ));
    } # if ( ! defined($args{jsonvar}) )

    if ( ! defined($args{shortcut_name}) ) {
        $logger->error(qq(Hump::Shortcut was created without passing));
        $logger->logcroak(qq('shortcut_name' scalar variable\n ));
    } # if ( ! defined($args{jsonvar}) )

	# the file exists, bless it into an object
	my $self = bless({ 	
        shortcut_hash => $args{shortcut_hash}, 
		shortcut_name => $args{shortcut_name},
        node_hash => {},
        }, $class
	); # my $self = bless

    # 'cast' the shortcut_hash argument into a hash and then enumerate over it
    # to gain access to the keys stored inside
    my %shash = %{$args{shortcut_hash}};
    foreach my $skey ( sort(keys(%shash)) ) {
        push(@_shortcut_keys, $skey);
        $self->set(key => $skey, value => $shash{$skey});
    } # foreach my $jsonkey ( %{$args{jsonvar}} )
    # return the object to the caller
    return $self;
} # sub new

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

sub write {
    my $self = shift;
	my %args = @_;

	print qq(\t# ) . $self->get( key => q(description) ) . qq("\n);
    print qq(\tIfFileExists ") . $self->get( key => q(target) ) . qq(" 0 +3\n);
    # FIXME add the link target to these next two
    #print qq(\tCreateDirectory ") . $self->get( key => q(target) ) . qq("\n);
    print qq(\tCreateDirectory ) . q("$SMPROGRAMS\\) 
		. $args{program_group} . qq("\n);
    print qq(\tCreateShortCut )
        #. $self->get( key => q(link) )
		. q("$SMPROGRAMS\\) . $args{program_group} 
		. q(\\) . $self->{shortcut_name} . qq(.lnk")
        . q( ")
        . $self->get( key => q(target) ) . q(" ")
        . $self->get( key => q(params) ) . q(" ")
        . $self->get( key => q(iconfile) ) . q(" )
        . $self->get( key => q(iconidx) ) . q( )
        . $self->get( key => q(startopts) ) . q( ")
        . $self->get( key => q(magickeys) ) . q(" ")
        . $self->get( key => q(description) ) . qq("\n);
	print qq(\t) . q(StrCpy $dialog_output "$dialog_output$\r$\n) 
		. $self->get( key => q(description) ) . qq("\n);
	print qq(\n);
} # sub write 

=head3 write()

Writes the shortcut icon NSH command to STDOUT.

=cut

sub dump {
    my $self = shift;
    use Data::Dumper;
    print Dumper $self->{shortcut_hash};
} # sub dump 

=head3 dump()

Dumps the L<Hump::Shortcut> object to the screen.

=cut

#### Package 'Hump::ShortcutGroup' ####
package Hump::ShortcutGroup;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

=head2 Hump::ShortcutGroup

A group of Windows shortcut objects, typically all placed inside of a folder.

=cut

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
        _shortcut_hash => $args{shortcut_hash}, 
        _group_name => $args{group_name},
        _node_hash => {},
    }, $class);

    # 'cast' the shortcut_hash argument into a hash and then enumerate over it
    # to gain access to the keys stored inside
    my %shash = %{$args{shortcut_hash}};
    foreach my $skey ( keys(%shash) ) {
        $logger->debug(qq(Creating shortcut for '$skey'));
        my $thisshortcut = Hump::Shortcut->new(
            shortcut_name => $skey,
            shortcut_hash => $shash{$skey}
        );
        $logger->info(qq(Adding shortcut object for key '$skey'));
        $self->set(key => $skey, value => $thisshortcut);
    } # foreach my $jsonkey ( %{$args{jsonvar}} )
    # return the object to the caller
    return $self;
} # sub new

=head3 new( shortcut_hash => { hash containing shortcut attributes } )

Creates a L<Hump::Shortcut> object.  Takes the following arguments:

=over 4

=item shortcut_hash

A reference to the hash containing the key/value pairs that will be used to
create the Windows shortcut.

=back

=cut

sub get_group_keys {
    my $self = shift;
    # return the keys to the node hash
    return sort( keys(%{$self->{_node_hash}}) );
}

=head3 get_group_keys ()

Returns a list of keys that can be used to retreive that program group.

=cut

sub get_group_name {
    my $self = shift;
    # return the keys to the node hash
    return $self->{_group_name};
}

=head3 get_group_keys ()

Returns a list of keys that can be used to retreive that program group.

=cut

sub set {
    my $self = shift;
    my %args = @_;
    my $logger = get_logger();

    $logger->logcroak(qq(set method called without 'key'/'value' arguments))
        unless ( exists $args{key} && exists $args{value} );

    # so store it already
    $logger->debug(qq(Hump::ShortcutGroup->set: ) 
        . $args{key} . q(:) . $args{value});
    $self->{_node_hash}->{$args{key}} = $args{value};
} # sub set

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

    if ( exists $self->{_node_hash}->{$args{key}} ) {
        return $self->{_node_hash}->{$args{key}};
    } else {
        $logger->error(qq(Key ) . $args{key} 
            . qq( does not exist in this object));
    } # if ( exists $node_hash{$args{key}} )
} # sub get

=head3 get( key => {key} )

Gets shortcut objects from an L<Hump::ShortcutGroup> object.  Takes the
following arguments:

=over 4

=item key 

Key describing shortcut to retrieve from ShortcutGroup hash.

=back

If the key does not exist in the L<Hump::ShortcutGroup> hash, a warning will
be given.

=cut

#### Package 'Hump::JSON::ShortcutFile' ####
package Hump::JSON::ShortcutFile;
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
	my $self = bless({ _jsonfile => $args{jsonfile} }, $class);
	open(FH, $self->{_jsonfile}) 
        || $logger->logcroak(qq(Can't open file ) 
        . $self->{_jsonfile} . qq(: $!));
	binmode(FH);
    my $parser = JSON::PP->new->ascii->pretty->allow_nonref;
    my $json_string;
    my $json_line_count;
    while(<FH>) {
        $json_string .= $_;
        $json_line_count++;
    } # while(<FH>)
    $logger->info(qq(Read $json_line_count lines));
	$self->{jsonobj} = $parser->decode($json_string);
    # return the decoded data
	return $self;
} # sub new

sub create_group_objects {
    my $self = shift;
    my $logger = get_logger();

    my %program_groups = %{$self->{jsonobj}};
    $logger->info(qq(program groups are:));
    $logger->info(join(q(, ), keys(%program_groups)));
    my @return_groups;
    foreach my $pg_key ( sort(keys(%program_groups)) ) {
        $logger->info(qq(This group is named '$pg_key'));
        my $tmp_group = 
            Hump::ShortcutGroup->new( 
                group_name => $pg_key,
                shortcut_hash => $program_groups{$pg_key} );
        push(@return_groups, $tmp_group);
    } # foreach my $pg_key ( keys(%program_groups) ) { 
    return @return_groups;
} # sub create_group_objects

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
$logger->info(qq(==== $program_name ====));

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
$logger->info(qq(Reading JSON shortcuts file '$o_jsonfile'));
# read in the JSON shortcuts file
my $shortcuts = Hump::JSON::ShortcutFile->new( jsonfile => $o_jsonfile );

if ( $o_debug ) {
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

my $blockhandler = Hump::BlockHandlers->new(
	output_filehandle   => $OUT_FH
); # my $blockhandler = Hump::BlockHandlers->new

# write the header
$blockhandler->header();

my @program_groups = $shortcuts->create_group_objects();

$logger->info(qq(Parsing of file $o_jsonfile is complete));

foreach my $thisgroup ( @program_groups ) {
    my @group_keys = $thisgroup->get_group_keys();
    my $group_name = $thisgroup->get_group_name();
    $logger->info(qq(Program group '$group_name' has the following shortcuts));
    #$logger->info( join(q(|), @group_keys) );
    foreach my $sc_key ( @group_keys ) {
        my $shortcut = $thisgroup->get( key => $sc_key );
        $shortcut->write(program_group => $group_name);
    } # foreach my $sc_key ( @group_keys )
} # foreach my $thisgroup ( @program_groups )

# write the footer
$blockhandler->footer();
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

=head1 AUTHOR

Brian Manning E<lt>elspicyjack at gmail dot comE<gt>

=cut

# vi: set sw=4 ts=4 :
# end of line

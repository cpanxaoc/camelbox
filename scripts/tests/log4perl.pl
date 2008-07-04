#!/usr/bin/env perl

# $Id: log4perl.pl,v 1.1 2008/01/24 09:44:05 brian Exp $
# Copyright (c)2007 by Brian Manning <elspicyjack at gmail dot com>

# Written for demonstration at San Diego Perl Mongers meeting, February 2008
# http://sandiego.pm.org/ - san-diego-pm-request@pm.org

# script to demonstrate the Log4Perl module
# http://search.cpan.org/~mschilli/Log-Log4perl-1.14/lib/Log/Log4perl.pm
# the CPAN page recommends this tutorial:
# http://www.perl.com/pub/a/2002/09/11/log4perl.html

    use strict;
    use warnings;

    # load Log4perl
    use Log::Log4perl qw(get_logger :levels :easy);

    Log::Log4perl->easy_init($TRACE);
    print qq(\nThis is the demonstration of Log4perl :easy/easy_init\n);
    # these functions are exported by log4perl
    TRACE "We love to trace";
    DEBUG "This doesn't go anywhere";
    INFO  "This is for your info";
    WARN  "You have been warned";
    ERROR "This gets logged";

    print qq(\nAnd here's the demonstration of Log4perl using Perl objects\n)
        . qq(and a Log4perl configuration file\n);

    # the log4perl configuration; this can also live in an external file, or
    # in a URL; see the POD page for (much) more documentation
    my $logger_conf = qq(log4perl.rootLogger = TRACE, Screen\n)
        . qq(log4perl.appender.Screen = )
        . qq(Log::Log4perl::Appender::ScreenColoredLevels\n)
        . qq(log4perl.appender.Screen.stderr = 1\n)
        . qq(log4perl.appender.Screen.layout = PatternLayout\n)
        . q(log4perl.appender.Screen.layout.ConversionPattern = %d %p %m%n)
        . qq(\n);

    # now initialize the Log4perl module using a reference to a scalar that
    # contains a complete Log4perl configuration definition
    Log::Log4perl::init( \$logger_conf );

    # object-oriented usage
    my $logger = Log::Log4perl->get_logger('');
    
    $logger->trace('what are we tracing?');
    $logger->debug('this is a debug message');
    $logger->info('this is an info message');
    $logger->warn('my warning to you is...');
    $logger->error('we love errors');
    $logger->fatal('aieee!!!!');
    print qq(\n);
exit 0;

sub pause {
    print qq(Paused; Please press <ENTER> to continue... );
    my $read = <STDIN>;
} # sub pause

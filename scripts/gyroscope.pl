#!/usr/bin/perl -w
#
# Color Selector
#
# $Id$
# 
# Original script by Gtk2-Perl team
#
# modifications by Brian Manning (elspicyjack {at} gmail &sdot; com)
# 
# GtkColorSelection lets the user choose a color. GtkColorSelectionDialog is
# a prebuilt dialog containing a GtkColorSelection.

use strict;
use Carp;
use Glib qw(TRUE FALSE);
use Gtk2 '-init';
use Gtk2::Pango;

my $window = undef;
my $da;
my $label;
my $color;

sub change_color_callback {
  	my $button = shift;
  
  	my $dialog = Gtk2::ColorSelectionDialog->new ("Change color");

  	$dialog->set_transient_for ($window);
  
  	my $colorsel = $dialog->colorsel;

  	$colorsel->set_previous_color ($color);
  	$colorsel->set_current_color ($color);
  	$colorsel->set_has_palette (TRUE);
  
  	my $response = $dialog->run;

  	if ($response eq 'ok') {
      	$color = $colorsel->get_current_color;
      	$da->modify_bg ('normal', $color);

		#$label->modify_bg('normal', $color);

	   	print STDERR "Changing color to #" . &stringify_color($color) . "\n";
	
		$label->set_text("#" . &stringify_color($color));
  	}


	$dialog->destroy;
}

sub stringify_color {
	$color = shift;

	return sprintf('%02x', int($color->red / 257) )
		. sprintf('%02x', int($color->green / 257) )
		. sprintf('%02x', int($color->blue / 257) ); 

} # sub stringify_color

### main script ###



	# create the window
	$window = Gtk2::Window->new;

	$color = Gtk2::Gdk::Color->new (0, 65535, 0);

	$window->set_title ("Color Selection");

	$window->signal_connect (destroy => sub { Gtk2->main_quit; 1 });

	$window->set_border_width (8);

    my $vbox = Gtk2::VBox->new (FALSE, 8);
	$vbox->set_border_width (8);
    $window->add ($vbox);

	#
    # Create the color swatch area
	#
      
    my $colorframe = Gtk2::Frame->new;
	$colorframe->set_shadow_type ('in');
    $vbox->pack_start ($colorframe, TRUE, TRUE, 0);
    
	$da = Gtk2::DrawingArea->new;
    # set a minimum size
	$da->set_size_request (200, 100);
    # set the color
	$da->modify_bg ('normal', $color);
     
    $colorframe->add ($da);

	my $labelframe = Gtk2::Frame->new;
	$vbox->pack_start ($labelframe, TRUE, TRUE, 0);

	$label = Gtk2::Entry->new();
	$label->set_text("#" . &stringify_color($color));
	#$label = Gtk2::Label->new_with_mnemonic("#" . &stringify_color($color));

	$labelframe->add ($label);

	my $alignment = Gtk2::Alignment->new (1.0, 0.5, 0.0, 0.0);
      
    my $button = Gtk2::Button->new_with_mnemonic ("_Change the above color");
	$alignment->add ($button);
      
    $vbox->pack_start ($alignment, FALSE, FALSE, 0);
      
	$button->signal_connect (clicked => \&change_color_callback);

	if (!$window->visible) {
		$window->show_all;
	} else {
		$window->destroy;
		$window = undef;
	} # if (!$window->visible)

	# pass control to GTK
	Gtk2->main;

1;
__END__
Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.

#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   Brian Manning <elspicyjack at gmail dot com>
# DATE:     2009.162.0134Z 

#==========================================================================
# Copyright (c) 2009 by Brian Manning <elspicyjack at gmail dot com>
# For support with this software, visit the Camelbox Google Groups Page at:
# http://groups.google.com/group/camelbox

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

Function CreateCamelboxURLs
	# create a directory for holding URLs
	# The camelbox_shortcuts.json file will have the path to the URL files
	# below, so that shortcuts to the URLs will be created automatically
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\Camelbox_Homepage.URL" \
		"InternetShortcut" "URL" "http://code.google.com/p/camelbox/"
	WriteINIStr "$INSTDIR\share\urls\Camelbox_FAQ.URL" \
		"InternetShortcut" "URL" "http://code.google.com/p/camelbox/wiki/FAQ"
	WriteINIStr "$INSTDIR\share\urls\Using_Camelbox.URL" \
		"InternetShortcut" "URL" \
		"http://code.google.com/p/camelbox/wiki/UsingCamelbox"
	WriteINIStr "$INSTDIR\share\urls\CamelboxVersionList.URL" \
		"InternetShortcut" "URL" \
		"http://code.google.com/p/camelbox/source/browse/trunk/filelists/_version_list.txt"
FunctionEnd # CreateCamelboxURLs

Function CreatePerlURLs
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\Perldoc.URL" \
		"InternetShortcut" "URL" "http://perldoc.perl.org"
	WriteINIStr "$INSTDIR\share\urls\PerlMonks.URL" \
		"InternetShortcut" "URL" "http://www.perlmonks.org"
	WriteINIStr "$INSTDIR\share\urls\CPANSearch.URL" \
		"InternetShortcut" "URL" "http://search.cpan.org"
	WriteINIStr "$INSTDIR\share\urls\useperl.URL" \
		"InternetShortcut" "URL" "http://use.perl.org"
FunctionEnd # CreatePerlURLs

Function CreateGtk2PerlURLs
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\Gtk2-Perl.URL" \
		"InternetShortcut" "URL" "http://gtk2-perl.sourceforge.net/"
	WriteINIStr "$INSTDIR\share\urls\Gtk2-Perl-POD.URL" \
		"InternetShortcut" "URL" \
        "http://gtk2-perl.sourceforge.net/doc/pod/"
	WriteINIStr "$INSTDIR\share\urls\GTK-API.URL" \
		"InternetShortcut" "URL" "http://library.gnome.org/devel/gtk/stable/"
	WriteINIStr "$INSTDIR\share\urls\Gtk2-Perl-Archives.URL" \
		"InternetShortcut" "URL" \
        "http://mail.gnome.org/mailman/listinfo/gtk-perl-list"
	WriteINIStr "$INSTDIR\share\urls\Gtk2-Perl-Links.URL" \
		"InternetShortcut" "URL" \
        "http://gtk2-perl.sourceforge.net/links/"
FunctionEnd # CreateGtk2PerlURLs

Function CreateGtk2PerlTutorialURLs
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\Gtk2-Perl-Tutorial.URL" \
		"InternetShortcut" "URL" \
        "http://gtk2-perl.sourceforge.net/doc/gtk2-perl-tut/"
	WriteINIStr "$INSTDIR\share\urls\Gtk2-Perl-StudyGuide.URL" \
		"InternetShortcut" "URL" \
        "http://forgeftp.novell.com/gtk2-perl-study/documentation/html/index.html"
	WriteINIStr "$INSTDIR\share\urls\GTK2-Tutorial.URL" \
		"InternetShortcut" "URL" "http://library.gnome.org/devel/gtk-tutorial/stable/"
	WriteINIStr "$INSTDIR\share\urls\PangoConnection.URL" \
		"InternetShortcut" "URL" "http://www-128.ibm.com/developerworks/library/l-u-pango1/"
	WriteINIStr "$INSTDIR\share\urls\DrawingGtk2-Perl.URL" \
		"InternetShortcut" "URL" "http://perlmonks.org/?node_id=583578"
FunctionEnd # CreateGtk2PerlTutorialURLs

Function CreateGlade2TutorialURLs
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\DevelGlade2.URL" \
		"InternetShortcut" "URL" "http://www.kplug.org/glade_tutorial/glade2_tutorial/glade2_introduction.html"
	WriteINIStr "$INSTDIR\share\urls\Glade2-Basic.URL" \
		"InternetShortcut" "URL" "http://www.kplug.org/glade_tutorial/glade2_tutorial/gladewidgets.html"
	WriteINIStr "$INSTDIR\share\urls\Glade2-Additional.URL" \
		"InternetShortcut" "URL" "http://www.kplug.org/glade_tutorial/glade2_tutorial/gladewidgets2.html"
	WriteINIStr "$INSTDIR\share\urls\Glade2-Gnome.URL" \
		"InternetShortcut" "URL" "http://www.kplug.org/glade_tutorial/glade2_tutorial/gladewidgets3.html"
	WriteINIStr "$INSTDIR\share\urls\Glade2-Deprecated.URL" \
		"InternetShortcut" "URL" "http://www.kplug.org/glade_tutorial/glade2_tutorial/gladewidgets4.html"
FunctionEnd # CreateGlade2TutorialURLs

# vim: filetype=nsis paste

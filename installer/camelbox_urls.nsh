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
	WriteINIStr "$INSTDIR\share\urls\Camelbox_Home_Page.URL" \
		"InternetShortcut" "URL" "http://code.google.com/p/camelbox/"
	WriteINIStr "$INSTDIR\share\urls\Camelbox_FAQ.URL" \
		"InternetShortcut" "URL" "http://code.google.com/p/camelbox/wiki/FAQ"
	WriteINIStr "$INSTDIR\share\urls\Using_Camelbox.URL" \
		"InternetShortcut" "URL" \
		"http://code.google.com/p/camelbox/wiki/UsingCamelbox"
	WriteINIStr "$INSTDIR\share\urls\Camelbox_Versions.URL" \
		"InternetShortcut" "URL" \
		"http://code.google.com/p/camelbox/source/browse/trunk/filelists/_version_list.txt"
FunctionEnd # CreateCamelboxURLs

Function CreatePerlURLs
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\CPANSearch.URL" \
		"InternetShortcut" "URL" "http://search.cpan.org"
	WriteINIStr "$INSTDIR\share\urls\Perldoc.URL" \
		"InternetShortcut" "URL" "http://perldoc.perl.org"
	WriteINIStr "$INSTDIR\share\urls\PerlMonks.URL" \
		"InternetShortcut" "URL" "http://www.perlmonks.org"
FunctionEnd # CreatePerlURLs

Function CreateGtk2PerlURLs
	IfFileExists "$INSTDIR\share\urls\*.*" SkipURLDir 0
	# create the URL directory if it hasn't already been created
	CreateDirectory "$INSTDIR\share\urls"
	SkipURLDir:
	WriteINIStr "$INSTDIR\share\urls\CPANSearch.URL" \
		"InternetShortcut" "URL" "http://search.cpan.org"
	WriteINIStr "$INSTDIR\share\urls\Perldoc.URL" \
		"InternetShortcut" "URL" "http://perldoc.perl.org"
	WriteINIStr "$INSTDIR\share\urls\PerlMonks.URL" \
		"InternetShortcut" "URL" "http://www.perlmonks.org"
FunctionEnd # CreatePerlURLs

# vim: filetype=nsis paste

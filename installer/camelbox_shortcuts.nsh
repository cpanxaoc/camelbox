#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   shortcut_nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/shortcut_nsh_builder.pl)
# DATE:     2009.166.2046Z 
#
# COMMENT:  automatically generated file; edit at your own risk

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


# custom page for displaying the status of shortcut creation
Function CreateCamelboxShortcuts

	# does the camelbox home directory exist?
	IfFileExists $INSTDIR\*.* 0 NiceExit
	
	DetailPrint "The following shortcuts were created:"

	# The CPAN Shell
	IfFileExists "$INSTDIR\bin\cpan.bat" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox"
	DetailPrint "The CPAN Shell"
	CreateShortCut "$SMPROGRAMS\Camelbox\CPAN Shell.lnk" "$INSTDIR\bin\cpan.bat" "" "$INSTDIR\bin\wperl.exe" 0 SW_SHOWNORMAL "" "The CPAN Shell"

	# Uninstall Camelbox
	IfFileExists "$INSTDIR\camelbox_uninstaller.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox"
	DetailPrint "Uninstall Camelbox"
	CreateShortCut "$SMPROGRAMS\Camelbox\Camelbox Uninstaller.lnk" "$INSTDIR\camelbox_uninstaller.exe" "" "$INSTDIR\camelbox_uninstaller.exe" 0 SW_SHOWNORMAL "" "Uninstall Camelbox"

	# The zsh shell compiled for Windows
	IfFileExists "$INSTDIR\bin\sh.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox"
	DetailPrint "The zsh shell compiled for Windows"
	CreateShortCut "$SMPROGRAMS\Camelbox\zsh.lnk" "$INSTDIR\bin\sh.exe" "" "$INSTDIR\bin\sh.exe" 0 SW_SHOWNORMAL "" "The zsh shell compiled for Windows"

	# ASCII Art Editor
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Applications"
	DetailPrint "ASCII Art Editor"
	CreateShortCut "$SMPROGRAMS\Camelbox\Applications\Asciio.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\asciio" "$SYSDIR\shell32.dll" 75 SW_SHOWNORMAL "" "ASCII Art Editor"

	# Perl POD Viewer
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Applications"
	DetailPrint "Perl POD Viewer"
	CreateShortCut "$SMPROGRAMS\Camelbox\Applications\podviewer.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer" "$SYSDIR\wmploc.dll" 23 SW_SHOWNORMAL "" "Perl POD Viewer"

	# MySQL Command Line Client
	IfFileExists "$INSTDIR\bin\mysql.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Database Tools"
	DetailPrint "MySQL Command Line Client"
	CreateShortCut "$SMPROGRAMS\Camelbox\Database Tools\MySQL Client.lnk" "$INSTDIR\bin\mysql.exe" "" "$SYSDIR\shell32.dll" 164 SW_SHOWNORMAL "" "MySQL Command Line Client"

	# PostgreSQL Command Line Client
	IfFileExists "$INSTDIR\bin\psql.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Database Tools"
	DetailPrint "PostgreSQL Command Line Client"
	CreateShortCut "$SMPROGRAMS\Camelbox\Database Tools\PostgreSQL Client.lnk" "$INSTDIR\bin\psql.exe" "" "$INSTDIR\bin\psql.exe" 0 SW_SHOWNORMAL "" "PostgreSQL Command Line Client"

	# Gtk2::Ex::Dialogs Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2::Ex::Dialogs Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-Ex-Dialogs.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-Ex-Dialogs\demo.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2::Ex::Dialogs Demo"

	# Gtk2::Ex::Simple::List Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2::Ex::Simple::List Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-Ex-Simple-List.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-Ex-Simple-List\simple_list.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2::Ex::Simple::List Demo"

	# Gtk2::GladeXML Clipboard Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2::GladeXML Clipboard Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-GladeXML Clipboard.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-GladeXML\clipboard.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2::GladeXML Clipboard Demo"

	# Gtk2::GladeXML Hello World Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2::GladeXML Hello World Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-GladeXML Hello World.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-GladeXML\hello-world.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2::GladeXML Hello World Demo"

	# Gtk2::GladeXML Progress Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2::GladeXML Progress Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-GladeXML Progress.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-GladeXML\progress.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2::GladeXML Progress Demo"

	# Gtk2::GladeXML Scribble Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2::GladeXML Scribble Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-GladeXML Scribble.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-GladeXML\scribble.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2::GladeXML Scribble Demo"

	# Gtk2-Perl main.pl Demo Starter
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2-Perl main.pl Demo Starter"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\Gtk2-Perl main.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2-Demo\main.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2-Perl main.pl Demo Starter"

	# Gtk2 Assistants Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2 Assistants Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\assistant.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2\assistant.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2 Assistants Demo"

	# Gtk2 Buttonbox Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2 Buttonbox Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\buttonbox.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2\buttonbox.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2 Buttonbox Demo"

	# Gnome2::Canvas Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gnome2::Canvas Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\canvas.pl.lnk" "$INSTDIR\bin\wperl.exe" "-I$INSTDIR\examples\Gnome2-Canvas $INSTDIR\examples\Gnome2-Canvas\canvas.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gnome2::Canvas Demo"

	# Goo::Canvas Canvas Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Goo::Canvas Canvas Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\demo.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Goo-Canvas\demo.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Goo::Canvas Canvas Demo"

	# Gyroscope color picker
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gyroscope color picker"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\gyroscope.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\gyroscope.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gyroscope color picker"

	# Goo::Canvas Example: Perl Minesweeper
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Goo::Canvas Example: Perl Minesweeper"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\perlmine.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\perlmine.pl" "$SYSDIR\shell32.dll" 208 SW_SHOWNORMAL "" "Goo::Canvas Example: Perl Minesweeper"

	# Goo::Canvas Example: Perl Tetris
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Goo::Canvas Example: Perl Tetris"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\perltetris.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\perltetris.pl" "$SYSDIR\shell32.dll" 189 SW_SHOWNORMAL "" "Goo::Canvas Example: Perl Tetris"

	# Gtk2 Scribble Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2 Scribble Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\scribble.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2\scribble.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2 Scribble Demo"

	# Gtk2 Simple List Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2 Simple List Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\simplelist.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2\simplelist.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2 Simple List Demo"

	# Goo::Canvas Table Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Goo::Canvas Table Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\table.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Goo-Canvas\table.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Goo::Canvas Table Demo"

	# Gtk2 Table Packing Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Gtk2 Table Packing Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\table_packing.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Gtk2\table_packing.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Gtk2 Table Packing Demo"

	# Goo::Canvas Units Demo
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Goo::Canvas Units Demo"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\unit-demo.pl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\examples\Goo-Canvas\unit-demo.pl" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Goo::Canvas Units Demo"

	# Widget: Tk Widget Demo Script
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	DetailPrint "Widget: Tk Widget Demo Script"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\widget.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\widget" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Widget: Tk Widget Demo Script"

	# The Glade XML GUI Generation Toolkit
	IfFileExists "$INSTDIR\bin\glade-3.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Developer Tools"
	DetailPrint "The Glade XML GUI Generation Toolkit"
	CreateShortCut "$SMPROGRAMS\Camelbox\Developer Tools\Glade-3.lnk" "$INSTDIR\bin\glade-3.exe" "" "$INSTDIR\bin\glade-3.exe" 0 SW_SHOWNORMAL "" "The Glade XML GUI Generation Toolkit"

	# Podviewer: perl.pod - Practical Extraction and Reporting Language
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perl.pod - Practical Extraction and Reporting Language"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perl.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perl.pod - Practical Extraction and Reporting Language"

	# Podviewer: perldata.pod - Perl data types
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perldata.pod - Perl data types"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perldata.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perldata.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perldata.pod - Perl data types"

	# Podviewer: perlfunc.pod - Perl Functions
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perlfunc.pod - Perl Functions"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perlfunc.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlfunc.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlfunc.pod - Perl Functions"

	# Podviewer: perlintro.pod - Introduction to Perl
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perlintro.pod - Introduction to Perl"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perlintro.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlintro.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlintro.pod - Introduction to Perl"

	# Podviewer: perlrun.pod - Executing the Perl interpreter
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perlrun.pod - Executing the Perl interpreter"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perlrun.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlrun.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlrun.pod - Executing the Perl interpreter"

	# Podviewer: perlsyn.pod - Perl Syntax
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perlsyn.pod - Perl Syntax"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perlsyn.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlsyn.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlsyn.pod - Perl Syntax"

	# Podviewer: perlvar.pod - Perl predefined variables
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Local Docs"
	DetailPrint "Podviewer: perlvar.pod - Perl predefined variables"
	CreateShortCut "$SMPROGRAMS\Camelbox\Local Docs\POD: perlvar.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlvar.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlvar.pod - Perl predefined variables"

	# Camelbox FAQ on the Internet
	IfFileExists "$INSTDIR\share\urls\Camelbox_FAQ.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Camelbox FAQ on the Internet"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Camelbox FAQ.lnk" "$INSTDIR\share\urls\Camelbox_FAQ.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Camelbox FAQ on the Internet"

	# Camelbox Homepage on the Internet
	IfFileExists "$INSTDIR\share\urls\Camelbox_Homepage.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Camelbox Homepage on the Internet"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Camelbox Homepage.lnk" "$INSTDIR\share\urls\Camelbox_Homepage.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Camelbox Homepage on the Internet"

	# Camelbox Software Versions; _version_list.txt file in SVN
	IfFileExists "$INSTDIR\share\urls\CamelboxVersionList.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Camelbox Software Versions; _version_list.txt file in SVN"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Camelbox Version List.lnk" "$INSTDIR\share\urls\CamelboxVersionList.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Camelbox Software Versions; _version_list.txt file in SVN"

	# Using Camelbox page on the Internet
	IfFileExists "$INSTDIR\share\urls\Using_Camelbox.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Using Camelbox page on the Internet"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Using Camelbox.lnk" "$INSTDIR\share\urls\Using_Camelbox.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Using Camelbox page on the Internet"

	# Additional Gtk+ widgets
	IfFileExists "$INSTDIR\share\urls\Glade2-Additional.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor"
	DetailPrint "Additional Gtk+ widgets"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor\Additional Widgets.lnk" "$INSTDIR\share\urls\Glade2-Additional.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Additional Gtk+ widgets"

	# The basic widgets in more detail
	IfFileExists "$INSTDIR\share\urls\Glade2-Basic.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor"
	DetailPrint "The basic widgets in more detail"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor\Basic Widgets.lnk" "$INSTDIR\share\urls\Glade2-Basic.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "The basic widgets in more detail"

	# Deprecated widgets
	IfFileExists "$INSTDIR\share\urls\Glade2-Deprecated.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor"
	DetailPrint "Deprecated widgets"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor\Deprecated Widgets.lnk" "$INSTDIR\share\urls\Glade2-Deprecated.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Deprecated widgets"

	# Graphical Interface Development with Glade2
	IfFileExists "$INSTDIR\share\urls\DevelGlade2.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor"
	DetailPrint "Graphical Interface Development with Glade2"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor\Development with Glade2.lnk" "$INSTDIR\share\urls\DevelGlade2.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Graphical Interface Development with Glade2"

	# Gnome widgets
	IfFileExists "$INSTDIR\share\urls\Glade2-Gnome.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor"
	DetailPrint "Gnome widgets"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Glade2 Editor\Gnome Widgets.lnk" "$INSTDIR\share\urls\Glade2-Gnome.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gnome widgets"

	# GTK C API Documentation
	IfFileExists "$INSTDIR\share\urls\GTK-API.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl"
	DetailPrint "GTK C API Documentation"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl\GTK C API Documentation.lnk" "$INSTDIR\share\urls\GTK-API.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "GTK C API Documentation"

	# Gtk2-Perl Home Page
	IfFileExists "$INSTDIR\share\urls\Gtk2-Perl.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl"
	DetailPrint "Gtk2-Perl Home Page"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl\Gtk2-Perl Homepage.lnk" "$INSTDIR\share\urls\Gtk2-Perl.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gtk2-Perl Home Page"

	# Gtk2-Perl Links page on Sourceforge
	IfFileExists "$INSTDIR\share\urls\Gtk2-Perl-Links.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl"
	DetailPrint "Gtk2-Perl Links page on Sourceforge"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl\Gtk2-Perl Links Page.lnk" "$INSTDIR\share\urls\Gtk2-Perl-Links.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gtk2-Perl Links page on Sourceforge"

	# Gtk2-Perl Mailing List Archives
	IfFileExists "$INSTDIR\share\urls\Gtk2-Perl-Archives.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl"
	DetailPrint "Gtk2-Perl Mailing List Archives"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl\Gtk2-Perl Mailing List Archives.lnk" "$INSTDIR\share\urls\Gtk2-Perl-Archives.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gtk2-Perl Mailing List Archives"

	# Gtk2-Perl POD Documentation
	IfFileExists "$INSTDIR\share\urls\Gtk2-Perl-POD.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl"
	DetailPrint "Gtk2-Perl POD Documentation"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl\Gtk2-Perl POD Documentation.lnk" "$INSTDIR\share\urls\Gtk2-Perl-POD.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gtk2-Perl POD Documentation"

	# Drawing shapes with Gtk2-Perl (perlmonks.org)
	IfFileExists "$INSTDIR\share\urls\DrawingGtk2-Perl.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials"
	DetailPrint "Drawing shapes with Gtk2-Perl (perlmonks.org)"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials\Drawing with Gtk2-Perl.lnk" "$INSTDIR\share\urls\DrawingGtk2-Perl.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Drawing shapes with Gtk2-Perl (perlmonks.org)"

	# GTK+ C Language Tutorial
	IfFileExists "$INSTDIR\share\urls\GTK-Tutorial.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials"
	DetailPrint "GTK+ C Language Tutorial"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials\GTK+ Tutorial.lnk" "$INSTDIR\share\urls\GTK-Tutorial.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "GTK+ C Language Tutorial"

	# Gtk2-Perl Study Guide
	IfFileExists "$INSTDIR\share\urls\Gtk2-Perl-StudyGuide.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials"
	DetailPrint "Gtk2-Perl Study Guide"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials\Gtk2-Perl Study Guide.lnk" "$INSTDIR\share\urls\Gtk2-Perl-StudyGuide.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gtk2-Perl Study Guide"

	# Gtk2-Perl Tutorial
	IfFileExists "$INSTDIR\share\urls\Gtk2-Perl-Tutorial.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials"
	DetailPrint "Gtk2-Perl Tutorial"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials\Gtk2-Perl Tutorial.lnk" "$INSTDIR\share\urls\Gtk2-Perl-Tutorial.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Gtk2-Perl Tutorial"

	# The Pango Connection - How to use Pango
	IfFileExists "$INSTDIR\share\urls\PangoConnection.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials"
	DetailPrint "The Pango Connection - How to use Pango"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Gtk2-Perl Tutorials\The Pango Connection.lnk" "$INSTDIR\share\urls\PangoConnection.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "The Pango Connection - How to use Pango"

	# Search the CPAN Archive
	IfFileExists "$INSTDIR\share\urls\CPANSearch.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Perl"
	DetailPrint "Search the CPAN Archive"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Perl\CPAN Search.lnk" "$INSTDIR\share\urls\CPANSearch.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Search the CPAN Archive"

	# Perl Monks, a place for users of Perl
	IfFileExists "$INSTDIR\share\urls\PerlMonks.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Perl"
	DetailPrint "Perl Monks, a place for users of Perl"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Perl\Perl Monks.lnk" "$INSTDIR\share\urls\PerlMonks.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Perl Monks, a place for users of Perl"

	# Perl 5.10.0 online documentation
	IfFileExists "$INSTDIR\share\urls\Perldoc.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Perl"
	DetailPrint "Perl 5.10.0 online documentation"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Perl\Perldoc Documentation.lnk" "$INSTDIR\share\urls\Perldoc.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Perl 5.10.0 online documentation"

	# use.perl.org - Perl News and Community Info
	IfFileExists "$INSTDIR\share\urls\useperl.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Perl"
	DetailPrint "use.perl.org - Perl News and Community Info"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Perl\use.perl.org.lnk" "$INSTDIR\share\urls\useperl.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "use.perl.org - Perl News and Community Info"

	# this skips over the failbail
	NiceExit:
		Return
	FailBail:
		push $0
		Call ShortcutErrorExit
FunctionEnd # CreateCamelboxShortcuts

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

# vim: filetype=nsis paste


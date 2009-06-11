#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   shortcut_nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/shortcut_nsh_builder.pl)
# DATE:     2009.162.0216Z 
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
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perl.pod - Practical Extraction and Reporting Language"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perl.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perl.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perl.pod - Practical Extraction and Reporting Language"

	# Podviewer: perldata.pod - Perl data types
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perldata.pod - Perl data types"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perldata.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perldata.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perldata.pod - Perl data types"

	# Podviewer: perlfunc.pod - Perl Functions
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perlfunc.pod - Perl Functions"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perlfunc.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlfunc.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlfunc.pod - Perl Functions"

	# Podviewer: perlintro.pod - Introduction to Perl
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perlintro.pod - Introduction to Perl"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perlintro.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlintro.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlintro.pod - Introduction to Perl"

	# Podviewer: perlrun.pod - Executing the Perl interpreter
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perlrun.pod - Executing the Perl interpreter"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perlrun.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlrun.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlrun.pod - Executing the Perl interpreter"

	# Podviewer: perlsyn.pod - Perl Syntax
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perlsyn.pod - Perl Syntax"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perlsyn.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlsyn.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlsyn.pod - Perl Syntax"

	# Podviewer: perlvar.pod - Perl predefined variables
	IfFileExists "$INSTDIR\bin\wperl.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Documentation"
	DetailPrint "Podviewer: perlvar.pod - Perl predefined variables"
	CreateShortCut "$SMPROGRAMS\Camelbox\Documentation\POD: perlvar.lnk" "$INSTDIR\bin\wperl.exe" "$INSTDIR\bin\podviewer $INSTDIR\lib\pods\perlvar.pod" "$SYSDIR\shell32.dll" 224 SW_SHOWNORMAL "" "Podviewer: perlvar.pod - Perl predefined variables"

	# Camelbox FAQ on the Internet
	IfFileExists "$INSTDIR\share\urls\Camelbox_FAQ.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Camelbox FAQ on the Internet"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Camelbox FAQ.lnk" "$INSTDIR\share\urls\Camelbox_FAQ.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Camelbox FAQ on the Internet"

	# Camelbox Versions file in SVN
	IfFileExists "$INSTDIR\share\urls\Camelbox_Versions.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Camelbox Versions file in SVN"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Camelbox File Versions.lnk" "$INSTDIR\share\urls\Camelbox_Versions.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Camelbox Versions file in SVN"

	# Camelbox Home Page on the Internet
	IfFileExists "$INSTDIR\share\urls\Camelbox_Home_Page.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Camelbox Home Page on the Internet"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Camelbox Homepage.lnk" "$INSTDIR\share\urls\Camelbox_Home_Page.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Camelbox Home Page on the Internet"

	# Using Camelbox page on the Internet
	IfFileExists "$INSTDIR\share\urls\Using_Camelbox.URL" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Websites\Camelbox"
	DetailPrint "Using Camelbox page on the Internet"
	CreateShortCut "$SMPROGRAMS\Camelbox\Websites\Camelbox\Using Camelbox.lnk" "$INSTDIR\share\urls\Using_Camelbox.URL" "" "$SYSDIR\shell32.dll" 13 SW_SHOWNORMAL "" "Using Camelbox page on the Internet"

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


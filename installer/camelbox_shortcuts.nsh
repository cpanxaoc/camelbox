#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   shortcut_nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/shortcut_nsh_builder.pl)
# DATE:     2009.160.0206Z 
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

	# The CPAN Shell"
	IfFileExists "$INSTDIR\bin\cpan.bat" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox"
	CreateShortCut "$SMPROGRAMS\Camelbox\CPAN Shell.lnk" "$INSTDIR\bin\cpan.bat" "" "$INSTDIR\bin\wperl.exe" 0 SW_SHOWNORMAL "" "The CPAN Shell"
	StrCpy $dialog_output "$dialog_output$\r$\nThe CPAN Shell"

	# The zsh shell compiled for Windows"
	IfFileExists "$INSTDIR\bin\sh.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox"
	CreateShortCut "$SMPROGRAMS\Camelbox\zsh.lnk" "$INSTDIR\bin\sh.exe" "" "$INSTDIR\bin\sh.exe" 0 SW_SHOWNORMAL "" "The zsh shell compiled for Windows"
	StrCpy $dialog_output "$dialog_output$\r$\nThe zsh shell compiled for Windows"

	# ASCII Art Editor"
	IfFileExists "$INSTDIR\bin\asciio.bat" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Applications"
	CreateShortCut "$SMPROGRAMS\Camelbox\Applications\Asciio.lnk" "$INSTDIR\bin\asciio.bat" "" "$SYSDIR\shell32.dll" 75 SW_SHOWNORMAL "" "ASCII Art Editor"
	StrCpy $dialog_output "$dialog_output$\r$\nASCII Art Editor"

	# Perl POD Viewer"
	IfFileExists "$INSTDIR\bin\podviewer.bat C:\camelbox\lib\pods\perl.pod" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Applications"
	CreateShortCut "$SMPROGRAMS\Camelbox\Applications\podviewer.lnk" "$INSTDIR\bin\podviewer.bat C:\camelbox\lib\pods\perl.pod" "" "$SYSDIR\shell32.dll" 134 SW_SHOWNORMAL "" "Perl POD Viewer"
	StrCpy $dialog_output "$dialog_output$\r$\nPerl POD Viewer"

	# MySQL Command Line Client"
	IfFileExists "$INSTDIR\bin\mysql.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Database Tools"
	CreateShortCut "$SMPROGRAMS\Camelbox\Database Tools\MySQL Client.lnk" "$INSTDIR\bin\mysql.exe" "" "$SYSDIR\shell32.dll" 164 SW_SHOWNORMAL "" "MySQL Command Line Client"
	StrCpy $dialog_output "$dialog_output$\r$\nMySQL Command Line Client"

	# PostgreSQL Command Line Client"
	IfFileExists "$INSTDIR\bin\psql.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Database Tools"
	CreateShortCut "$SMPROGRAMS\Camelbox\Database Tools\PostgreSQL Client.lnk" "$INSTDIR\bin\psql.exe" "" "$INSTDIR\bin\psql.exe" 0 SW_SHOWNORMAL "" "PostgreSQL Command Line Client"
	StrCpy $dialog_output "$dialog_output$\r$\nPostgreSQL Command Line Client"

	# Goo::Canvas Example: Perl Minesweeper"
	IfFileExists "$INSTDIR\bin\perlmine.bat" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\perlmine.lnk" "$INSTDIR\bin\perlmine.bat" "" "$SYSDIR\shell32.dll" 208 SW_SHOWNORMAL "" "Goo::Canvas Example: Perl Minesweeper"
	StrCpy $dialog_output "$dialog_output$\r$\nGoo::Canvas Example: Perl Minesweeper"

	# Goo::Canvas Example: Perl Tetris"
	IfFileExists "$INSTDIR\bin\perltetris.bat" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\perltetris.lnk" "$INSTDIR\bin\perltetris.bat" "" "$SYSDIR\shell32.dll" 189 SW_SHOWNORMAL "" "Goo::Canvas Example: Perl Tetris"
	StrCpy $dialog_output "$dialog_output$\r$\nGoo::Canvas Example: Perl Tetris"

	# Widget: Tk Widget Demo Script"
	IfFileExists "$INSTDIR\bin\widget.bat" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Demo Scripts"
	CreateShortCut "$SMPROGRAMS\Camelbox\Demo Scripts\widget.lnk" "$INSTDIR\bin\widget.bat" "" "$SYSDIR\shell32.dll" 93 SW_SHOWNORMAL "" "Widget: Tk Widget Demo Script"
	StrCpy $dialog_output "$dialog_output$\r$\nWidget: Tk Widget Demo Script"

	# The Glade XML GUI Generation Toolkit"
	IfFileExists "$INSTDIR\bin\glade-3.exe" 0 +3
	CreateDirectory "$SMPROGRAMS\Camelbox\Developer Tools"
	CreateShortCut "$SMPROGRAMS\Camelbox\Developer Tools\Glade-3.lnk" "$INSTDIR\bin\glade-3.exe" "" "$INSTDIR\bin\glade-3.exe" 0 SW_SHOWNORMAL "" "The Glade XML GUI Generation Toolkit"
	StrCpy $dialog_output "$dialog_output$\r$\nThe Glade XML GUI Generation Toolkit"

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


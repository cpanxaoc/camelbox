#==========================================================================
#
# TYPE:		NSIS header/include File
#
# NAME: 	camelbox_functions.nsh
#
# AUTHOR: 	$LastChangedBy: elspicyjack $
# DATE: 	$LastChangedDate: 2008-10-27 01:55:59 -0700 (Mon, 27 Oct 2008) $
#
# COMMENT:	$Id: camelbox_functions.nsh 500 2008-10-27 08:55:59Z elspicyjack $
#
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

# for the StartPage
var d_Shortcuts
var dS_StatusBox
var status_text

# custom page for displaying the status of shortcut creation
Function ShortcutsDialog
	# every time you use a nsDialogs macro, you need to pop the return value
	# off of the stack; sometimes you can save and reuse this value (it's a
	# reference to a dialog window for example)
	nsDialogs::Create /NOUNLOAD 1018
	Pop $d_Shortcuts
	StrCmp $0 "error" FailBail 0

	# coordinates for dialogs
	# 1 - some number; see docs
	# 2 - horizontal offset
	# 3 - vertical offset
	# 4 - box width
	# 5 - box height

	${NSD_CreateText} 0 13u 100% -13u
	pop $dS_StatusBox

	# this always comes last
	nsDialogs::Show

	Call CreateShortcuts

	FailBail:
		push $0
		Call ErrorExit
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
# we do the actual call to CreateShortCut here, after we check that the file
# the shortcut will be pointing to exitsts first
FunctionEnd

Function CreateShortcuts
# open the INI file
# loop over it's contents
ReadINIStr $0 "C:\temp\shortcuts.ini" demosection testentry
#${NSD_SetText} $dS_StatusBox $0
MessageBox MB_OK $0
FunctionEnd

Function ParseShortcutINIFile
# $SMPROGRAMS is usually the Programs menu under the Start button
# 1:link.lnk 2:target.exe 3:parameters 4:icon_file 5:icon_index_number
# 6:start_options 7:keyboard_shortcut 8:description
${NSD_SetText} $dS_StatusBox $status_text
FunctionEnd # ParseShortcutINIfile

# vim: filetype=nsis paste

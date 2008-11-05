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
var dialog_output
var ini_counter

# 1:link.lnk 2:target.exe 3:parameters 4:icon_file 5:icon_index_number
# 6:start_options 7:keyboard_shortcut 8:description
var directory
var link
var target
var params
var iconfile
var iconidx
var startopts
var magickeys
var description

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

	# $SMPROGRAMS is usually the Programs menu under the Start button
	# 1:link.lnk 2:target.exe 3:parameters 4:icon_file 5:icon_index_number
	# 6:start_options 7:keyboard_shortcut 8:description
	
	# open the INI file
	# loop over it's contents; start at 1, section0 is the template in the ini
	# file
	

	StrCpy $dialog_output "The following shortcuts were created:"
	StrCpy $ini_counter "1"

	# loop through the ini file and create shortcuts based on the list of files
	# contained in that file
	ReadINI:
	ClearErrors
	#StrCpy $ini_section "link-${ini_counter}"
	ReadINIStr $directory ${SHORTCUT_INI} $ini_counter directory

	ReadINIStr $link ${SHORTCUT_INI} $ini_counter link
	ReadINIStr $target ${SHORTCUT_INI} $ini_counter target
	ReadINIStr $params ${SHORTCUT_INI} $ini_counter params
	ReadINIStr $iconfile ${SHORTCUT_INI} $ini_counter iconfile
	ReadINIStr $iconidx ${SHORTCUT_INI} $ini_counter iconidx
	ReadINIStr $startopts ${SHORTCUT_INI} $ini_counter startopts
	ReadINIStr $magickeys ${SHORTCUT_INI} $ini_counter magickeys
	ReadINIStr $description ${SHORTCUT_INI} $ini_counter description
	IfErrors ShowDialog 0
	# check if the target file exists
	IfFileExists "$target" 0 ReadINI
	# yep, create the directory for the shortcut
	IfFileExists "$SMPROGRAMS\$directory\*.*" +2
	CreateDirectory "$SMPROGRAMS\$directory"
	# then create the shortcut in that directory
	CreateShortcut "$SMPROGRAMS\$directory\$link" "$target" "$params" \
		"$iconfile" $iconidx "" "" "$description"
	#StrCpy $dialog_output "Shortcut for ini_section"
	StrCpy $dialog_output "$dialog_output$\r$\n$ini_counter: $link -> $target"
	StrCpy $dialog_output "$dialog_output$\r$\nIcon: $iconfile : $iconidx"
	# increment the counter
	IntOp $ini_counter $ini_counter + 1
	Goto ReadINI
	StrCpy $dialog_output "$dialog_output$\r$\nini counter is $ini_counter"

	# this always comes last
	ShowDialog:
	${NSD_SetText} $dS_StatusBox $dialog_output
	nsDialogs::Show

#	Call CreateShortcuts

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
# - check that the file that the shortcut will point to exists; if not, exit
# - check that the directory exists; if not, create it
# - check that the shortcut file exists; if not, create it
FunctionEnd



# vim: filetype=nsis paste

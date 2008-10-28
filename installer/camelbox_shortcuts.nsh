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
var dialog_StartPage
var dialog_SP_LogoImgBox
var dialog_SP_LogoImg
var dialog_SP_ReleaseImgBox
var dialog_SP_ReleaseNameImg
var dialog_SP_Headline
var dialog_SP_Text
#var Headline_Font

# custom page for displaying the welcome banner and logo
Function StartPage
	# every time you use a nsDialogs macro, you need to pop the return value
	# off of the stack; sometimes you can save and reuse this value (it's a
	# reference to a dialog window for example)
	nsDialogs::Create /NOUNLOAD 1018
	Pop $dialog_StartPage
	StrCmp $0 "error" FailBail 0

	# coordinates for dialogs
	# 1 - some number; see docs
	# 2 - horizontal offset
	# 3 - vertical offset
	# 4 - box width
	# 5 - box height

	# logo image
	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_BITMAP} 0 5 0 140u 140u ""
	Pop $dialog_SP_LogoImgBox

	StrCpy $0 ${INSTALLER_BASE}\Icons\camelbox-logo.bmp
	System::Call 'user32::LoadImage(i 0, t r0, i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_LOADFROMFILE}) i.s'
	Pop $dialog_SP_LogoImg
	
	SendMessage $dialog_SP_LogoImgBox ${STM_SETIMAGE} ${IMAGE_BITMAP} \
		$dialog_SP_LogoImg

	# release name image
	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_BITMAP} 0 5 -40u 140u 50u ""
	Pop $dialog_SP_ReleaseImgBox

	StrCpy $0 ${INSTALLER_BASE}\Icons\2008.1-odin.140x50.bmp
	System::Call 'user32::LoadImage(i 0, t r0, i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_LOADFROMFILE}) i.s'
	Pop $dialog_SP_ReleaseNameImg
	
	SendMessage $dialog_SP_ReleaseImgBox ${STM_SETIMAGE} ${IMAGE_BITMAP} \
		$dialog_SP_ReleaseNameImg

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 107u 2u -95u 18u "Welcome to Camelbox!"
	Pop $dialog_SP_Headline

	SendMessage $dialog_SP_Headline ${WM_SETFONT} $Headline_Font 0
	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 105u 20u -100u -5u "Camelbox: A complete build of Perl for 32-bit Windows that includes:$\r$\n$\r$\n* Core Gtk2-Perl modules (Gtk2, Glib, Cairo)$\r$\n* A working CPAN module$\r$\n* Bonus (!) Perl modules including DBI/DBD::[SQLite|mysql|Pg|ODBC] and friends$\r$\n* Extra binaries, utilities, development libraries/headers for compiling even more Perl modules from CPAN$\r$\n* Lots of Perl/GTK documenation in HTML format$\r$\n$\r$\nall neatly packaged and ready to install!$\r$\n$\r$\nMany thanks to Milo for the original NSI installer script!$\r$\n$\r$\nHit the Next button to continue."
	Pop $dialog_SP_Text

	SetCtlColors $dialog_StartPage "" 0xffffff
	SetCtlColors $dialog_SP_Headline "" 0xffffff
	SetCtlColors $dialog_SP_Text "" 0xffffff

	# this always comes last
	nsDialogs::Show

	System::Call gdi32::DeleteObject(i$dialog_SP_LogoImg)

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

Function CreateShortcuts
# $SMPROGRAMS is usually the Programs menu under the Start button
CreateDirectory "$SMPROGRAMS\Camelbox"
# 1:link.lnk 2:target.exe 3:parameters 4:icon_file 5:icon_index_number
# 6:start_options 7:keyboard_shortcut 8:description
CreateShortCut "$SMPROGRAMS\Camelbox\Camelbox Uninstall.lnk" \
	"$INSTDIR\camelbox_uninstall.exe" "" "$INSTDIR\uninstall.exe" 0 \
	"" "Uninstall Camelbox"
CreateShortCut "$SMPROGRAMS\Camelbox\CPAN Shell.lnk" \
	"$INSTDIR\cpan.bat" "" "$SYSDIR\shell32.dll" 163 \
	"" "CPAN Shell"

FunctionEnd

# vim: filetype=nsis paste

#==========================================================================
#
# TYPE:		NSIS header/include File
#
# NAME: 	camelbox_functions.nsh
#
# AUTHOR: 	$LastChangedBy$
# DATE: 	$LastChangedDate$
#
# COMMENT:	$Id$
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

#### GLOBAL VARIABLES ####
# what file we're going to download
var archivefile
# it's MD5 checksum
var archivemd5sum
# what the name of the section is, for use with the downloader/unpacker
var sectionname
# dialog label and name
var dialogURL
# the download URL
var DL_URL
# keep the archive files after downloading?
var dialogKeepDownloadedArchives
var dialogKeepDownloadedArchivesState
var keepDownloadedArchives
# did the demos get installed?
var demosInstalled
# open the Using Camelbox page after the install?
var openUsingCamelboxWebpage
# run the demo launcher?
var runDemoLauncher

# for the StartPage
var dialog_StartPage
var dialog_SP_LogoImgBox
var dialog_SP_LogoImg
var dialog_SP_ReleaseImgBox
var dialog_SP_ReleaseNameImg
var dialog_SP_Headline
var dialog_SP_Text
var Headline_Font

#### FUNCTIONS ####

Function .onInit
	StrCpy $demosInstalled "false"
	StrCpy $openUsingCamelboxWebpage "false"
	StrCpy $runDemoLauncher "false"
 
	# added from http://nsis.sourceforge.net/Allow_only_one_installer_instance
  	BringToFront
	; Check if already running
	; If so don't open another but bring to front
	System::Call "kernel32::CreateMutexA(i 0, i 0, t '$(^Name)') i .r0 ?e"
  	Pop $0
  	StrCmp $0 0 launch
  	StrLen $0 "$(^Name)"
  	IntOp $0 $0 + 1
  	loop:
  		FindWindow $1 '#32770' '' 0 $1
    	IntCmp $1 0 +4
    	System::Call "user32::GetWindowText(i r1, t .r2, i r0) i."
    	StrCmp $2 "$(^Name)" 0 loop
    	System::Call "user32::ShowWindow(i r1,i 9) i."
        ; If minimized then maximize
    	System::Call "user32::SetForegroundWindow(i r1) i."  ; Bring to front
	    Abort
  	launch:
	# for the StartPage below
	CreateFont $Headline_Font "$(^Font)" "14" "700"
FunctionEnd

Function ErrorExit
	# pop the error message off of the stack
	pop $0
	DetailPrint "Installer encountered the following fatal error:"
	abort "$0; Aborting..."
FunctionEnd

# custom page for displaying the welcome banner and logo
Function StartPage
	# every time you use a nsDialogs macro, you need to pop the return value
	# off of the stack; sometimes you can save and reuse this value (it's a
	# reference to a dialog window for example)
	nsDialogs::Create /NOUNLOAD 1018
	Pop $dialog_StartPage
	StrCmp $0 "error" FailBail 0

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

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 107u 2u -95u 20u "Welcome to Camelbox!"
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

# custom page for entering in a download URL
Function ChooseHTTPServer 
	# every time you use a nsDialogs macro, you need to pop the return value
	# off of the stack; sometimes you can save and reuse this value (it's a
	# reference to a dialog window for example)
	nsDialogs::Create /NOUNLOAD 1018
	Pop $0
	StrCmp $0 "error" FailBail 0

	${NSD_CreateLabel} 0 0 100% 13u \
		"Please enter the base URL to download files from:"
	pop $0

	${NSD_CreateText} 0 15u 100% 13u ${BASE_URL}
	pop $dialogURL

	${NSD_CreateLabel} 0 30u 100% 13u \
		"(Default URL is ${BASE_URL})"
	pop $0

	${NSD_CreateLabel} 0 45u 100% 13u \
		"You can specify a local/alternate mirror for the Camelbox files here."
	pop $0

	${NSD_CreateCheckBox} 0 60u 100% 13u \
		"Keep downloaded archive files after installer exits?"
	pop $dialogKeepDownloadedArchives

	# this always comes last
	nsDialogs::Show

	FailBail:
		push $0
		Call ErrorExit
FunctionEnd

# scrape the user's answer out of the text box
Function ChooseHTTPServerLeave
	${NSD_GetText} $dialogURL $0
	StrCpy $DL_URL $0
	
	# get the state of the control
	${NSD_GetState} $dialogKeepDownloadedArchives \
		$dialogKeepDownloadedArchivesState
	# compare it against the 'checked' macro
	StrCmp 	$dialogKeepDownloadedArchivesState ${BST_CHECKED} 0 +2
		# yep, it was checked, change it
		StrCpy $keepDownloadedArchives "true"
FunctionEnd

# parse the docs/shortcuts installer page and respond appropriately
Function ShortcutsAndReadme
	# create the dialog
	nsDialogs::Create /NOUNLOAD 1018
	Pop $0
	StrCmp $0 "error" FailBail 0

	${NSD_CreateCheckBox} 0 0 100% 13u \
		"Create a Camelbox Program Group in the Start Menu?"
	pop $openUsingCamelboxWebpage

	# indent these and make them dependent on the above checkbox being checked
	${NSD_CreateCheckBox} 0 0 100% 13u \
		"Create icons to Camelbox binaries and Demo Launcher?"
	pop $openUsingCamelboxWebpage

	${NSD_CreateCheckBox} 0 0 100% 13u \
		"Create icons to recommended tutorials on the Web?"
	pop $openUsingCamelboxWebpage

	${NSD_CreateCheckBox} 0 0 100% 13u \
	"Open the 'Using Camelbox' page in a web browser after install is complete?"
	pop $openUsingCamelboxWebpage

	# check to see if the demos were installed, exit if not
	StrCmp $demosInstalled "false" ShowDialog 0

	${NSD_CreateCheckBox} 0 15u 100% 13u \
		"Run the Camelbox Demo Launcher?"
	pop $runDemoLauncher

	${NSD_CreateCheckBox} 0 15u 100% 13u \
		"Create a shortcut on the Desktop for the Demo Launcher?"
	pop $runDemoLauncher
	# example of creating shortcuts for things
	# http://nsis.sourceforge.net/Many_Icons_Many_shortcuts

	#Goto ShowDialog
	ShowDialog:
		# this always comes last
		nsDialogs::Show

	FailBail:
		push $0
		Call ErrorExit
FunctionEnd # ShortcutsAndReadme

/*
# scrape the user's answer out of the text box
Function ShortcutsAndReadmeLeave
	${NSD_GetText} $dialogURL $0
	StrCpy $DL_URL $0
	
	# get the state of the control
	${NSD_GetState} $dialogKeepDownloadedArchives \
		$dialogKeepDownloadedArchivesState
	# compare it against the 'checked' macro
	StrCmp 	$dialogKeepDownloadedArchivesState ${BST_CHECKED} 0 +2
		# yep, it was checked, change it
		StrCpy $keepDownloadedArchives "true"
FunctionEnd # ShortcutsAndReadmeLeave
*/

# 'download and unpack' function thingy
Function SnarfUnpack
	# pop arguments off of the stack
	pop $sectionname
	pop $archivemd5sum
	pop $archivefile
    Snarf:
        DetailPrint "Downloading: $DL_URL/$archivefile"
    	### download
    	#inetc::get /POPUP "$sectionname" \
    	#	"$DL_URL/$archivefile" "$INSTDIR\$archivefile"
    	# return value = exit code, "OK" if OK
		#StrCmp $0 "OK" 0 FailBail # inetc::get
    	# return code for NSISdl should be 'success'
    	NSISdl::download "$DL_URL/$archivefile" "$INSTDIR\$archivefile"
    	Pop $0 
    	# check for an OK download; continues on success, bails on error
    	StrCmp $0 "success" 0 FailBail
    Checksum:
    	DetailPrint "Verifying $archivefile"
    	md5dll::GetMD5File "$INSTDIR\$archivefile"
    	Pop $0
        # compare the two MD5 checksums
    	StrCmp $0 $archivemd5sum 0 SnarfRetry
    	DetailPrint "MD5 sum matches!"
    Extract:
    	DetailPrint "Extracting $archivefile"
    	untgz::extract -zlzma "$INSTDIR\$archivefile"
    	DetailPrint "Unzip status: $R0"
    	#StrCmp $0 "OK" 0 FailBail
    	StrCmp $R0 "success" 0 FailBail
    	# don't delete archive files if the user asked to keep them
    	StrCmp $keepDownloadedArchives "true" +3 0
    	delete "$INSTDIR\$archivefile"
		IfErrors DeleteError 0
    	# if we've been successful, exit now
    	return
	# we should only hit these if called
    # all of the below labels either need to abort or call another label
	FailBail:
		# $0 should have already been set by the caller
		DetailPrint "Installer encountered a following fatal error;"
		abort "'$0'; Aborting..."
    SnarfRetry:
        # messageBox is section 4.9.4.15 of the docs
    	DetailPrint "MD5 sum does not match!"
		DetailPrint "Expected: $archivemd5sum"
		DetailPrint "Received: $0"
        messageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION|MB_TOPMOST \
            "Checksum of $archivefile failed...$\nRetry download?" \
			IDRETRY Snarf
        abort
	DeleteError:
		DetailPrint "Could not delete $archive file; aborting..."
		abort
FunctionEnd # SnarfUnpack

Function DebugPause
	MessageBox MB_OK "Pausing Installer for Debugging"
FunctionEnd

# vim: filetype=nsis paste

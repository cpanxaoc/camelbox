#==========================================================================
#
# TYPE:		NSIS header/include File
#
# NAME: 	camelbox_functions.nsh
#
# AUTHOR: 	$LastChangedBy: elspicyjack $
# DATE: 	$LastChangedDate: 2008-03-25 01:38:28 -0700 (Tue, 25 Mar 2008) $
#
# COMMENT:	$Id: multipackage_demo.nsi 47 2008-03-25 08:38:28Z elspicyjack $
#
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
FunctionEnd

Function ErrorExit
	# pop the error message off of the stack
	pop $0
	DetailPrint "Installer encountered the following fatal error:"
	abort "$0; Aborting..."
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
	# verify the download directory exists
    DetailPrint "Downloading: $DL_URL/$archivefile"
	### download
	#inetc::get /POPUP "$sectionname" \
	#	"$DL_URL/$archivefile" "$INSTDIR\$archivefile"
	NSISdl::download "$DL_URL/$archivefile" "$INSTDIR\$archivefile"
	Pop $0 
	# check for an OK download; continues on success, bails on error
	# return value = exit code, "OK" if OK
	#StrCmp $0 "OK" 0 FailBail # inetc::get
	# return code for NSISdl should be 'success'
	StrCmp $0 "success" 0 FailBail
	### checksum
	DetailPrint "Verifying $archivefile"
	md5dll::GetMD5File "$INSTDIR\$archivefile"
	Pop $0
	StrCmp $0 $archivemd5sum 0 FailBail
	DetailPrint "MD5 sum verified!"
	DetailPrint "$archivefile : $0"
	### extract files
	DetailPrint "Extracting $archivefile"
	untgz::extract -zlzma "$INSTDIR\$archivefile"
	DetailPrint "Unzip status: $R0"
	#StrCmp $0 "OK" 0 FailBail
	StrCmp $0 "OK" 0 FailBail
	# don't delete archive files if the user asked to keep them
	StrCmp $keepDownloadedArchives +3 0
	DetailPrint "Deleting: $INSTDIR\$archivefile"
	delete "$INSTDIR\$archivefile"
	# if we've been successful, exit now
	return
	# we should only hit this if called
	FailBail:
		# $0 should have already been set by the caller
		DetailPrint "Installer encountered the following fatal error:"
		abort "'$0'; Aborting..."
FunctionEnd # SnarfUnpack

Function DebugPause
	MessageBox MB_OK "Pausing Installer for Debugging"
FunctionEnd

# vim: filetype=nsis paste

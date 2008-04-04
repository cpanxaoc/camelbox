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
# what the name of the section is, for use with the downloader/unpacker
var sectionname
# dialog label and name
var dialogURL
# the download URL
var DL_URL

#### FUNCTIONS ####

Function ChooseHTTPServer 
# custom page for entering in a download URL
	nsDialogs::Create /NOUNLOAD 1018
	Pop $0
	StrCmp $0 "error" FailBail 0

	${NSD_CreateLabel} 0 0 100% 13u \
		"Please enter the base URL to download files from:"
	pop $0

	${NSD_CreateText} 0 13u 100% 13u ${BASE_URL}
	pop $dialogURL

	${NSD_CreateLabel} 0 30u 100% 13u \
		"(Default URL is ${BASE_URL})"
	pop $0

	${NSD_CreateLabel} 0 45u 100% 13u \
		"You can specify a local/alternate mirror for the Camelbox files here."
	pop $0

	# this always comes last
	nsDialogs::Show
	FailBail:
		# $0 should have already been set by the caller
		DetailPrint "Installer encountered the following fatal error:"
		abort "$0; Aborting..."
FunctionEnd

Function ChooseHTTPServerLeave
# scrape the user's answer out of the text box
	${NSD_GetText} $dialogURL $0
	StrCpy $DL_URL $0
FunctionEnd

# 'download and unpack' function thingy
Function SnarfUnpack
	# pop arguments off of the stack
	pop $sectionname
	pop $archivefile
	# verify the download directory exists
    DetailPrint "Downloading: $DL_URL/$archivefile"
	# do the download;
	# return value = exit code, "OK" if OK
	inetc::get /POPUP "$sectionname" \
		"$DL_URL/$archivefile" "$INSTDIR\$archivefile"
	Pop $0 
	# check for an OK download; continues on success, bails on error
	StrCmp $0 "OK" 0 FailBail
	DetailPrint "Extracting $archivefile"
	untgz::extract -zlzma "$INSTDIR\$archivefile"
	DetailPrint "Unzip status: $R0"
	StrCmp $0 "OK" 0 FailBail
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

#==========================================================================
#
# TYPE:		NSIS Installer Source File
#
# NAME: 	multipackage_demo.nsi
#
# AUTHOR: 	$LastChangedBy$
# DATE: 	$LastChangedDate$
#
# COMMENT:	$Id$
#
# The NSIS manual is located at http://nsis.sourceforge.net/Docs.  Parameters 
# used below should have the appropriate section number from the NSIS manual 
# listed somewhere nearby in the comments.
#
# Simple tutorials: http://nsis.sourceforge.net/Simple_tutorials
#==========================================================================

# external function scripts
!include "AddToPath.nsh"

# Section 5.4.1 of the NSIS manual describes !define
# The strftime strings are here:
# http://msdn2.microsoft.com/en-us/library/fe06s4ak.aspx
!define /utcdate RELEASE_VERSION  "%Y.%j.%H%MZ"

# define some macros for use later on
!define CAPTION_TEXT "multipackage_demo ${RELEASE_VERSION}"
!define CAMELBOX_SOURCE "C:\temp\multipackage_demo"
!define LICENSE_FILE ".\License\License.txt"
!define MAIN_ICON ".\Icons\camelbox-logo.ico"

# compiler flags
SetCompressor /SOLID lzma 			# 4.8.2.4
SetDatablockOptimize ON				# 4.8.2.6

# set up the installer attributes
AutoCloseWindow FALSE				# 4.8.1.3
CRCCheck ON 						# 4.8.1.12
InstallColors /WINDOWS				# 4.8.1.20
ShowInstDetails SHOW				# 4.8.1.34
SilentInstall NORMAL				# 4.8.1.36

# now set up the installer dialog box, from top top bottom 4.8.1.18
Icon "${MAIN_ICON}"
# caption for this dialog, shown in titlebar 4.8.1.7
Caption "${CAPTION_TEXT}"
# shown at the bottom of this dialog 4.8.1.6
BrandingText "Thanks to Milo for the installer!"
# name of this project 4.8.1.30
Name "${CAPTION_TEXT}"

LicenseText "${CAPTION_TEXT}" 		# 4.8.1.28
LicenseData "${LICENSE_FILE}" 		# 4.8.1.26
OutFile "C:\temp\multipackage_demo_${RELEASE_VERSION}.exe"	# 4.8.1.31
#InstallDir "C:\temp\multipackage_demo_${RELEASE_VERSION}_out" 	# 4.8.1.21
InstallDir $DESKTOP\demo

Page License
Page Components
Page Directory
Page InstFiles
#UninstPage Confirm
#UninstPage InstFiles

# TODO
# - after the installer runs, prompt the user to run a demo?

Section "Toplevel"
	SetOutPath $INSTDIR
	File ${CAMELBOX_SOURCE}\toplevel.txt
	writeUninstaller uninstaller.exe
SectionEnd

Section "Dir1"
	SetOutPath $INSTDIR\dir1
	File ${CAMELBOX_SOURCE}\dir1\file1.txt
SectionEnd

Section "Dir2"
	SetOutPath $INSTDIR\dir2
	File ${CAMELBOX_SOURCE}\dir2\file2.txt
SectionEnd

Section "Dir3"
	SetOutPath $INSTDIR\dir3
	File ${CAMELBOX_SOURCE}\dir3\file3.txt
SectionEnd

SectionGroup /e "Environment Variables"
	# FIXME check here first to verify $INSTDIR hasn't already been added to
	# the path environment variable
	Section "Add binaries to PATH variable"
		#StrCpy $1 "$INSTDIR\bin\"
		StrCpy $1 "$INSTDIR"
		Push $1
		Call AddToPath
	SectionEnd
SectionGroupEnd

Section "Uninstall"
	# FIXME remove the environment variables set above as well
	# delete the uninstaller first
	delete $INSTDIR\uninstaller.exe
	# then delete the other files/directories
	RMDir /r $INSTDIR\dir1
	RMDir /r $INSTDIR\dir2
	RMDir /r $INSTDIR\dir3
	delete $INSTDIR\toplevel.txt
	RMDir $INSTDIR
SectionEnd # Uninstall

# vim: filetype=nsis

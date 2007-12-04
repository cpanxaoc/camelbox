;==========================================================================
;
; TYPE:		NSIS Installer Source File
;
; NAME: 	multipackage_demo.nsi
;
; AUTHOR: 	$LastChangedBy$
; DATE: 	$LastChangedDate$
;
; COMMENT:	$Id$
;
;==========================================================================

!include "AddToPath.nsh"

!define RELEASE_VERSION  "2007.337.1"

; define some variables for use later on
!define CAPTION_TEXT "multipackage_demo ${VERSION}"
!define CAMELBOX_SOURCE "C:\temp\multipackage_demo"
!define MAIN_ICON ".\Icons\camelbox.ico"
!define LICENSE_FILE ".\License\License.txt"

; compiler flags
SetCompressor /SOLID lzma
SetDatablockOptimize ON

; set up the installer attributes
AutoCloseWindow FALSE
CRCCheck ON
InstallColors /WINDOWS
ShowInstDetails SHOW
SilentInstall NORMAL

; now set up the installer dialog box, from top top bottom
Icon "${MAIN_ICON}"
# caption for this dialog, shown in titlebar
Caption "${CAPTION_TEXT}"
# shown at the bottom of this dialog
BrandingText "Thanks to Milo for the installer!"
# name of this project
Name "${CAPTION_TEXT}"

LicenseText "${CAPTION_TEXT}"
LicenseData "${LICENSE_FILE}"
OutFile ".\multipackage_demo_${VERSION}.exe"
InstallDir "C:\Perl"

Page License
Page Components
page Directory
Page InstFiles
;UninstPage Confirm
;UninstPage InstFiles

; TODO
; - after the installer runs, prompt the user to run a demo?

Section "Camelbox"
SetOutPath $INSTDIR
File /r "${CAMELBOX_SOURCE}\.cpan"
File /r "${CAMELBOX_SOURCE}\${PERL_VERSION}"
File /r "${CAMELBOX_SOURCE}\site"
File "..\builds\Oct2007\readme-camelbox.txt"
SectionEnd

SectionGroup /e "Environment Variables"
	Section "Update system path"
	StrCpy $1 "$INSTDIR\${PERL_VERSION}\bin\"
	Push $1
	Call AddToPath
	SectionEnd
SectionGroupEnd

Section "Examples"
SetOutPath $INSTDIR
File /r "${CAMELBOX_SOURCE}\examples"
SectionEnd
; vim: filetype=nsis

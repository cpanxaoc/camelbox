;==========================================================================
;
; TYPE:		NSIS Installer Source File
;
; NAME: 	CamelboxBuilder.nsi
;
; AUTHOR: 	
; DATE: 	14/Nov/2007
;
; COMMENT:	
;
;==========================================================================

SetCompressor /SOLID lzma

!include "AddToPath.nsh"

!define VERSION  "2007.323.1-beta"

; define some variables for use later on
!define PERL_VERSION "5.8.8"
!define CAPTION_TEXT "Camelbox ${VERSION}"
!define CAMELBOX_SOURCE "C:\perl"
#!define MAIN_ICON ".\Icons\<ADD YOUR ICON HERE OR COMMENT OUT>"
!define LICENSE_FILE ".\License\License.txt"

; set up the installer attributes
BrandingText "Thanks to Milo for the installer!"
ShowInstDetails SHOW
SilentInstall NORMAL
InstallColors /WINDOWS
CRCCheck ON
SetDatablockOptimize ON
AutoCloseWindow FALSE
Name "${CAPTION_TEXT}"
Caption "${CAPTION_TEXT}"
LicenseText "${CAPTION_TEXT}"
LicenseData "${LICENSE_FILE}"
outfile ".\Camelbox_${VERSION}.exe"
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

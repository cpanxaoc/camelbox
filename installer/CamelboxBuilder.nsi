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

!define VERSION  "2007.317.1-gutted-beta"

!define PERL_VERSION "5.8.8"

!define CAPTION_TEXT "Camelbox ${VERSION}"
!define CAMELBOX_SOURCE ".\camelbox_src"
#!define MAIN_ICON ".\Icons\<ADD YOUR ICON HERE OR COMMENT OUT>"
!define LICENSE_FILE ".\License\License.txt"

BrandingText "http://code.google.com/p/camelbox/"
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


Section "Camelbox"
SetOutPath $INSTDIR
File /r "${CAMELBOX_SOURCE}\${PERL_VERSION}"
File /r "${CAMELBOX_SOURCE}\site"
File "${CAMELBOX_SOURCE}\readme-camelbox.txt"
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
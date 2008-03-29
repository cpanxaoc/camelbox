#==========================================================================
#
# TYPE:		NSIS Installer Source File
#
# NAME: 	camelbox.nsi
#
# AUTHOR: 	$LastChangedBy: elspicyjack $
# DATE: 	$LastChangedDate: 2008-03-25 01:38:28 -0700 (Tue, 25 Mar 2008) $
#
# COMMENT:	$Id: multipackage_demo.nsi 47 2008-03-25 08:38:28Z elspicyjack $
#
# The NSIS manual is located at http://nsis.sourceforge.net/Docs.  Parameters 
# used below should have the appropriate section number from the NSIS manual 
# listed somewhere nearby in the comments.
#
# Simple tutorials: http://nsis.sourceforge.net/Simple_tutorials
# 
# For support with this file, please visit the Camelbox mailing list at
# 	http://groups.google.com/group/camelbox
#==========================================================================

# TODO 
# - check the %PATH% first to verify $INSTDIR hasn't already been added to it
# - the installer adds the Camelbox distro to the user's path; maybe make
# it a choice to add it systemwide instead?
# - once you are able to get the distro to install in the directory chosen by
# the user, you'll have to find some way to save the uninstall path, meaning 
# the path that needs to be removed
# - find some way to store a filelist externally, a list of files and variable
# names, which can be plugged into the script at the right times (below)

#### EXTERNAL FUNCTION SCRIPTS ####
!include "AddToPath.nsh"

#### DEFINES ####
# Section 5.4.1 of the NSIS manual describes !define
# The strftime strings are here:
# http://msdn2.microsoft.com/en-us/library/fe06s4ak.aspx
!define /utcdate RELEASE_VERSION  "%Y.%j.%H%MZ"

# define some macros for use later on
!define CAPTION_TEXT "Camelbox ${RELEASE_VERSION}"
!define INSTALLER_BASE "C:\temp\camelbox-svn\installer"
!define LICENSE_FILE "${INSTALLER_BASE}\License\License.txt"
!define MAIN_ICON "${INSTALLER_BASE}\Icons\camelbox-logo.ico"
#!define BASE_URL "http://camelbox.googlecode.com/files"
#!define BASE_URL "http://devilduck.qualcomm.com/camelbox"
!define BASE_URL "http://files.antlinux.com/win/apps/gtk-archives"
!define INSTALL_PATH "C:\camelbox"

#### NSIS OPTIONS ####
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
OutFile "C:\temp\camelbox_${RELEASE_VERSION}-way_fucking_alpha.exe"	# 4.8.1.31
#InstallDir "C:\temp\multipackage_demo_${RELEASE_VERSION}_out" 	# 4.8.1.21
#InstallDir $DESKTOP\demo
InstallDir "${INSTALL_PATH}"

#### PAGES ####
Page License
Page Components
# TODO unless you can figure out how to change the Perl paths during the
# install, you need to not give the user the option on where to install
# Camelbox; if they put it someplace funky, it will not work
#Page Directory
Page InstFiles
#UninstPage Confirm
#UninstPage InstFiles

#### GLOBAL VARIABLES ####
# what file we're going to download
var archivefile
# what the name of the section is, for use with the downloader/unpacker
var sectionname

#### FUNCTIONS ####
# 'download and unpack' function thingy
Function SnarfUnpack
	# pop arguments off of the stack
	pop $sectionname
	pop $archivefile
    DetailPrint "Downloading: ${BASE_URL}/$archivefile"
	# do the download;
	# return value = exit code, "OK" if OK
	inetc::get /POPUP "$sectionname" \
		"${BASE_URL}/$archivefile" "$INSTDIR\$archivefile"
	Pop $0 
	# check for an OK download; continues on success, bails on error
	StrCmp $0 "OK" 0 FailBail
	DetailPrint "Extracting $archivefile"
	untgz::extract -zlzma "$INSTDIR\$archivefile"
	#untgz::extract -zbz2 "$INSTDIR\$archivefile"
	DetailPrint "Unzip status: $R0"
	StrCmp $0 "OK" 0 FailBail
	delete "$INSTDIR\$archivefile"
	# if we've been successful, exit now
	return
	# we should only hit this if called
	FailBail:
		# $0 should have already been set by the caller
		DetailPrint "Installer encountered the following fatal error:"
		abort "$0; Aborting..."
FunctionEnd # SnarfUnpack

Function DebugPause
	MessageBox MB_OK "Pausing Installer for Debugging"
FunctionEnd

#### SECTIONS ####

Section "-WriteUninstaller"
	SetOutPath "$INSTDIR"
	CreateDirectory "$INSTDIR\bin"
	writeUninstaller "$INSTDIR\camelbox_uninstaller.exe"
	writeUninstaller "$INSTDIR\bin\uninstaller.exe"
SectionEnd # WriteUninstaller

; /e in any SectionGroup header means "expanded by default"
/*
Section "Perl 5.10.0 Base Package" perlbase_id
	AddSize 8000 # kilobytes
	#push "perl-5.10.0.2008.087.1.tar.lzma"
	#push "perl-5.10.0.2008.087.1.tar.lzma"
	push "perl-5.10.0.2008.087.1.tar.bz2"
	SectionGetText ${perlbase_id} $0
	push $0
	Call SnarfUnpack
SectionEnd # "Perl 5.10.0 Base Package"
*/
Section "dmake Makefile Processor" dmake_id
	AddSize 70 # kilobytes
	push "dmake.2008.089.1.tar.lzma"
	#push "dmake.2008.087.1.tar.bz2"
	SectionGetText ${dmake_id} $0
	push $0
	Call SnarfUnpack
SectionEnd
Section "dmake Makefile Processor (extra files)" dmake-extra_id
	AddSize 103 # kilobytes
	push "dmake-extra.2008.089.1.tar.lzma"
	#push "dmake-extra.2008.087.1.tar.bz2"
	SectionGetText ${dmake-extra_id} $0
	push $0
	Call SnarfUnpack
SectionEnd

/*
SectionGroup "Core Gtk2-Perl Packages"
	Section "Core GTK Binaries"
		push "gtk-core-bin.2008.087.1.tar.lzma"
	SectionEnd
	Section "imagelibs-bin (JPG/PNG/TIFF libraries)"
		push "imagelibs-bin.2008.087.1.tar.lzma"
	SectionEnd
	Section "gtk-support-bin (gettext/libintl/etc.)"
		push "gtk-support-bin.2008.087.1.tar.lzma"
	SectionEnd
SectionGroupEnd # "Core Gtk2-Perl Packages"

SectionGroup "Development Packages"
	Section "Minimal GNU for Windows (MinGW) Toolkit"
		push "mingw.2008.087.1.tar.lzma"
	SectionEnd
	Section "Core GTK Development Files"
		push "gtk-core-dev.2008.087.1.tar.lzma"
	SectionEnd
	Section "dmake Makefile Processor"
		push "dmake.2008.087.1.tar.lzma"
	SectionEnd
	Section "dmake Makefile Processor (extra files)"
		push "dmake-extra.2008.087.1.tar.lzma"
	SectionEnd
SectionGroupEnd # "Development Packages"

SectionGroup "Extra Tools Packages"
	Section "UnxUtilities for Windows"
		push "unxutils.2008.087.1.tar.lzma"
	SectionEnd
	Section "7zip Archiver (command line version)"
		push "7zip.2008.087.1.tar.lzma"
	SectionEnd
	Section "imagelibs Utilities"
		push "imagelibs-utils.2008.087.1.tar.lzma"
	SectionEnd
	Section "gettext Utilities"
		push "gettext-utils.2008.087.1.tar.lzma"
	SectionEnd
SectionGroupEnd # "Extra Tools Packages"

SectionGroup "Perl Modules"
	Section "Perl Gtk2-Perl Core Modules"
		push "perl-Gtk2-core.2008.088.1.tar.lzma"
	SectionEnd
	Section "Perl YAML Module"
		push "perl-YAML.2008.087.1.tar.lzma"
	SectionEnd
	Section "Perl LWP libwww-perl Module"
		push "perl-LWP.2008.087.1.tar.lzma"
	SectionEnd
SectionGroupEnd # "Perl Modules"

SectionGroup "Documentation and Examples"
	Section "Perl 5.10.0 HTML Documentation"
		push "perl-5-10.0-html_docs.2008.087.1.tar.lzma"
	SectionEnd
	Section "GTK C API HTML/SGML Documentation"
		push "gtk-core-doc.2008.087.1.tar.lzma"
	SectionEnd
	Section "Gtk2-Perl Examples"
		push "gtk2-perl_examples.2008.088.1.tar.lzma"
	SectionEnd
SectionGroupEnd ; "Demonstration Scripts"
*/

SectionGroup /e "Environment Variables"
	Section "Add Camelbox to PATH variable"
		StrCpy $1 "$INSTDIR\bin"
		Push $1
    	DetailPrint "Adding to %PATH%: $1"
		Call AddToPath
	SectionEnd
SectionGroupEnd ; "Environment Variables"

/*
SectionGroup /e "Run Demonstration Scripts"
	Section "perl_swiss_army_knife.pl"
	SectionEnd
	Section "gyroscope.pl"
	SectionEnd
	Section "Gtk2"
	SectionEnd
	Section "Gnome2::Canvas"
	SectionEnd
SectionGroupEnd ; "Demonstration Scripts"
*/

Section "Uninstall"
	StrCpy $1 "$INSTDIR\bin"
	Push $1
	DetailPrint "Removing from %PATH%: $1"
	Call un.RemoveFromPath

	DetailPrint "Removing ${INSTALL_PATH}"
	RMDir /r ${INSTALL_PATH}
	# delete the uninstaller first
	#DetailPrint "Removing installer files"
	#delete "$INSTDIR\bin\camelbox_uninstaller.exe"
	#delete "$INSTDIR\bin\uninstaller.exe"
	# then delete the other files/directories
SectionEnd # Uninstall

# vim: filetype=nsis paste

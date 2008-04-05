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
# - put the examples back into the -dev packages?  This would prevent the user
# from running demos that they don't have libraries for
# - the installer adds the Camelbox distro to the user's path; maybe make
# it a choice to add it systemwide instead?
# - unless you can figure out how to change the Perl paths during the
# install, you need to not give the user the option on where to install
# Camelbox; if they put it someplace funky, it will not work; it still may not
# work if the new path has spaces in it
# - once you are able to get the distro to install in the directory chosen by
# the user, you'll have to find some way to save the uninstall path, meaning 
# the path that needs to be removed
# - at the end of the install, offer the user the option of viewing the
# UsageInstructions wiki page on the web?
# - add a Camelbox folder to the Start menu, with Windows shortcuts to the zsh
# shell, all of the demos as run through wperl.exe, and maybe the docs and
# whatnot
# - maybe add a shortcut to zsh on the desktop/quicklaunch bar, if zsh is
# installed
# - a copy of perl shell for shits and giggles?

#### DEFINES ####
# Section 5.4.1 of the NSIS manual describes !define
# The strftime strings for this next !define are here:
# http://msdn2.microsoft.com/en-us/library/fe06s4ak.aspx
!define /utcdate RELEASE_VERSION  "%Y.%j.%H%MZ"

# define some macros for use later on
!define CAPTION_TEXT "Camelbox ${RELEASE_VERSION}"
!define INSTALLER_BASE "C:\temp\camelbox-svn\installer"
!define LICENSE_FILE "${INSTALLER_BASE}\License\License.txt"
!define MAIN_ICON "${INSTALLER_BASE}\Icons\camelbox-logo.ico"
!define BASE_URL "http://camelbox.googlecode.com/files"
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
OutFile "C:\temp\camelbox_${RELEASE_VERSION}-alpha.exe"	# 4.8.1.31
InstallDir "${INSTALL_PATH}"

#### EXTERNAL FUNCTION SCRIPTS ####
!include "AddToPath.nsh"
!include "nsDialogs.nsh"
!include "camelbox_functions.nsh"	# functions used by all scripts
#!include "camelbox_filelist.nsh"  	# the list of package archives

#### PAGES ####
Page License
Page custom ChooseHTTPServer ChooseHTTPServerLeave
Page Components
#Page Directory
Page InstFiles
#Page custom ShortcutsAndReadme
UninstPage uninstConfirm
UninstPage InstFiles

#### INSTALL TYPES ####

InstType "Full Install - The Whole Enchilada"			# 1
InstType "Perl Only"									# 2
InstType "Perl with Core GTK Binaries"					# 3
InstType "Perl with Core/Extra GTK Binaries"			# 4
InstType "Perl with Core/Extra Binaries/Dev"			# 5
InstType "Perl with Core GTK2 and Glade"				# 6
InstType "UnxUtils Only"								# 7
InstType "Extra Tools Only"								# 8
InstType "Perl with All Non-GTK Modules"				# 9
InstType "Vapourware"									# 10

#### SECTIONS ####

Section "-WriteUninstaller"
	SectionIn RO
	SetOutPath "$INSTDIR"
	CreateDirectory "$INSTDIR\bin"
	writeUninstaller "$INSTDIR\camelbox_uninstaller.exe"
	writeUninstaller "$INSTDIR\bin\camelbox_uninstaller.exe"
	DetailPrint "a little snooze...."
	sleep 500
SectionEnd # WriteUninstaller

; /e in any SectionGroup header means "expanded by default"
Section "Perl 5.10.0 Base Package" perl-core_id
	SectionIn 1 2 3 4 5 6 9
	AddSize 7700 # kilobytes
	push "perl-5.10.0.2008.089.1.tar.lzma"
	SectionGetText ${perl-core_id} $0
	push $0
	Call SnarfUnpack
SectionEnd # "Perl 5.10.0 Base Package"

SectionGroup "Core Gtk2-Perl Packages"
	Section "Core GTK Binaries" gtk-core-bin_id
		AddSize 4700 # kilobytes
		SectionIn 1 3 4 5 6
		push "gtk-core-bin.2008.094.1.tar.lzma"
		SectionGetText ${gtk-core-bin_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "imagelibs-bin (JPG/PNG/TIFF libraries)" imagelibs-bin_id
		SectionIn 1 3 4 5 6
		AddSize 240 # kilobytes
		push "imagelibs-bin.2008.089.1.tar.lzma"
		SectionGetText ${imagelibs-bin_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "gtk-support-bin (gettext/libintl/etc.)" gtk-support-bin_id
		SectionIn 1 3 4 5 6
		AddSize 551 # kilobytes
		push "gtk-support-bin.2008.094.1.tar.lzma"
		SectionGetText ${gtk-support-bin_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Gtk2-Perl Core Modules (Cairo/Glib/Gtk2)" perl-gtk2_id
		SectionIn 1 3 4 5 6
		AddSize 768 # kilobytes
		push "perl-gtk2.2008.XXX.1.tar.lzma"
		SectionGetText ${perl-gtk2_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Core Gtk2-Perl Packages"

SectionGroup "Extra Gtk2-Perl Packages"
	Section "libglade-bin (Glade/XML libraries)" libglade-bin_id
		AddSize 404 # kilobytes
		SectionIn 1 4 5 6
		push "libglade-bin.2008.094.1.tar.lzma"
		SectionGetText ${libglade-bin_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Gtk2::GladeXML (Perl Glade/XML libraries)" perl-gtk2-gladexml_id
		AddSize 404 # kilobytes
		#SectionIn 1 4 5 6
		SectionIn 10
		push "perl-gtk2-gladexml.2008.094.1.tar.lzma"
		SectionGetText ${perl-gtk2-gladexml_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "libgnomecanvas-bin (Gnome Canvas libs.)" libgnomecanvas-bin_id
		AddSize 642 # kilobytes
		SectionIn 1 4 5
		push "libgnomecanvas-bin.2008.094.1.tar.lzma"
		SectionGetText ${libgnomecanvas-bin_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Gnome2::Canvas (Perl Gnome Canvas libs.)" perl-gnome2-canvas_id
		AddSize 642 # kilobytes
		#SectionIn 1 4 5
		SectionIn 10
		push "perl-gnome2-canvas.2008.094.1.tar.lzma"
		SectionGetText ${perl-gnome2-canvas_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Extra Gtk2-Perl Packages"

SectionGroup "Development Packages"
	Section "Minimal GNU for Windows (MinGW) Toolkit" mingw_id
		SectionIn 1 5
		AddSize 7500 # kilobytes
		push "mingw.2008.089.1.tar.lzma"
		SectionGetText ${mingw_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Core GTK Development Files" gtk-core-dev_id 
		SectionIn 1 5
		AddSize 784 # kilobytes
		push "gtk-core-dev.2008.094.1.tar.lzma"
		SectionGetText ${gtk-core-dev_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "imagelibs-dev (JPG/PNG/TIFF Headers)" imagelibs-dev_id 
		SectionIn 1 5
		AddSize 316 # kilobytes
		push "imagelibs-dev.2008.089.1.tar.lzma"
		SectionGetText ${imagelibs-dev_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "dmake Makefile Processor" dmake_id
		SectionIn 1 5
		AddSize 70 # kilobytes
		push "dmake.2008.089.1.tar.lzma"
		SectionGetText ${dmake_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "libglade-dev (Glade headers)" libglade-dev_id
		AddSize 795 # kilobytes
		SectionIn 1 5
		push "libglade-dev.2008.094.1.tar.lzma"
		SectionGetText ${libglade-dev_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "libgnomecanvas-dev (Gnome Canvas headers)" libgnomecanvas-dev_id
		AddSize 64 # kilobytes
		SectionIn 1 5
		push "libgnomecanvas-dev.2008.094.1.tar.lzma"
		SectionGetText ${libgnomecanvas-dev_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Development Packages"

SectionGroup "Extra Tools Packages"
	Section "Glade GUI Builder Tool" glade-win32_id
		SectionIn 1 6 8
		AddSize 316 # kilobytes
		push "glade-win32.2008.094.1.tar.lzma"
		SectionGetText ${glade-win32_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "UnxUtilities for Windows" unxutils_id
		SectionIn 1 7 8
		AddSize 2000 # kilobytes
		push "unxutils.2008.089.1.tar.lzma"
		SectionGetText ${unxutils_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
#	Section "7zip Archiver (command line version)" 7zip_id
#		SectionIn 1 8
#		AddSize 312 # kilobytes
#		push "7zip.2008.089.1.tar.lzma"
#		SectionGetText ${7zip_id} $0
#		push $0
#		Call SnarfUnpack
#	SectionEnd
	Section "LZMA Archiver (command line version)" lzma_id
		SectionIn 1 8
		AddSize 43 # kilobytes
		push "lzma.2008.089.1.tar.lzma"
		SectionGetText ${lzma_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "imagelibs Utilities" imagelibs-utils_id
		SectionIn 1 8
		AddSize 276 # kilobytes
		push "imagelibs-utils.2008.089.1.tar.lzma"
		SectionGetText ${imagelibs-utils_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "gettext Utilities" gettext-utils_id
		SectionIn 1 8
		AddSize 1300 # kilobytes
		push "gettext-utils.2008.089.1.tar.lzma"
		SectionGetText ${gettext-utils_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "dmake Makefile Processor (extra files)" dmake-extra_id
		SectionIn 1 8
		AddSize 104 # kilobytes
		push "dmake-extra.2008.089.1.tar.lzma"
		SectionGetText ${dmake-extra_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Extra Tools Packages"

SectionGroup "Perl Modules"
	Section "YAML - Yet Another Markup Language" perl-YAML_id
		SectionIn 1 9
		AddSize 32 # kilobytes
		push "perl-YAML.2008.089.1.tar.lzma"
		SectionGetText ${perl-YAML_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "LWP/libwww-perl" perl-LWP_id
		SectionIn 1 9
		AddSize 204 # kilobytes
		push "perl-LWP.2008.089.1.tar.lzma"
		SectionGetText ${perl-LWP_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
/*
	Section "Moose: a Post-Modern Object Framework" perl-moose_id
		SectionIn 1 9
		AddSize  # kilobytes
		push "perl-moose.2008.089.1.tar.lzma"
		SectionGetText ${perl-moose_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
*/
SectionGroupEnd # "Perl Modules"

SectionGroup "Documentation and Examples"
	Section "Perl 5.10.0 HTML Documentation" perl-html_docs_id
		SectionIn 1
		AddSize 2300 # kilobytes
		push "perl-5.10.0-html_docs.2008.089.1.tar.lzma"
		SectionGetText ${perl-html_docs_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "GTK C API HTML/SGML Documentation" gtk-core-doc_id
		SectionIn 1
		AddSize 2200 # kilobytes
		push "gtk-core-doc.2008.094.1.tar.lzma"
		SectionGetText ${gtk-core-doc_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Gtk2-Perl Examples" gtk2-perl-examples_id
		SectionIn 1
		AddSize 184 # kilobytes
		push "gtk2-perl-examples.2008.089.1.tar.lzma"
		SectionGetText ${gtk2-perl-examples_id} $0
		push $0
		Call SnarfUnpack
		# set the flag that tells the installer to show 
		# the demos installer page
		StrCpy $demosInstalled "true"
	SectionEnd
SectionGroupEnd # "Documentation and Examples"

SectionGroup /e "Environment Variables"
	Section "Add Camelbox to PATH variable"
		SectionIn 1 2 3 4 5 6 7 8 9
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
	SectionIn RO
	# delete the uninstaller first
	DetailPrint "Removing installer files"
	delete "${INSTALL_PATH}\bin\camelbox_uninstaller.exe"
	delete "${INSTALL_PATH}\camelbox_uninstaller.exe"
	# remove the binpath
	StrCpy $1 "${INSTALL_PATH}\bin"
	Push $1
	DetailPrint "Removing from %PATH%: $1"
	Call un.RemoveFromPath
	# then delete the other files/directories
	DetailPrint "Removing ${INSTALL_PATH}"
	RMDir /r ${INSTALL_PATH}
SectionEnd # Uninstall

# blank subsection
#	Section "some-package (extra notes, etc.)"
#		AddSize  # kilobytes
#		push "package-name.YYYY.JJJ.V.tar.lzma"
#		SectionGetText ${some-package_id} $0
#		push $0
#		Call SnarfUnpack
#	SectionEnd

# vim: filetype=nsis paste


#==========================================================================
#
# TYPE:		NSIS Installer Source File
#
# NAME: 	camelbox.nsi
#
# AUTHOR: 	$LastChangedBy: elspicyjack $
# DATE: 	$LastChangedDate: 2008-07-30 09:39:57 -0700 (Wed, 30 Jul 2008) $
#
# COMMENT:	$Id: camelbox_builder.nsi 406 2008-07-30 16:39:57Z elspicyjack $
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
# - the byte sizes shown in AddSize are the archive file sizes, not the
# unpacked archive sizes; this is really what should be shown

#### DEFINES ####
# Section 5.4.1 of the NSIS manual describes !define
# The strftime strings for this next !define are here:
# http://msdn2.microsoft.com/en-us/library/fe06s4ak.aspx
!define /utcdate RELEASE_VERSION  "%Y.%j.%H%MZ-odin"

# define some macros for use later on
!define CAPTION_TEXT "Camelbox ${RELEASE_VERSION}"
!define INSTALLER_BASE "C:\temp\camelbox-svn\installer"
!define LICENSE_FILE "${INSTALLER_BASE}\License\License.txt"
!define MAIN_ICON "${INSTALLER_BASE}\Icons\camelbox-logo.ico"
!define BASE_URL "http://camelbox.googlecode.com/files"
!define INSTALL_PATH "C:\camelbox"
!define SHORTCUT_INI "${INSTALLER_BASE}\shortcuts.ini"
OutFile "C:\temp\camelbox_build_tester-${RELEASE_VERSION}.exe"	# 4.8.1.31

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
#BrandingText "http://code.google.com/p/camelbox/"
# name of this project 4.8.1.30
Name "${CAPTION_TEXT}"

LicenseBkColor /windows
LicenseText "${CAPTION_TEXT}" 		# 4.8.1.28
LicenseData "${LICENSE_FILE}" 		# 4.8.1.26

InstallDir "${INSTALL_PATH}"

#### EXTERNAL FUNCTION SCRIPTS ####
!include "nsDialogs.nsh"
!include "camelbox_functions.nsh"	# functions used by all scripts
!include "camelbox_shortcuts.nsh"	# functions used by all scripts

#### PAGES ####
#Page Directory
#Page custom ShortcutsAndReadme
Page custom ShortcutsDialog
#UninstPage uninstConfirm
#UninstPage RemoveShortcutsAndReadme

Section # dummy section to keep NSIS happy
SectionEnd

# vim: filetype=nsis paste

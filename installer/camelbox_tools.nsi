#==========================================================================
#
# TYPE:		NSIS Installer Source File
#
# NAME: 	camelbox_tools.nsi
#
# AUTHOR: 	$LastChangedBy: elspicyjack $
# DATE: 	$LastChangedDate: 2008-07-30 09:39:57 -0700 (Wed, 30 Jul 2008) $
#
# COMMENT:	$Id: camelbox_builder.nsi 406 2008-07-30 16:39:57Z elspicyjack $
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

#### DEFINES ####
# Section 5.4.1 of the NSIS manual describes !define
# The strftime strings for this next !define are here:
# http://msdn2.microsoft.com/en-us/library/fe06s4ak.aspx
!define /utcdate RELEASE_VERSION  "%Y.%j.%H%MZ"

# define some macros for use later on
!define CAPTION_TEXT "Camelbox Developer Tools ${RELEASE_VERSION}"
!define INSTALLER_BASE "C:\temp\camelbox-svn\installer"
!define LICENSE_FILE "${INSTALLER_BASE}\License\Devtools-License.txt"
!define MAIN_ICON "${INSTALLER_BASE}\Icons\camelbox-logo.ico"

OutFile "C:\temp\camelbox-devtools-${RELEASE_VERSION}.exe"	# 4.8.1.31

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
#BrandingText "Thanks to Milo for the installer!"
BrandingText "http://code.google.com/p/camelbox/"
# name of this project 4.8.1.30
Name "${CAPTION_TEXT}"

LicenseBkColor /windows
LicenseText "${CAPTION_TEXT}" 		# 4.8.1.28
LicenseData "${LICENSE_FILE}" 		# 4.8.1.26

InstallDir "${INSTALL_PATH}"

#### EXTERNAL FUNCTION SCRIPTS ####
!include "AddToPath.nsh"
!include "nsDialogs.nsh"
!include "camelbox_functions.nsh"	# functions used by all scripts

#### PAGES ####
Page custom StartPage
Page License
Page Components
Page Directory
Page InstFiles

#### SECTIONS ####

Section "Dependency Walker" dependency-walker_id
    AddSize 32426
    push "http://www.dependencywalker.com/depends22_x86.zip"
    push "4cbb6c16b8f83db4295f4fbeec13c5f5"
    SectionGetText ${perl-5.10.0-core_id} $0
    push $0
    Call SnarfUnpack
SectionEnd ; perl-5.10.0-core

# http://www.cosmin.com/iconviewer/iconviewer.exe
# http://download.sysinternals.com/Files/ListDlls.zip
# http://download.sysinternals.com/Files/ProcessExplorer.zip
# http://www.sliksoftware.co.nz/download/odbcv310.exe
# http://www.sqldbatips.com/samples/code/SQL2005SCM/SQL2005_Service_Manager.zip
# MinGW
# MSYS (Compiling Postgres)
# UnxUtilities
# Putty
# WinSCP
# Winroll
# TortoiseSVN
# lzma
# dmake
# gvim
# IrfanView
# getif (networking)
# NSIS 
# - unzip plugin
# - md5sum plugin
# Database libraries
# - MySQL client and libraries
# - PostgreSQL source
# - SQLite client
# - ODBCviewer
# - DB2 Server
# - Oracle Instant Client

Section "Uninstall"
    SectionIn RO
    # delete the uninstaller first
    DetailPrint "Removing installer files"
    #delete "${INSTALL_PATH}\bin\camelbox_uninstaller.exe"
    delete "${INSTALL_PATH}\camelbox_tools_uninstaller.exe"
    # remove the binpath
    StrCpy $1 "${INSTALL_PATH}\bin"
    Push $1
    DetailPrint "Removing from %PATH%: $1"
    Call un.RemoveFromPath
    # then delete the other files/directories
    DetailPrint "Removing ${INSTALL_PATH}"
    RMDir /r ${INSTALL_PATH}
SectionEnd ; Uninstall

# blank subsection
#   Section "some-package (extra notes, etc.)"
#       AddSize  # kilobytes
#       push "package-name.YYYY.JJJ.V.tar.lzma"
#       SectionGetText ${some-package_id} $0
#       push $0
#       Call SnarfUnpack
#   SectionEnd

# vim: filetype=nsis paste


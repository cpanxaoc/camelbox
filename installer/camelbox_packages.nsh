#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/nsh_builder.pl)
# DATE:     2008.191.0839Z 
#
# COMMENT:  automatically generated file; edit at your own risk

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

#### SECTIONS ####

Section "-WriteUninstaller"
    SectionIn RO
    SetOutPath "$INSTDIR"
    CreateDirectory "$INSTDIR\bin"
    writeUninstaller "$INSTDIR\camelbox_uninstaller.exe"
    #writeUninstaller "$INSTDIR\bin\camelbox_uninstaller.exe"
SectionEnd ; WriteUninstaller 

Section "Perl 5.10.0 Base Package" perl-5.10.0-core_id
    SectionIn 1 2 3 4 5 6 9
    AddSize 83824
    push "perl-5.10.0-core.2008.101.2.tar.lzma"
    push "6b462551236bbb3130e79cedfe5fa595"
    SectionGetText ${perl-5.10.0-core_id} $0
    push $0
    Call SnarfUnpack
SectionEnd ; perl-5.10.0-core

SectionGroup "Core Gtk2-Perl Packages"
    Section "Core GTK Binaries" gtk-core-bin_id
        SectionIn 1 3 4 5 6
        AddSize 27394
        push "gtk-core-bin.2008.094.1.tar.lzma"
        push "77ea8cce0e787f2a2156ad705631f001"
        SectionGetText ${gtk-core-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-bin
    Section "imagelibs-bin (JPG/PNG/TIFF libraries)" imagelibs-bin_id
        SectionIn 1 3 4 5 6
        AddSize 713
        push "imagelibs-bin.2008.089.1.tar.lzma"
        push "85f5cfef32281603bf3a28c060d5205b"
        SectionGetText ${imagelibs-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-bin
    Section "gtk-support-bin (gettext/libintl/etc.)" gtk-support-bin_id
        SectionIn 1 3 4 5 6
        AddSize 1217
        push "gtk-support-bin.2008.102.1.tar.lzma"
        push "5dd497b8af08e4a02d510ce5381c34f9"
        SectionGetText ${gtk-support-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-support-bin
    Section "Gtk2-Perl Core Modules (Cairo/Glib/Gtk2)" perl-gtk2-core_id
        SectionIn 1 3 4 5 6
        AddSize 7363
        push "perl-gtk2-core.2008.101.2.tar.lzma"
        push "78b491d9877e1e24b59abeaf4e0b00c7"
        SectionGetText ${perl-gtk2-core_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-gtk2-core
SectionGroupEnd ; Core Gtk2-Perl Packages

SectionGroup "Extra Gtk2-Perl Packages"
    Section "libglade-bin (Glade/XML libraries)" libglade-bin_id
        SectionIn 1 4 5 6
        AddSize 1067
        push "libglade-bin.2008.094.1.tar.lzma"
        push "482ad3a1cb50197f806e28fc8be880c5"
        SectionGetText ${libglade-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libglade-bin
    Section "Gtk2::GladeXML (Perl Glade/XML libraries)" perl-gtk2-gladexml_id
        SectionIn 1 4 5 6
        AddSize 50
        push "perl-gtk2-gladexml.2008.101.1.tar.lzma"
        push "ce49e3ee25523a5cd0972d8ed7018ddb"
        SectionGetText ${perl-gtk2-gladexml_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-gtk2-gladexml
    Section "libgnomecanvas-bin (Gnome Canvas libs.)" libgnomecanvas-bin_id
        SectionIn 1 4 5
        AddSize 2403
        push "libgnomecanvas-bin.2008.094.1.tar.lzma"
        push "e20d08eb1bdca4545b1518a030b4ca68"
        SectionGetText ${libgnomecanvas-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgnomecanvas-bin
    Section "Gnome2::Canvas (Perl GnomeCanvas libs.)" perl-gnome2-canvas_id
        SectionIn 1 4 5
        AddSize 290
        push "perl-gnome2-canvas.2008.101.1.tar.lzma"
        push "62d502a49ec9001e15a5f431ba3dc9b2"
        SectionGetText ${perl-gnome2-canvas_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-gnome2-canvas
SectionGroupEnd ; Extra Gtk2-Perl Packages

SectionGroup /e "Gtk2-Perl Applications"
    Section "Asciio v0.95_01 - ASCII Art Editor" perl-app-asciio-0.95_01_id
        SectionIn 1 3 4 5 6
        AddSize 14979
        push "perl-app-asciio-0.95_01.2008.119.2.tar.lzma"
        push "98b31c3126e301851efd6ec76f8355a6"
        SectionGetText ${perl-app-asciio-0.95_01_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-app-asciio-0.95_01
SectionGroupEnd ; Gtk2-Perl Applications

SectionGroup "Extra Perl Modules"
    Section "YAML - Yet Another Markup Language" perl-YAML_id
        SectionIn 1 9
        AddSize 207
        push "perl-YAML.2008.101.1.tar.lzma"
        push "295adb7b6ec97550ed886cb410b3cc22"
        SectionGetText ${perl-YAML_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-YAML
    Section "LWP/libwww-perl" perl-LWP_id
        SectionIn 1 9
        AddSize 1741
        push "perl-LWP.2008.101.1.tar.lzma"
        push "14bc48a5a50161b6fb3625aec72e9a93"
        SectionGetText ${perl-LWP_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-LWP
    Section "Moose: a Post-Modern Object Framework for Perl" perl-Moose_id
        SectionIn 1 9
        AddSize 3159
        push "perl-Moose.2008.101.2.tar.lzma"
        push "890d6441c589dc078796e0f53c37595e"
        SectionGetText ${perl-Moose_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Moose
    Section "PAR: Perl Archive Toolkit" perl-PAR_id
        SectionIn 1 9
        AddSize 2715
        push "perl-PAR.2008.101.1.tar.lzma"
        push "4b19e29de4ef380b7bca78849b6a1ad9"
        SectionGetText ${perl-PAR_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-PAR
    Section "PAR::Packer: The PAR Packer (creator) Toolkit" perl-PAR-Packer_id
        SectionIn 1 9
        AddSize 12364
        push "perl-PAR-Packer.2008.101.1.tar.lzma"
        push "544400fa4089df66fbcdd867844ff029"
        SectionGetText ${perl-PAR-Packer_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-PAR-Packer
    Section "Log::Log4perl: A Perl clone of log4j (but better)" perl-Log-Log4perl_id
        SectionIn 1 9 11 12
        AddSize 1578
        push "perl-Log-Log4perl.2008.191.1.tar.lzma"
        push "8baa8d5ac50902b110566b08b97a6d9c"
        SectionGetText ${perl-Log-Log4perl_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Log-Log4perl
    Section "Date::Format: Date formatting subroutines" perl-TimeDate_id
        SectionIn 1 9 11 12
        AddSize 145
        push "perl-TimeDate.2008.191.1.tar.lzma"
        push "185c8cfc68cd006270164a0314dfbe8c"
        SectionGetText ${perl-TimeDate_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-TimeDate
    Section "JSON: Javascript data serialization/storage" perl-JSON_id
        SectionIn 1 9 11 12
        AddSize 196
        push "perl-JSON.2008.191.1.tar.lzma"
        push "26e732601e927d4b1db9ad8968210b79"
        SectionGetText ${perl-JSON_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-JSON
SectionGroupEnd ; Extra Perl Modules

SectionGroup "Perl Database Support"
    Section "DBI - Database Independent Interface" perl-DBI_id
        SectionIn 1 9 11 12
        AddSize 2988
        push "perl-DBI.2008.191.1.tar.lzma"
        push "b15371585d8f4337a3900ccb87c9f797"
        SectionGetText ${perl-DBI_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBI
    Section "DBD::ODBC - ODBC Driver for Perl DBI" perl-DBD-ODBC_id
        SectionIn 1 9 11 12
        AddSize 879
        push "perl-DBD-ODBC.2008.191.1.tar.lzma"
        push "d5c64340c9cf5121ff5b17585f32069e"
        SectionGetText ${perl-DBD-ODBC_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-ODBC
    Section "DBD::SQLite - Pure Perl DBD driver for SQLite" perl-DBD-SQLite_id
        SectionIn 1 9 11 12
        AddSize 1752
        push "perl-DBD-SQLite.2008.191.1.tar.lzma"
        push "7c32c1c68088b0f361ad2f7b76ad12d5"
        SectionGetText ${perl-DBD-SQLite_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-SQLite
    Section "DBD::mysql - DBD driver for MySQL" perl-DBD-mysql_id
        SectionIn 1 9 11 12
        AddSize 8530
        push "perl-DBD-mysql.2008.191.1.tar.lzma"
        push "67daab411d433e10bc8b322bed9fca09"
        SectionGetText ${perl-DBD-mysql_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-mysql
SectionGroupEnd ; Perl Database Support

SectionGroup "Development Packages"
    Section "Minimal GNU for Windows (MinGW) Toolkit" mingw_id
        SectionIn 1 5
        AddSize 68931
        push "mingw.2008.089.1.tar.lzma"
        push "0795c0c443332abe46cf1b2f68d7bcc1"
        SectionGetText ${mingw_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mingw
    Section "dmake Makefile Processor" dmake_id
        SectionIn 1 5
        AddSize 182
        push "dmake.2008.101.1.tar.lzma"
        push "ab3d7c982a41ebe2bba4a85e17433c49"
        SectionGetText ${dmake_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; dmake
    Section "Core GTK Development Files" gtk-core-dev_id
        SectionIn 1 5
        AddSize 10268
        push "gtk-core-dev.2008.094.1.tar.lzma"
        push "f0aa89b410a41b3e7270f2b7865fcfa7"
        SectionGetText ${gtk-core-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-dev
    Section "gtk-support-dev (gettext/libintl/etc.)" gtk-support-dev_id
        SectionIn 1 5
        AddSize 281
        push "gtk-support-dev.2008.094.1.tar.lzma"
        push "91d9ed8b8244153664107a1129e6f51b"
        SectionGetText ${gtk-support-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-support-dev
    Section "imagelibs-dev (JPG/PNG/TIFF Headers)" imagelibs-dev_id
        SectionIn 1 5
        AddSize 2444
        push "imagelibs-dev.2008.089.1.tar.lzma"
        push "2e3e88f50a2e16800c17b2c4ee1c20db"
        SectionGetText ${imagelibs-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-dev
    Section "libglade-dev (Glade Headers)" libglade-dev_id
        SectionIn 1 5
        AddSize 5299
        push "libglade-dev.2008.094.1.tar.lzma"
        push "ce8aee7858971fc4fd061ceea3d2993b"
        SectionGetText ${libglade-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libglade-dev
    Section "libgnomecanvas-dev (GnomeCanvas Headers)" libgnomecanvas-dev_id
        SectionIn 1 5
        AddSize 3457
        push "libgnomecanvas-dev.2008.101.1.tar.lzma"
        push "ccf9ddf174982e197bcf1297e109425f"
        SectionGetText ${libgnomecanvas-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgnomecanvas-dev
SectionGroupEnd ; Development Packages

SectionGroup "Extra Tools Packages"
    Section "Glade GUI Builder Tool" glade-win32_id
        SectionIn 1 6 8
        AddSize 1483
        push "glade-win32.2008.094.1.tar.lzma"
        push "c88400e449cc2013a647250e17126d11"
        SectionGetText ${glade-win32_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; glade-win32
    Section "UnxUtilities for Windows" unxutils_id
        SectionIn 1 7 8
        AddSize 6576
        push "unxutils.2008.089.1.tar.lzma"
        push "6eaaef43e2f6a2fcc3cea598aaeb05f4"
        SectionGetText ${unxutils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; unxutils
    Section "LZMA Compression Utility" lzma_id
        SectionIn 1 8
        AddSize 101
        push "lzma.2008.089.1.tar.lzma"
        push "1bfd95a2da57f3d1ba4d6c38d8a32a11"
        SectionGetText ${lzma_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; lzma
    Section "imagelibs Utilities" imagelibs-utils_id
        SectionIn 1 8
        AddSize 1459
        push "imagelibs-utils.2008.089.1.tar.lzma"
        push "7cd5163e98048e3ab06cadcd7fa1ed5c"
        SectionGetText ${imagelibs-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-utils
    Section "gettext Utilities" gettext-utils_id
        SectionIn 1 8
        AddSize 6702
        push "gettext-utils.2008.089.1.tar.lzma"
        push "f28b6d1e1bd3089e8629de9d2af57ea6"
        SectionGetText ${gettext-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gettext-utils
    Section "dmake Makefile Processor (extra files)" dmake-extra_id
        SectionIn 1 8
        AddSize 604
        push "dmake-extra.2008.101.1.tar.lzma"
        push "45ac9ef33e85e4b0b9f98c99587adab0"
        SectionGetText ${dmake-extra_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; dmake-extra
SectionGroupEnd ; Extra Tools Packages

SectionGroup "Documentation and Examples"
    Section "Perl 5.10.0 HTML Documentation" perl-5.10.0-html_docs_id
        SectionIn 1
        AddSize 62047
        push "perl-5.10.0-html_docs.2008.101.1.tar.lzma"
        push "d0b32636a66ebf931f9bf0f2ec972e9e"
        SectionGetText ${perl-5.10.0-html_docs_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-5.10.0-html_docs
    Section "GTK C API HTML/SGML Documentation" gtk-core-doc_id
        SectionIn 1
        AddSize 27220
        push "gtk-core-doc.2008.094.1.tar.lzma"
        push "9bdf8e7ff06f68faa3c659738a036c8f"
        SectionGetText ${gtk-core-doc_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-doc
    Section "Gtk2-Perl Example Scripts" perl-gtk2-examples_id
        SectionIn 1
        AddSize 653
        push "perl-gtk2-examples.2008.089.2.tar.lzma"
        push "4036ae2c5c51c7050ee08424b3d64250"
        SectionGetText ${perl-gtk2-examples_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-gtk2-examples
SectionGroupEnd ; Documentation and Examples

SectionGroup /e "Environment Variables"
    Section "Add Camelbox to PATH variable"
        SectionIn 1 2 3 4 5 6 7 8 9
        StrCpy $1 "$INSTDIR\bin"
        Push $1
        DetailPrint "Adding to %PATH%: $1"
        Call AddToPath
    SectionEnd
SectionGroupEnd ; "Environment Variables"

Section "Uninstall"
    SectionIn RO
    # delete the uninstaller first
    DetailPrint "Removing installer files"
    #delete "${INSTALL_PATH}\bin\camelbox_uninstaller.exe"
    delete "${INSTALL_PATH}\camelbox_uninstaller.exe"
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


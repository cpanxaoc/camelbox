#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/nsh_builder.pl)
# DATE:     2008.213.0146Z 
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
    SectionIn 1 2 3 4 5 6 7
    AddSize 32426
    push "perl-5.10.0-core.2008.201.1.tar.lzma"
    push "4cbb6c16b8f83db4295f4fbeec13c5f5"
    SectionGetText ${perl-5.10.0-core_id} $0
    push $0
    Call SnarfUnpack
SectionEnd ; perl-5.10.0-core

SectionGroup "Core Gtk2-Perl Packages"
    Section "Core GTK Binaries" gtk-core-bin_id
        SectionIn 1 2 3 4
        AddSize 27911
        push "gtk-core-bin.2008.208.1.tar.lzma"
        push "6e2a55b8bfe8c07dc2e5d14f76890099"
        SectionGetText ${gtk-core-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-bin
    Section "imagelibs-bin (JPG/PNG/TIFF libraries)" imagelibs-bin_id
        SectionIn 1 2 3 4
        AddSize 691
        push "imagelibs-bin.2008.201.1.tar.lzma"
        push "24f2381ea0dda1bc31e4e2dcc47daae7"
        SectionGetText ${imagelibs-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-bin
    Section "gtk-support-bin (gettext/libintl/etc.)" gtk-support-bin_id
        SectionIn 1 2 3 4
        AddSize 1217
        push "gtk-support-bin.2008.201.1.tar.lzma"
        push "19fc736d86cf6b53eceaaa223f98f61f"
        SectionGetText ${gtk-support-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-support-bin
    Section "Gtk2-Perl Core Modules (Cairo/Glib/Gtk2)" perl-Gtk2-core_id
        SectionIn 1 2 3 4
        AddSize 3449
        push "perl-Gtk2-core.2008.210.1.tar.lzma"
        push "c68c068baddbb9e3e9f3296b65870fe5"
        SectionGetText ${perl-Gtk2-core_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-core
SectionGroupEnd ; Core Gtk2-Perl Packages

SectionGroup "Extra Gtk2-Perl Packages"
    Section "libglade-bin (Glade/XML libraries)" libglade-bin_id
        SectionIn 2 3 4
        AddSize 1134
        push "libglade-bin.2008.201.1.tar.lzma"
        push "0d3c6dba16dcbdb25740de877c81b4bc"
        SectionGetText ${libglade-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libglade-bin
    Section "Gtk2::GladeXML (Perl Glade/XML libraries)" perl-Gtk2-GladeXML_id
        SectionIn 2 3 4
        AddSize 29
        push "perl-Gtk2-GladeXML.2008.210.1.tar.lzma"
        push "d54b65a6289fa781fe772f74eaa36aa4"
        SectionGetText ${perl-Gtk2-GladeXML_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-GladeXML
    Section "libgnomecanvas-bin (Gnome Canvas libs.)" libgnomecanvas-bin_id
        SectionIn 2 3 4
        AddSize 2330
        push "libgnomecanvas-bin.2008.210.1.tar.lzma"
        push "74f9dc1a03da99bde1f9f69f5f9372d1"
        SectionGetText ${libgnomecanvas-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgnomecanvas-bin
    Section "Gnome2::Canvas (Perl GnomeCanvas libs.)" perl-Gnome2-Canvas_id
        SectionIn 2 3 4
        AddSize 90
        push "perl-Gnome2-Canvas.2008.210.1.tar.lzma"
        push "5d3182a0ef3d7e21960db16ef43bb01a"
        SectionGetText ${perl-Gnome2-Canvas_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gnome2-Canvas
SectionGroupEnd ; Extra Gtk2-Perl Packages

SectionGroup /e "Gtk2-Perl Applications"
    Section "Asciio v0.95_01 - ASCII Art Editor" perl-App-Asciio_id
        SectionIn 2 3 4
        AddSize 6396
        push "perl-App-Asciio.2008.211.1.tar.lzma"
        push "3df16b1eee57e7ae26ba56931a6ce3bf"
        SectionGetText ${perl-App-Asciio_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-App-Asciio
    Section "Gtk2::Ex::PodViewer - a GTK Perl POD viewer" perl-Gtk2-Ex-PodViewer_id
        SectionIn 2 3 4
        AddSize 207
        push "perl-Gtk2-Ex-PodViewer.2008.211.1.tar.lzma"
        push "934f2404eb38cf768ebfa7d3b6b30146"
        SectionGetText ${perl-Gtk2-Ex-PodViewer_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-Ex-PodViewer
SectionGroupEnd ; Gtk2-Perl Applications

SectionGroup "Extra Perl Modules"
    Section "CPAN Metadata files" perl-5.10.0-CPAN_Metadata_id
        SectionIn 2 3 4 6
        AddSize 11143
        push "perl-5.10.0-CPAN_Metadata.2008.201.1.tar.lzma"
        push "dd0eb2af3d198829809a92a62c07e000"
        SectionGetText ${perl-5.10.0-CPAN_Metadata_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-5.10.0-CPAN_Metadata
    Section "XML::Parser - XML document parsing in Perl" perl-XML-Parser_id
        SectionIn 2 3 4 6
        AddSize 394
        push "perl-XML-Parser.2008.210.1.tar.lzma"
        push "04217bcb1d6e41f8b34ada2a22da1711"
        SectionGetText ${perl-XML-Parser_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-XML-Parser
    Section "YAML - Yet Another Markup Language" perl-YAML_id
        SectionIn 1 2 3 4 6
        AddSize 124
        push "perl-YAML.2008.201.1.tar.lzma"
        push "fba1c34abb03d4deaf432457e6b48833"
        SectionGetText ${perl-YAML_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-YAML
    Section "LWP/libwww-perl" perl-LWP_id
        SectionIn 1 2 3 4 6
        AddSize 920
        push "perl-LWP.2008.201.1.tar.lzma"
        push "b853e137d57a0312c41c4cc25013a11c"
        SectionGetText ${perl-LWP_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-LWP
    Section "Moose: a Post-Modern Object Framework for Perl" perl-Moose_id
        SectionIn 2 3 4 6
        AddSize 774
        push "perl-Moose.2008.210.1.tar.lzma"
        push "7bb3a44c01a64ca89dc0536b049a266a"
        SectionGetText ${perl-Moose_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Moose
    Section "PAR: Perl Archive Toolkit" perl-PAR_id
        SectionIn 2 3 4 6
        AddSize 285
        push "perl-PAR.2008.210.1.tar.lzma"
        push "b6c8a49f453ae597d9570111a87d06a2"
        SectionGetText ${perl-PAR_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-PAR
    Section "PAR::Packer: The PAR Packer (creator) Toolkit" perl-PAR-Packer_id
        SectionIn 2 3 4 6
        AddSize 5993
        push "perl-PAR-Packer.2008.210.1.tar.lzma"
        push "c5cfb8761537bc28b0080d5ecc14a4fc"
        SectionGetText ${perl-PAR-Packer_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-PAR-Packer
    Section "Log::Log4perl: A Perl clone of log4j (but better)" perl-Log-Log4perl_id
        SectionIn 2 3 4 6
        AddSize 497
        push "perl-Log-Log4perl.2008.210.1.tar.lzma"
        push "183acebe078d610a869e732b3afa2958"
        SectionGetText ${perl-Log-Log4perl_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Log-Log4perl
    Section "Date::Format: Date formatting subroutines" perl-TimeDate_id
        SectionIn 2 3 4 6
        AddSize 58
        push "perl-TimeDate.2008.210.1.tar.lzma"
        push "c82dacf6208d9cc05e86d3de91740edd"
        SectionGetText ${perl-TimeDate_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-TimeDate
    Section "JSON: Javascript data serialization/storage" perl-JSON_id
        SectionIn 2 3 4 6
        AddSize 128
        push "perl-JSON.2008.210.1.tar.lzma"
        push "aba1ed6affdfcb5213d1f152c52b67d0"
        SectionGetText ${perl-JSON_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-JSON
    Section "Win32::API and Win32::ODBC Modules" perl-Win32-API-ODBC_id
        SectionIn 2 3 4 6
        AddSize 276
        push "perl-Win32-API-ODBC.2008.210.1.tar.lzma"
        push "85a7457a836a2ef06e6546cb65ef16fb"
        SectionGetText ${perl-Win32-API-ODBC_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Win32-API-ODBC
SectionGroupEnd ; Extra Perl Modules

SectionGroup "Perl Database Support"
    Section "DBI - Database Independent Interface" perl-DBI_id
        SectionIn 1 2 3 4 7
        AddSize 1430
        push "perl-DBI.2008.210.1.tar.lzma"
        push "fe5a4f23cd5b8e7f4aa6f60e8dc0697d"
        SectionGetText ${perl-DBI_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBI
    Section "DBD::ODBC - ODBC Driver for Perl DBI" perl-DBD-ODBC_id
        SectionIn 1 2 3 4 7
        AddSize 194
        push "perl-DBD-ODBC.2008.210.1.tar.lzma"
        push "d63df1a4dfd955c970682f6d8165c46a"
        SectionGetText ${perl-DBD-ODBC_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-ODBC
    Section "DBD::SQLite - Pure Perl DBD driver for SQLite" perl-DBD-SQLite_id
        SectionIn 1 2 3 4 7
        AddSize 444
        push "perl-DBD-SQLite.2008.210.1.tar.lzma"
        push "aa2c6e3f955bd870830d9982d97356e3"
        SectionGetText ${perl-DBD-SQLite_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-SQLite
    Section "DBD::mysql - DBD driver for MySQL" perl-DBD-mysql_id
        SectionIn 1 2 3 4 7
        AddSize 191
        push "perl-DBD-mysql.2008.210.1.tar.lzma"
        push "f140bee9c6ce6c8d2c4383611af4c950"
        SectionGetText ${perl-DBD-mysql_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-mysql
SectionGroupEnd ; Perl Database Support

SectionGroup "Development Packages"
    Section "Minimal GNU for Windows (MinGW) Toolkit" mingw_id
        SectionIn 3 4
        AddSize 68942
        push "mingw.2008.199.2.tar.lzma"
        push "6649745d60153b63e80499a1426e40b9"
        SectionGetText ${mingw_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mingw
    Section "dmake Makefile Processor" dmake_id
        SectionIn 3 4
        AddSize 180
        push "dmake.2008.199.1.tar.lzma"
        push "dbb5052b2cf47e82c86e4007dafda6cf"
        SectionGetText ${dmake_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; dmake
    Section "Core GTK Development Files" gtk-core-dev_id
        SectionIn 3 4
        AddSize 10498
        push "gtk-core-dev.2008.208.1.tar.lzma"
        push "67956c9839943b4e458a1b1884f1ffd4"
        SectionGetText ${gtk-core-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-dev
    Section "gtk-support-dev (gettext/libintl/etc.)" gtk-support-dev_id
        SectionIn 3 4
        AddSize 281
        push "gtk-support-dev.2008.201.1.tar.lzma"
        push "80e7fce1adf88325b3219233c63ce575"
        SectionGetText ${gtk-support-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-support-dev
    Section "imagelibs-dev (JPG/PNG/TIFF Headers)" imagelibs-dev_id
        SectionIn 3 4
        AddSize 949
        push "imagelibs-dev.2008.201.1.tar.lzma"
        push "66bf3c8a22e491f933f24fab01a0d283"
        SectionGetText ${imagelibs-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-dev
    Section "libglade-dev (Glade Headers)" libglade-dev_id
        SectionIn 3 4
        AddSize 5301
        push "libglade-dev.2008.201.1.tar.lzma"
        push "030869df92ac7e65632af6085caef644"
        SectionGetText ${libglade-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libglade-dev
    Section "libgnomecanvas-dev (GnomeCanvas Headers)" libgnomecanvas-dev_id
        SectionIn 3 4
        AddSize 3493
        push "libgnomecanvas-dev.2008.210.1.tar.lzma"
        push "1df8fc3f83fb3d4c1c65c60ebafba2bc"
        SectionGetText ${libgnomecanvas-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgnomecanvas-dev
    Section "Expat XML Parser Development Files" expat-dev_id
        SectionIn 3 4
        AddSize 1262
        push "expat-dev.2008.202.1.tar.lzma"
        push "245f173c0fbb4d432610648d2beb9c99"
        SectionGetText ${expat-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; expat-dev
SectionGroupEnd ; Development Packages

SectionGroup "Database Tools Packages"
    Section "MySQL Client Library (libmysql.dll)" mysql-bin_id
        SectionIn 1 2 3 4 7
        AddSize 2934
        push "mysql-bin.2008.201.1.tar.lzma"
        push "2ddf252468ed43e84cd4477a1227094c"
        SectionGetText ${mysql-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-bin
    Section "MySQL Client Binary (mysql.exe)" mysql-client_id
        SectionIn 2 3 4 7
        AddSize 2052
        push "mysql-client.2008.201.1.tar.lzma"
        push "eaebde6b5df87ca4cc7a3ec72d8c3ac0"
        SectionGetText ${mysql-client_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-client
    Section "MySQL Debugging Binaries" mysql-debug_id
        SectionIn 4
        AddSize 50731
        push "mysql-debug.2008.201.1.tar.lzma"
        push "23647396525c17f466b835c939f1425c"
        SectionGetText ${mysql-debug_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-debug
    Section "MySQL Devel. (headers and import libs)" mysql-dev_id
        SectionIn 3 4
        AddSize 9957
        push "mysql-dev.2008.201.1.tar.lzma"
        push "3f8aad2e3e5b7e43d1f91c2360540f22"
        SectionGetText ${mysql-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-dev
    Section "MySQL Documentation in .CHM format" mysql-docs_id
        SectionIn 3 4
        AddSize 7726
        push "mysql-docs.2008.201.1.tar.lzma"
        push "b87cb1403c4fb25f37a8ad7fa7c22ab5"
        SectionGetText ${mysql-docs_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-docs
    Section "MySQL Server Binaries" mysql-server_id
        SectionIn 4
        AddSize 57406
        push "mysql-server.2008.201.1.tar.lzma"
        push "20d1bc2579affeb55a2597084a6c4ef8"
        SectionGetText ${mysql-server_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-server
    Section "SQLite Database Utilities" sqlite-utils_id
        SectionIn 2 3 4 7
        AddSize 1714
        push "sqlite-utils.2008.212.1.tar.lzma"
        push "fcf2f8f8a9e16e7bcbc9e0af712e2aac"
        SectionGetText ${sqlite-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; sqlite-utils
SectionGroupEnd ; Database Tools Packages

SectionGroup "Extra Tools Packages"
    Section "Glade XML GUI Builder Tool" gladewin32-bin_id
        SectionIn 2 3 4
        AddSize 3341
        push "gladewin32-bin.2008.202.1.tar.lzma"
        push "80d4c455ca4a95ab5bd258c801dd4ba4"
        SectionGetText ${gladewin32-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gladewin32-bin
    Section "UnxUtilities for Windows" unxutils_id
        SectionIn 2 3 4
        AddSize 6639
        push "unxutils.2008.199.1.tar.lzma"
        push "550afa49e2b74e82f2ecacfe08fae9a4"
        SectionGetText ${unxutils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; unxutils
    Section "LZMA Compression Utility" lzma_id
        SectionIn 2 3 4
        AddSize 97
        push "lzma.2008.201.1.tar.lzma"
        push "fa29ce787b56a4e9d5a1a7985174d6b8"
        SectionGetText ${lzma_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; lzma
    Section "Expat XML Parsing Library" expat-bin_id
        SectionIn 2 3 4 6
        AddSize 303
        push "expat-bin.2008.202.1.tar.lzma"
        push "1f906389bf651c86c92168485be40b51"
        SectionGetText ${expat-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; expat-bin
SectionGroupEnd ; Extra Tools Packages

SectionGroup "Bloatware Packages"
    Section "Glade for Windows Development Files" gladewin32-dev_id
        SectionIn 3 4
        AddSize 617
        push "gladewin32-dev.2008.202.1.tar.lzma"
        push "4731ead2f4b09a8cf9eb01d52347c5da"
        SectionGetText ${gladewin32-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gladewin32-dev
    Section "imagelibs Utilities" imagelibs-utils_id
        SectionIn 4
        AddSize 1660
        push "imagelibs-utils.2008.201.1.tar.lzma"
        push "98dd73d7d8dff390609f88527f645be8"
        SectionGetText ${imagelibs-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-utils
    Section "gettext Utilities" gettext-utils_id
        SectionIn 4
        AddSize 6702
        push "gettext-utils.2008.089.1.tar.lzma"
        push "f28b6d1e1bd3089e8629de9d2af57ea6"
        SectionGetText ${gettext-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gettext-utils
    Section "dmake Makefile Processor (extra files)" dmake-extra_id
        SectionIn 4
        AddSize 606
        push "dmake-extra.2008.199.1.tar.lzma"
        push "32f3d240ea9874e3aca23d968487a760"
        SectionGetText ${dmake-extra_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; dmake-extra
SectionGroupEnd ; Bloatware Packages

SectionGroup "Documentation and Examples"
    Section "Perl 5.10.0 HTML Documentation" perl-5.10.0-html_docs_id
        SectionIn 3 4
        AddSize 17005
        push "perl-5.10.0-html_docs.2008.201.1.tar.lzma"
        push "97af28b58997b2a0a969f9fb8e88f3f8"
        SectionGetText ${perl-5.10.0-html_docs_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-5.10.0-html_docs
    Section "GTK C API HTML/SGML Documentation" gtk-core-doc_id
        SectionIn 3 4
        AddSize 27649
        push "gtk-core-doc.2008.208.1.tar.lzma"
        push "8df659f437dcfae0b0d869ec4331c8c2"
        SectionGetText ${gtk-core-doc_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-doc
    Section "Gtk2-Perl Example Scripts" perl-gtk2-examples_id
        SectionIn 3 4
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


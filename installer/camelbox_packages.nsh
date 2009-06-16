#==========================================================================
#
# TYPE:     NSIS header/include file
#
# AUTHOR:   nsh_builder.pl 
# (http://code.google.com/p/camelbox/source/browse/trunk/scripts/nsh_builder.pl)
# DATE:     2009.167.0804Z 
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
	CreateDirectory "$INSTDIR\share\pkglists"
	File "/oname=$INSTDIR\share\pkglists\_version_list.txt" ${VERSIONS_FILE}
SectionEnd ; WriteUninstaller 

Section "Perl 5.10.0 Base Package" perl-5.10.0-core_id
    SectionIn 1 2 3 4 5 6 7
    AddSize 31834
    push "perl-5.10.0-core.2009.126.1.tar.lzma"
    push "5183be26805688bc144f1d161bdcabb7"
    SectionGetText ${perl-5.10.0-core_id} $0
    push $0
    Call SnarfUnpack
SectionEnd ; perl-5.10.0-core

SectionGroup "Core Gtk2-Perl Packages"
    Section "Core GTK Binaries" gtk-core-bin_id
        SectionIn 1 2 3 4
        AddSize 31716
        push "gtk-core-bin.2009.113.1.tar.lzma"
        push "5700bb65defab60b3bfe023fb87a233a"
        SectionGetText ${gtk-core-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-bin
    Section "imagelibs-bin (JPG/PNG/TIFF libraries)" imagelibs-bin_id
        SectionIn 1 2 3 4
        AddSize 712
        push "imagelibs-bin.2009.113.1.tar.lzma"
        push "268fad4c97ab65adb4565051c98e0592"
        SectionGetText ${imagelibs-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-bin
    Section "gtk-support-bin (gettext/libintl/etc.)" gtk-support-bin_id
        SectionIn 1 2 3 4
        AddSize 1229
        push "gtk-support-bin.2009.113.1.tar.lzma"
        push "1ab84da177cd7d5648e27548d8144672"
        SectionGetText ${gtk-support-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-support-bin
    Section "Gtk2-Perl Core Modules (Cairo/Glib/Gtk2)" perl-Gtk2-core_id
        SectionIn 1 2 3 4
        AddSize 3700
        push "perl-Gtk2-core.2009.132.1.tar.lzma"
        push "017ea48a0f6abbcf9e7fa71514291657"
        SectionGetText ${perl-Gtk2-core_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-core
SectionGroupEnd ; Core Gtk2-Perl Packages

SectionGroup "Extra Gtk2-Perl Packages"
    Section "libglade-bin (Glade/XML libraries)" libglade-bin_id
        SectionIn 2 3 4
        AddSize 1135
        push "libglade-bin.2009.113.1.tar.lzma"
        push "6a46e17d69bd1e5aaf09065b386d751c"
        SectionGetText ${libglade-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libglade-bin
    Section "Gtk2::GladeXML (Perl Glade/XML libraries)" perl-Gtk2-GladeXML_id
        SectionIn 2 3 4
        AddSize 28
        push "perl-Gtk2-GladeXML.2009.132.1.tar.lzma"
        push "d5d16c7f1843d7d5a06f17313b296cc6"
        SectionGetText ${perl-Gtk2-GladeXML_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-GladeXML
    Section "libgnomecanvas-bin (Gnome Canvas libs.)" libgnomecanvas-bin_id
        SectionIn 2 3 4
        AddSize 1783
        push "libgnomecanvas-bin.2009.127.1.tar.lzma"
        push "bd47b4dd0e3c1bf304ba6c2a5d0a1b7f"
        SectionGetText ${libgnomecanvas-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgnomecanvas-bin
    Section "Gnome2::Canvas (Perl GnomeCanvas libs.)" perl-Gnome2-Canvas_id
        SectionIn 2 3 4
        AddSize 91
        push "perl-Gnome2-Canvas.2009.132.1.tar.lzma"
        push "f0ac9f12e8a93889e7f84e41b07adfdb"
        SectionGetText ${perl-Gnome2-Canvas_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gnome2-Canvas
    Section "libgoocanvas-bin (the GooCanvas libs.)" libgoocanvas-bin_id
        SectionIn 2 3 4
        AddSize 1096
        push "libgoocanvas-bin.2009.113.1.tar.lzma"
        push "ff77aa98fc3b262ed835425325f1f306"
        SectionGetText ${libgoocanvas-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgoocanvas-bin
    Section "Goo::Canvas (Perl GooCanvas libs.)" perl-Goo-Canvas_id
        SectionIn 2 3 4
        AddSize 322
        push "perl-Goo-Canvas.2009.138.1.tar.lzma"
        push "ecb76855956adac72dd876dcc76ca5a9"
        SectionGetText ${perl-Goo-Canvas_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Goo-Canvas
SectionGroupEnd ; Extra Gtk2-Perl Packages

SectionGroup /e "Gtk2-Perl Applications"
    Section "Asciio - ASCII Art Editor" perl-App-Asciio_id
        SectionIn 2 3 4
        AddSize 6726
        push "perl-App-Asciio.2009.135.1.tar.lzma"
        push "3559f380958b3d85d09c7a17756bd756"
        SectionGetText ${perl-App-Asciio_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-App-Asciio
    Section "Sprog - Build programs using 'parts'" perl-App-Sprog_id
        SectionIn 2 3 4
        AddSize 470
        push "perl-App-Sprog.2009.138.1.tar.lzma"
        push "5317091d9523bfee6f00ed421dba9b62"
        SectionGetText ${perl-App-Sprog_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-App-Sprog
    Section "Gtk2::Ex::DBI - Bind Glade XML to a datasource" perl-Gtk2-Ex-DBI_id
        SectionIn 2 3 4
        AddSize 120
        push "perl-Gtk2-Ex-DBI.2009.135.1.tar.lzma"
        push "1a380648fd43ff1fe8f9dd3899b36aea"
        SectionGetText ${perl-Gtk2-Ex-DBI_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-Ex-DBI
    Section "Gtk2::Ex::Datasheet::DBI - Model/Treeview Object" perl-Gtk2-Ex-Datasheet-DBI_id
        SectionIn 2 3 4
        AddSize 345
        push "perl-Gtk2-Ex-Datasheet-DBI.2009.135.1.tar.lzma"
        push "0b5e9f2fe6dce53d8c5b741232557065"
        SectionGetText ${perl-Gtk2-Ex-Datasheet-DBI_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-Ex-Datasheet-DBI
    Section "Gtk2::Ex::PodViewer - a GTK Perl POD viewer" perl-Gtk2-Ex-PodViewer_id
        SectionIn 2 3 4
        AddSize 184
        push "perl-Gtk2-Ex-PodViewer.2009.135.1.tar.lzma"
        push "eb4b9296afc1ba6ddb73f6666de6aef5"
        SectionGetText ${perl-Gtk2-Ex-PodViewer_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Gtk2-Ex-PodViewer
SectionGroupEnd ; Gtk2-Perl Applications

SectionGroup "Extra Perl Modules"
    Section "CPAN Metadata files" perl-5.10.0-cpan_metadata_id
        SectionIn 2 3 4 6
        AddSize 12695
        push "perl-5.10.0-cpan_metadata.2009.126.1.tar.lzma"
        push "136de7a57c521898585caedc35e02edd"
        SectionGetText ${perl-5.10.0-cpan_metadata_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-5.10.0-cpan_metadata
    Section "XML::Parser - XML document parsing in Perl" perl-XML-Parser_id
        SectionIn 2 3 4 6
        AddSize 396
        push "perl-XML-Parser.2009.135.1.tar.lzma"
        push "48daaa686a27a6292647f4077b4f9b7d"
        SectionGetText ${perl-XML-Parser_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-XML-Parser
    Section "YAML - Yet Another Markup Language" perl-YAML_id
        SectionIn 1 2 3 4 6
        AddSize 108
        push "perl-YAML.2009.127.1.tar.lzma"
        push "338ed1b6d5858a02110148a09b9e864c"
        SectionGetText ${perl-YAML_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-YAML
    Section "LWP/libwww-perl" perl-LWP_id
        SectionIn 1 2 3 4 6
        AddSize 855
        push "perl-LWP.2009.127.1.tar.lzma"
        push "da390b02d957c8347fdca88e7737a44f"
        SectionGetText ${perl-LWP_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-LWP
    Section "Moose: a Post-Modern Object Framework for Perl" perl-Moose_id
        SectionIn 2 3 4 6
        AddSize 1236
        push "perl-Moose.2009.134.1.tar.lzma"
        push "009335e438a6c8c46a5b004034112348"
        SectionGetText ${perl-Moose_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Moose
    Section "PAR: Perl Archive Toolkit" perl-PAR_id
        SectionIn 2 3 4 6
        AddSize 311
        push "perl-PAR.2009.134.1.tar.lzma"
        push "a55a47d9c7ce9f716cb89e5fc46c9d01"
        SectionGetText ${perl-PAR_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-PAR
    Section "PAR::Packer: The PAR Packer (creator) Toolkit" perl-PAR-Packer_id
        SectionIn 2 3 4 6
        AddSize 5914
        push "perl-PAR-Packer.2009.134.1.tar.lzma"
        push "561975f140410792fc50a954b4577212"
        SectionGetText ${perl-PAR-Packer_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-PAR-Packer
    Section "Log::Log4perl: A Perl clone of log4j (but better)" perl-Log-Log4perl_id
        SectionIn 2 3 4 6
        AddSize 519
        push "perl-Log-Log4perl.2009.134.1.tar.lzma"
        push "f5ba594bee3988b87a7287ea09ed7eec"
        SectionGetText ${perl-Log-Log4perl_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Log-Log4perl
    Section "Date::Format: Date formatting subroutines" perl-TimeDate_id
        SectionIn 2 3 4 6
        AddSize 59
        push "perl-TimeDate.2009.134.1.tar.lzma"
        push "9080a41fcb6a7955bf636f035159f2bc"
        SectionGetText ${perl-TimeDate_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-TimeDate
    Section "JSON: Javascript data serialization/storage" perl-JSON_id
        SectionIn 2 3 4 6
        AddSize 127
        push "perl-JSON.2009.134.1.tar.lzma"
        push "f6e9d55299f2469c27d1f0bfe239a9b3"
        SectionGetText ${perl-JSON_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-JSON
    Section "Win32::API and Win32::ODBC Modules" perl-Win32-API-ODBC_id
        SectionIn 2 3 4 6
        AddSize 278
        push "perl-Win32-API-ODBC.2009.134.1.tar.lzma"
        push "549bc3ec6902d010a03a76512644d58f"
        SectionGetText ${perl-Win32-API-ODBC_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Win32-API-ODBC
    Section "Tk: Perl bindings for the Tk widget toolkit" perl-Tk_id
        SectionIn 3 4
        AddSize 6167
        push "perl-Tk.2009.138.1.tar.lzma"
        push "ae1fb459aa66ff0ce59a6adf5dcb8db1"
        SectionGetText ${perl-Tk_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Tk
    Section "Bundle::libwin32; Windows-specific Perl modules" perl-Bundle-libwin32_id
        SectionIn 1 2 3 4 6
        AddSize 1793
        push "perl-Bundle-libwin32.2009.141.1.tar.lzma"
        push "a54446790dd869ef659ec1cf2894b3f3"
        SectionGetText ${perl-Bundle-libwin32_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-Bundle-libwin32
SectionGroupEnd ; Extra Perl Modules

SectionGroup "Perl Database Support"
    Section "DBI - Database Independent Interface" perl-DBI_id
        SectionIn 1 2 3 4 7
        AddSize 1442
        push "perl-DBI.2009.134.1.tar.lzma"
        push "c64792f8a9b3e6631a2b012808cef8a6"
        SectionGetText ${perl-DBI_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBI
    Section "DBD::mysql - DBD driver for MySQL" perl-DBD-mysql_id
        SectionIn 1 2 3 4 7
        AddSize 192
        push "perl-DBD-mysql.2009.134.1.tar.lzma"
        push "15644560f3c75dcf77cfaa353865949f"
        SectionGetText ${perl-DBD-mysql_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-mysql
    Section "DBD::ODBC - ODBC Driver for Perl DBI" perl-DBD-ODBC_id
        SectionIn 1 2 3 4 7
        AddSize 245
        push "perl-DBD-ODBC.2009.134.1.tar.lzma"
        push "894969a68cc59df9ac0110eca7553b1b"
        SectionGetText ${perl-DBD-ODBC_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-ODBC
    Section "DBD::Pg - DBD driver for PostgreSQL" perl-DBD-Pg_id
        SectionIn 1 2 3 4 7
        AddSize 385
        push "perl-DBD-Pg.2009.138.1.tar.lzma"
        push "fb6bfd4b4e05e121d23c79b6b3526819"
        SectionGetText ${perl-DBD-Pg_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-Pg
    Section "DBD::SQLite - Pure Perl DBD driver for SQLite" perl-DBD-SQLite_id
        SectionIn 1 2 3 4 7
        AddSize 616
        push "perl-DBD-SQLite.2009.134.1.tar.lzma"
        push "10772e0b13e1c5086d79a479032e7f39"
        SectionGetText ${perl-DBD-SQLite_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-DBD-SQLite
SectionGroupEnd ; Perl Database Support

SectionGroup "Development Packages"
    Section "Minimal GNU for Windows (MinGW) Toolkit" mingw_id
        SectionIn 3 4
        AddSize 68964
        push "mingw.2009.113.1.tar.lzma"
        push "745e620b429f7c98920cbd07aeb2b3f5"
        SectionGetText ${mingw_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mingw
    Section "dmake Makefile Processor" dmake_id
        SectionIn 3 4
        AddSize 180
        push "dmake.2009.113.1.tar.lzma"
        push "9dd1aa6f2f022a073efb342ccd9999c1"
        SectionGetText ${dmake_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; dmake
    Section "Core GTK Development Files" gtk-core-dev_id
        SectionIn 3 4
        AddSize 14234
        push "gtk-core-dev.2009.113.1.tar.lzma"
        push "e59daf63f4fd04014e4988de2d4fc12b"
        SectionGetText ${gtk-core-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-dev
    Section "gtk-support-dev (gettext/libintl/etc.)" gtk-support-dev_id
        SectionIn 3 4
        AddSize 256
        push "gtk-support-dev.2009.113.1.tar.lzma"
        push "219788087d109221f9d817c7ffb6c66d"
        SectionGetText ${gtk-support-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-support-dev
    Section "imagelibs-dev (JPG/PNG/TIFF Headers)" imagelibs-dev_id
        SectionIn 3 4
        AddSize 1726
        push "imagelibs-dev.2009.113.1.tar.lzma"
        push "9685c932145c52f588dfcc8669d24546"
        SectionGetText ${imagelibs-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-dev
    Section "libglade-dev (Glade Headers)" libglade-dev_id
        SectionIn 3 4
        AddSize 5358
        push "libglade-dev.2009.113.1.tar.lzma"
        push "62091f3cb77712b441bf3cbad0b46716"
        SectionGetText ${libglade-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libglade-dev
    Section "libgnomecanvas-dev (GnomeCanvas Headers)" libgnomecanvas-dev_id
        SectionIn 3 4
        AddSize 4146
        push "libgnomecanvas-dev.2009.127.1.tar.lzma"
        push "584a946acbf62d4e9d4c69f3a019926a"
        SectionGetText ${libgnomecanvas-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgnomecanvas-dev
    Section "libgoocanvas-dev (GooCanvas Headers)" libgoocanvas-dev_id
        SectionIn 3 4
        AddSize 9451
        push "libgoocanvas-dev.2009.113.1.tar.lzma"
        push "8b877288decdfd33cf97a87e1aa682cf"
        SectionGetText ${libgoocanvas-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; libgoocanvas-dev
    Section "Expat XML Parser Development Files" expat-dev_id
        SectionIn 3 4
        AddSize 171
        push "expat-dev.2009.127.1.tar.lzma"
        push "07a37ef60150edcbf47898a4235b80d5"
        SectionGetText ${expat-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; expat-dev
SectionGroupEnd ; Development Packages

SectionGroup "Database Tools Packages"
    Section "MySQL Client Binary and Library (mysql.exe, libmysql.dll)" mysql-bin_id
        SectionIn 1 2 3 4 7
        AddSize 5784
        push "mysql-bin.2009.113.1.tar.lzma"
        push "c286aa57f1a0d64c8250701ab7340820"
        SectionGetText ${mysql-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-bin
    Section "MySQL Debugging Binaries" mysql-debug_id
        SectionIn 4
        AddSize 86729
        push "mysql-debug.2009.113.1.tar.lzma"
        push "9c12cb17aae4f9a4c260b1a8c68b4b69"
        SectionGetText ${mysql-debug_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-debug
    Section "MySQL Devel. (headers and import libs)" mysql-dev_id
        SectionIn 3 4
        AddSize 21444
        push "mysql-dev.2009.113.1.tar.lzma"
        push "b47833fd2550306df85ba3165055bbf8"
        SectionGetText ${mysql-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-dev
    Section "MySQL Documentation in .CHM format" mysql-docs_id
        SectionIn 3 4
        AddSize 10305
        push "mysql-docs.2009.113.1.tar.lzma"
        push "8b7d70016c2e7a631a1c76d080a3b413"
        SectionGetText ${mysql-docs_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-docs
    Section "MySQL Server Binaries" mysql-server_id
        SectionIn 4
        AddSize 7390
        push "mysql-server.2009.113.1.tar.lzma"
        push "5753448c40ce14cefb6e5a52da53e9be"
        SectionGetText ${mysql-server_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; mysql-server
    Section "PostgreSQL Client Binary/Library (psql.exe, libpq.dll)" postgresql-bin_id
        SectionIn 1 2 3 4 7
        AddSize 504
        push "postgresql-bin.2009.139.1.tar.lzma"
        push "57edf0d7cea4e4f5b75a9055aee02908"
        SectionGetText ${postgresql-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; postgresql-bin
    Section "PostgreSQL Devel. (headers and import libs)" postgresql-dev_id
        SectionIn 3 4
        AddSize 11680
        push "postgresql-dev.2009.136.1.tar.lzma"
        push "a777768980ec8aa5bb9b98aea7b4c66b"
        SectionGetText ${postgresql-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; postgresql-dev
    Section "PostgreSQL Documentation in HTML/manpage format" postgresql-docs_id
        SectionIn 3 4
        AddSize 9710
        push "postgresql-docs.2009.136.1.tar.lzma"
        push "7d2ea8ded566de18c42f940e2033abd7"
        SectionGetText ${postgresql-docs_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; postgresql-docs
    Section "PostgreSQL Server Binaries" postgresql-server_id
        SectionIn 4
        AddSize 12696
        push "postgresql-server.2009.136.1.tar.lzma"
        push "33698ddc3af00da416d7f2d6be692898"
        SectionGetText ${postgresql-server_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; postgresql-server
    Section "SQLite Client Binary (sqlite3.exe)" sqlite-bin_id
        SectionIn 1 2 3 4 7
        AddSize 504
        push "sqlite-bin.2009.134.2.tar.lzma"
        push "b7e2529e3b812dd1417554e2bb2cb887"
        SectionGetText ${sqlite-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; sqlite-bin
    Section "SQLite Devel. (headers and import libs)" sqlite-dev_id
        SectionIn 3 4
        AddSize 2074
        push "sqlite-dev.2009.134.1.tar.lzma"
        push "e008bcb7df964d5f5f98616126a34d18"
        SectionGetText ${sqlite-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; sqlite-dev
SectionGroupEnd ; Database Tools Packages

SectionGroup "Extra Tools Packages"
    Section "Glade XML GUI Builder Tool" gladewin32-bin_id
        SectionIn 2 3 4
        AddSize 3359
        push "gladewin32-bin.2009.113.1.tar.lzma"
        push "0cd0fe54769285b83e5405b787e5fc6c"
        SectionGetText ${gladewin32-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gladewin32-bin
    Section "UnxUtilities for Windows" unxutils_id
        SectionIn 2 3 4
        AddSize 6641
        push "unxutils.2009.113.1.tar.lzma"
        push "f33442910389bc39807fba8cd48318dc"
        SectionGetText ${unxutils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; unxutils
    Section "LZMA Compression Utility" lzma_id
        SectionIn 2 3 4
        AddSize 94
        push "lzma.2009.113.1.tar.lzma"
        push "8327bd392ad948f510c0566d628164f7"
        SectionGetText ${lzma_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; lzma
    Section "Expat XML Parsing Library" expat-bin_id
        SectionIn 2 3 4 6
        AddSize 143
        push "expat-bin.2009.127.1.tar.lzma"
        push "90186a6e2316e2c0f3c1fbd4850bd9f0"
        SectionGetText ${expat-bin_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; expat-bin
SectionGroupEnd ; Extra Tools Packages

SectionGroup "Bloatware Packages"
    Section "Glade for Windows Development Files" gladewin32-dev_id
        SectionIn 3 4
        AddSize 619
        push "gladewin32-dev.2009.113.1.tar.lzma"
        push "706988e0e105015eebc04171ce037615"
        SectionGetText ${gladewin32-dev_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gladewin32-dev
    Section "imagelibs Utilities" imagelibs-utils_id
        SectionIn 4
        AddSize 1307
        push "imagelibs-utils.2009.113.2.tar.lzma"
        push "5e6a481bce7d16ec02e2b375b8696d86"
        SectionGetText ${imagelibs-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; imagelibs-utils
    Section "gettext Utilities" gettext-utils_id
        SectionIn 4
        AddSize 6737
        push "gettext-utils.2009.113.1.tar.lzma"
        push "e8c165281face8974ac8ffb57a601f17"
        SectionGetText ${gettext-utils_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gettext-utils
    Section "dmake Makefile Processor (extra files)" dmake-extra_id
        SectionIn 4
        AddSize 613
        push "dmake-extra.2009.113.1.tar.lzma"
        push "565b7d8a954b3ab5a7530d25bd9e192c"
        SectionGetText ${dmake-extra_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; dmake-extra
SectionGroupEnd ; Bloatware Packages

SectionGroup "Documentation and Examples"
    Section "Perl 5.10.0 HTML Documentation" perl-5.10.0-html_docs_id
        SectionIn 3 4
        AddSize 17030
        push "perl-5.10.0-html_docs.2009.126.1.tar.lzma"
        push "9bf40bf9feda3c0ce092535df3e329f9"
        SectionGetText ${perl-5.10.0-html_docs_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-5.10.0-html_docs
    Section "GTK C API HTML/SGML Documentation" gtk-core-doc_id
        SectionIn 3 4
        AddSize 29946
        push "gtk-core-doc.2009.113.1.tar.lzma"
        push "e1199502da3ad9fbca4e72ea2a0e891a"
        SectionGetText ${gtk-core-doc_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; gtk-core-doc
    Section "Gtk2-Perl and GooCanvas Example Scripts" perl-gtk2-goo-canvas-examples_id
        SectionIn 3 4
        AddSize 848
        push "perl-gtk2-goo-canvas-examples.2009.140.2.tar.lzma"
        push "e313b3daca5f50622933e20d06c1d6c1"
        SectionGetText ${perl-gtk2-goo-canvas-examples_id} $0
        push $0
        Call SnarfUnpack
    SectionEnd ; perl-gtk2-goo-canvas-examples
SectionGroupEnd ; Documentation and Examples

SectionGroup /e "Camelbox Environment"
    Section "Add Camelbox to PATH variable"
        SectionIn 1 2 3 4 5 6 7 8 9
        StrCpy $1 "$INSTDIR\bin"
        Push $1
        DetailPrint "Adding to %PATH%: $1"
        Call AddToPath
    SectionEnd
	Section "Create Camelbox URL Files"
        SectionIn 1 2 3 4 5 6 7 8
		DetailPrint "Creating Camelbox URL Files"
		Call CreateCamelboxURLs
	SectionEnd
	Section "Create Perl URL Files"
        SectionIn 1 2 3 4 5 6 7 8
		DetailPrint "Creating Perl URL Files"
		Call CreatePerlURLs
	SectionEnd
	Section "Create Gtk2-Perl URL Files"
        SectionIn 1 2 3 4
		DetailPrint "Creating Gtk2-Perl URL Files"
		Call CreateGtk2PerlTutorialURLs
	SectionEnd
	Section "Create Gtk2-Perl Tutorial URL Files"
        SectionIn 3 4
		DetailPrint "Creating Gtk2-Perl Tutorial URL Files"
		Call CreateGtk2PerlURLs
	SectionEnd
	Section "Create Glade2 Tutorial URL Files"
        SectionIn 3 4
		DetailPrint "Creating Glade2 Tutorial URL Files"
		Call CreateGlade2TutorialURLs
	SectionEnd
	Section "Create Camelbox Start Menu Shortcuts"
        SectionIn 1 2 3 4 5 6 7 8
		DetailPrint "Creating Start Menu Shortcuts"
		Call CreateCamelboxShortcuts
	SectionEnd
SectionGroupEnd ; "Camelbox Environment"

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
    DetailPrint "Removing Camelbox Start Menu"
	IfFileExists "$SMPROGRAMS\Camelbox\*.*" 0 ExitNice
		RMDir /r $SMPROGRAMS\Camelbox
    DetailPrint "Removing ${INSTALL_PATH}"
	IfFileExists "${INSTALL_PATH}\*.*" 0 ExitNice 
    	RMDir /r ${INSTALL_PATH}
	ExitNice:
SectionEnd ; Uninstall

Section "-Open Browser"
	SectionIn RO
	Push $R0
	Push $0
	StrCmp 	$openReleaseNotes "true" 0 ExitOpen
	# yep, it was checked, fork a browser window open
	DetailPrint "Opening 'Releases2009' page in a web browser..."
	ReadRegStr $R0 HKCR "http\shell\open\command" ""
	# check to see if it's IE
	StrCmp $R0 '"C:\Program Files\Internet Explorer\IEXPLORE.EXE" -nohome' DontTrimTail TrimTail
	# Trim the tail of the firefox registry entry
	TrimTail:
		StrCpy $0 $R0 -4 # removes the last 4 characters "%1"
		Goto ExecBrowser # jump to the browser launch
	# But don't trim the tail on IE
	DontTrimTail:
		StrCpy $0 $R0
	ExecBrowser:		
		Exec '$0 ${RELEASE_NOTES}'
	ExitOpen:
		Pop $0
		Pop $R0
		Return
SectionEnd

# blank subsection
#   Section "some-package (extra notes, etc.)"
#       AddSize  # kilobytes
#       push "package-name.YYYY.JJJ.V.tar.lzma"
#       SectionGetText ${some-package_id} $0
#       push $0
#       Call SnarfUnpack
#   SectionEnd

# vim: filetype=nsis paste


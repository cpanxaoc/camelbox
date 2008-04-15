#==========================================================================
#
# TYPE:		NSIS header/include file
#
# NAME: 	camelbox_filelist.nsh
#
# AUTHOR: 	$LastChangedBy: elspicyjack $
# DATE: 	$LastChangedDate: 2008-03-25 01:38:28 -0700 (Tue, 25 Mar 2008) $
#
# COMMENT:	$Id: multipackage_demo.nsi 47 2008-03-25 08:38:28Z elspicyjack $
#
#==========================================================================


#### SECTIONS ####

Section "-WriteUninstaller"
	SectionIn RO
	SetOutPath "$INSTDIR"
	CreateDirectory "$INSTDIR\bin"
	writeUninstaller "$INSTDIR\camelbox_uninstaller.exe"
	#writeUninstaller "$INSTDIR\bin\camelbox_uninstaller.exe"
SectionEnd # WriteUninstaller

; /e in any SectionGroup header means "expanded by default"
Section "Perl 5.10.0 Base Package" perl-core_id
	SectionIn 1 2 3 4 5 6 9
	AddSize 8300 # kilobytes
	push "perl-5.10.0.2008.101.1.tar.lzma"
	push "md5sum"
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
		AddSize 558 # kilobytes
		push "gtk-support-bin.2008.102.1.tar.lzma"
		SectionGetText ${gtk-support-bin_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Gtk2-Perl Core Modules (Cairo/Glib/Gtk2)" perl-gtk2_id
		SectionIn 1 3 4 5 6
		AddSize 772 # kilobytes
		push "perl-gtk2.2008.101.1.tar.lzma"
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
		AddSize 11 # kilobytes
		SectionIn 1 4 5 6
		push "perl-gtk2-gladexml.2008.101.1.tar.lzma"
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
		AddSize 25 # kilobytes
		SectionIn 1 4 5
		push "perl-gnome2-canvas.2008.101.1.tar.lzma"
		SectionGetText ${perl-gnome2-canvas_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Extra Gtk2-Perl Packages"

SectionGroup "Extra Perl Modules"
	Section "YAML - Yet Another Markup Language" perl-YAML_id
		SectionIn 1 9
		AddSize 29 # kilobytes
		push "perl-YAML.2008.101.1.tar.lzma"
		SectionGetText ${perl-YAML_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "LWP/libwww-perl" perl-LWP_id
		SectionIn 1 9
		AddSize 205 # kilobytes
		push "perl-LWP.2008.101.1.tar.lzma"
		SectionGetText ${perl-LWP_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "Moose: a Post-Modern Object Framework" perl-moose_id
		SectionIn 1 9
		AddSize 179 # kilobytes
		push "perl-moose.2008.101.1.tar.lzma"
		SectionGetText ${perl-moose_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "PAR: Perl Archive Toolkit" perl-par_id
		SectionIn 1 9
		AddSize 845 # kilobytes
		push "perl-PAR.2008.101.1.tar.lzma"
		SectionGetText ${perl-par_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "PAR::Packer: The PAR Packer (creator) Toolkit" perl-par-packer_id
		SectionIn 1 9
		AddSize 2000 # kilobytes
		push "perl-PAR-Packer.2008.101.1.tar.lzma"
		SectionGetText ${perl-par-packer_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Extra Perl Modules"

SectionGroup "Development Packages"
	Section "Minimal GNU for Windows (MinGW) Toolkit" mingw_id
		SectionIn 1 5
		AddSize 7500 # kilobytes
		push "mingw.2008.089.1.tar.lzma"
		SectionGetText ${mingw_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "dmake Makefile Processor" dmake_id
		SectionIn 1 5
		AddSize 70 # kilobytes
		push "dmake.2008.101.1.tar.lzma"
		SectionGetText ${dmake_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd	
	Section "Core GTK Development Files" gtk-core-dev_id 
		SectionIn 1 5
		AddSize 830 # kilobytes
		push "gtk-core-dev.2008.094.1.tar.lzma"
		SectionGetText ${gtk-core-dev_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "gtk-support-dev (gettext/libintl/etc.)" gtk-support-dev_id
		SectionIn 1 5
		AddSize 59 # kilobytes
		push "gtk-support-dev.2008.094.1.tar.lzma"
		SectionGetText ${gtk-support-dev_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
	Section "imagelibs-dev (JPG/PNG/TIFF Headers)" imagelibs-dev_id 
		SectionIn 1 5
		AddSize 315 # kilobytes
		push "imagelibs-dev.2008.089.1.tar.lzma"
		SectionGetText ${imagelibs-dev_id} $0
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
		AddSize 540 # kilobytes
		SectionIn 1 5
		push "libgnomecanvas-dev.2008.101.1.tar.lzma"
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
		AddSize 102 # kilobytes
		push "dmake-extra.2008.101.1.tar.lzma"
		SectionGetText ${dmake-extra_id} $0
		push $0
		Call SnarfUnpack
	SectionEnd
SectionGroupEnd # "Extra Tools Packages"

SectionGroup "Documentation and Examples"
	Section "Perl 5.10.0 HTML Documentation" perl-html_docs_id
		SectionIn 1
		AddSize 6700 # kilobytes
		push "perl-5.10.0-html_docs.2008.101.1.tar.lzma"
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

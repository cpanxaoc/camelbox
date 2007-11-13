Camelbox, A complete build of Perl, including all of the Gtk2-Perl widgets, as
well as a working CPAN module for 32-bit Windows systems, packaged as a
zipfile, ready to go!

For support with this software, please post to the Camelbox Google Group:

http://groups.google.com/group/camelbox

Quick Installation Instructions for the impatient
-------------------------------------------------
1) Unzip this zipfile into C:\.  
2) Add the path to the C:\perl\5.8.8\bin directory to your PATH environment
variable
3) Run this in a DOS box (cmd.exe): perl -e 'use Gtk2;' to test that
everything is working
4) Run any of the examples in the C:\perl\examples directory

Longer instructions
-------------------
1) Unzip this zipfile into C:\.  The zipfile is (currently) not portable,
meaning you can't move the install to a different directory.  This may change
at a later date.

2) Add the path to the C:\perl\5.8.8\bin directory to your PATH environment
variable.  The system needs to see all of the DLL's and EXE's that are (now)
located in C:\perl\5.8.8\bin in order to run Perl or any of the Gtk2-Perl
demos.  Environment variables can be edited by right clicking on My Computer
-> Properties -> Advanced tab -> Environment Variables button -> click 'Path'
in the bottom window and then click the 'Edit' button, add 'C:\perl\5.8.8\bin'
without the quotes to the 'Variable value:' box.  Each environment variable
needs to be separated by a semicolon, so don't forget that.

3) Run this in a DOS box (cmd.exe): perl -e 'use Gtk2;'.  This is a simple,
quck test to make sure everything is working, i.e. software unpacked and
placed in the right path on the hard drive, $PATH environment variable set
correctly, etc.

4) Run any of the examples in the C:\perl\examples directory.  The examples
are taken from version 1.162 of the Gtk2 Perl module distribution.


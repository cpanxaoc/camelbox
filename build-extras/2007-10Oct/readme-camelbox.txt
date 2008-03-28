File: readme-camelbox.txt
Last updated: 13Nov2007 14:30PST

Camelbox, A complete build of Perl, including the Gtk2-Perl module and it's
dependencies, as well as a working CPAN module for 32-bit Windows systems,
packaged into an archive and ready to go!

For support with this software, please post to the Camelbox Google Group:

http://groups.google.com/group/camelbox

Quick Installation Instructions for the impatient
-------------------------------------------------
1) Unzip this zipfile into C:\.  
2) Add the path to the C:\perl\5.8.8\bin directory to your PATH environment
variable
3) Run this in a DOS box (cmd.exe): perl -e "use Gtk2;" to test that
everything is working; if you don't get any output at all, that's good!
4) Run any of the examples in the C:\perl\examples directory

Longer instructions
-------------------
1) Unzip this zipfile into C:\.  The zipfile is (currently) not portable,
meaning you can't move the install to a different directory.  This may change
at a later date.

2) Add the path to the C:\perl\5.8.8\bin directory to your %PATH% environment
variable.  The system needs to see all of the DLL's and EXE's that are (now)
located in C:\perl\5.8.8\bin in order to run Perl or any of the Gtk2-Perl
demos.  

Environment variables can be edited by right clicking on My Computer ->
Properties -> Advanced tab -> Environment Variables button -> click 'Path' in
the bottom window and then click the 'Edit' button, add 'C:\perl\5.8.8\bin'
without the quotes to the 'Variable value:' box.  Each environment variable
needs to be separated by a semicolon, so don't forget that.  

You can put the new path of this Perl install after the paths to any other
Perl installs you have on the machine, but be aware that %PATH% on Windows
works from left to right; if a different perl.exe binary is started first, it
won't see the freshly installed GTK libraries and will not work.

3) Run this in a DOS box (cmd.exe): perl -e "use Gtk2;".  This is a simple,
quck test to make sure everything is working, i.e. software unpacked and
placed in the right path on the hard drive, %PATH% environment variable set
correctly, etc.  If something is not right, you'll see errors when you run
this.  If everything is working, you'll just go back to the command prompt
with no output on the screen and no new windows popping up.  This is a good
thing in this case.

4) Run any of the examples in the C:\perl\examples directory.  The examples
are taken from version 1.162 of the Gtk2 Perl module distribution.  Some of
the examples will fail as not all of the extra modules needed to run all of
the examples are installed (yet).

Extra things
------------
If you're from *NIX-space and you use the Windows command shell (cmd.exe) for
any length of time, it becomes 'frustrating'.  If this is you, do yourself a
favor and download and install the UnxUtilities package located here:

http://unxutils.sourceforge.net/

As an example of the 'frustration', in the example command in step #3 above,
the Windows command shell barfs if you use single quotes ('), whereas the
zsh.exe shell that is included with UnxUtils works fine with single or double
quotes.

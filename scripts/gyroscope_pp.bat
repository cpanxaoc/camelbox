cls
del C:\temp\gyroscope.par
C:\camelbox\bin\pp -c --gui --verbose --icon C:\camelbox\bin\wperl.exe -l libgthread-2.0-0.dll -o C:\temp\gyroscope.par -l C:\camelbox\site\lib\auto\Cairo\Cairo.dll -l C:\camelbox\site\lib\auto\Glib\Glib.dll -l C:\camelbox\site\lib\auto\Gtk2\Gtk2.dll -M Win32::Console -M Tie::Hash::NamedCapture -M Gtk2 -M Glib -M Cairo -M Glib::CodeGen -M Gtk2::CodeGen -M Glib::Object::Subclass -l C:\camelbox\lib\ligCarioPerl.dll.a -l libgobject-2.0-0.dll C:\camelbox\examples\gyroscope.pl
REM run resulting PAR file with:
REM perl -MPAR gyroscope.par gyroscope.pl

dlltool --def Gtk2.def --output-exp dll.exp
g++ -o "blib\arch\auto\Gtk2\Gtk2.dll" \
-Wl,--base-file -Wl,dll.base -mdll -s \
-L"c:\perl\5.8.8\lib\CORE" -L"C:\apps\MinGW\lib" "xs\*.o" \
-Wl,--image-base,0x69100000 \
"C:\perl\site\5.8.8\lib\auto\Cairo\Cairo.dll" \
"C:\perl\site\5.8.8\lib\auto\Glib\Glib.dll" \
"C:\perl\5.8.8\lib\CORE\libperl58.a" \
"C:\perl\5.8.8\lib\libintl.a" \
"C:\perl\5.8.8\lib\libiconv.a" \
"C:\apps\MinGW\lib\libmsvcrt.a" \
"C:\apps\MinGW\lib\libmoldname.a" \
"C:\apps\MinGW\lib\libkernel32.a" \
"C:\apps\MinGW\lib\libuser32.a" \
"C:\apps\MinGW\lib\libgdi32.a" \
"C:\apps\MinGW\lib\libwinspool.a" \
"C:\apps\MinGW\lib\libcomdlg32.a" \
"C:\apps\MinGW\lib\libadvapi32.a" \
"C:\apps\MinGW\lib\libshell32.a" \
"C:\apps\MinGW\lib\libole32.a" \
"C:\apps\MinGW\lib\liboleaut32.a" \
"C:\apps\MinGW\lib\libnetapi32.a" \
"C:\apps\MinGW\lib\libuuid.a" \
"C:\apps\MinGW\lib\libws2_32.a" \
"C:\apps\MinGW\lib\libmpr.a" \
"C:\apps\MinGW\lib\libwinmm.a" \
"C:\apps\MinGW\lib\libversion.a" \
"C:\apps\MinGW\lib\libodbc32.a" \
"C:\apps\MinGW\lib\libodbccp32.a" \
"C:\perl\5.8.8\lib\libgtk-win32-2.0.dll.a" \
"C:\perl\5.8.8\lib\libgdk-win32-2.0.dll.a" \
"C:\perl\5.8.8\lib\libatk-1.0.dll.a" \
"C:\perl\5.8.8\lib\libgdk_pixbuf-2.0.dll.a" \
"C:\perl\5.8.8\lib\libpangowin32-1.0.dll.a" \
"C:\perl\5.8.8\lib\libpangocairo-1.0.dll.a" \
"C:\perl\5.8.8\lib\libpango-1.0.dll.a" \
"C:\perl\5.8.8\lib\libcairo.dll.a" \
"C:\perl\5.8.8\lib\libgobject-2.0.dll.a" \
"C:\perl\5.8.8\lib\libgmodule-2.0.dll.a" \
"C:\perl\5.8.8\lib\libglib-2.0.dll.a" \
"C:\perl\5.8.8\lib\libgthread-2.0.dll.a" \
"C:\perl\5.8.8\lib\libintl.a" \
dll.exp

#"C:\perl\5.8.8\lib\cairo.lib" \
#-L"C:\perl\site\5.8.8\lib\auto\Glib" -lGlib \
#-L"C:\perl\site\5.8.8\lib\auto\Cairo" -lCairo \
#"C:\perl\site\5.8.8\lib\auto\Cairo\Cairo.dll" \
#"C:\perl\site\5.8.8\lib\auto\Glib\Glib.dll" \

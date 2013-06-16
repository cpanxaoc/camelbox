# Build notes for next Camelbox release #

## Links ##
- Sysinternals - http://technet.microsoft.com/en-us/sysinternals/bb545046

## General Build Notes ##
- *Can't use UnxUtils on Windows 7*
  - binaries are too old, they generally don't run without crashing

## Building under MinGW 'bash' ##
- If you build under MinGW `bash`, your path should look something like:
  - `/mingw/bin:/usr/bin:/usr/sbin:/c/Windows/System32:/c/Program Files/Git/cmd`
  - `dmake test` under `bash` hangs testing UDP
  - If you build under `cmd.exe`, your path should look something like:
    - `C:\MinGW\bin;C:\MinGW\msys\1.0\bin;C:\MinGW\msys\1.0\sbin;C:\WINDOWS\sys`
    - set the path with: `path %PATH%`
  - Building under `cmd.exe` fails with a `sharing violation`


    C:\Apps\Jenkins\jobs\Perl\workspace\perl-5.18.0\perl.exe ->
      C:\Apps\Jenkins\jobs\Perl\workspace\perl-5.18.0\t\perl.exe
    Sharing violation
    dmake:  Error code 132, while making 'test-prep'

## Building Perl ##

    gunzip -c ../../../source/perl-5.18.0.tar.gz | tar -xvf -
    diff -u ~/src/camelbox.git/build-extras/next_build/perl-5.18.0/win32/makefile.mk makefile.mk | less
    cp ~/src/camelbox.git/build-extras/next_build/perl-5.18.0/win32/makefile.mk .
    export PATH=$PATH:/c/Windows/System32/
    # Verify MinGW and System32 is in the $PATH
    set | grep "^PATH"
    time dmake
    time dmake test

vim: filetype=markdown shiftwidth=2 tabstop=2

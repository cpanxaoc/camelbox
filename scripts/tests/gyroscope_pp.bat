cls
del C:\temp\gyroscope.par
del C:\temp\gyroscope.exe
del C:\temp\pp.log
C:\camelbox\bin\pp @C:\temp\camelbox-svn\scripts\tests\gyroscope_parfile.txt C:\temp\camelbox-svn\scripts\tests\gyroscope.pl
REM run resulting PAR file with:
REM perl -MPAR gyroscope.par gyroscope.pl

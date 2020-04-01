@ECHO OFF
ECHO Apply Fix it for ADV200001
REM https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/ADV200001
IF not EXIST %windir%\system32\jscript.dll goto END
takeown /f %windir%\system32\jscript.dll
cacls %windir%\system32\jscript.dll /E /P everyone:N
IF not EXIST %windir%\syswow64\jscript.dll goto END
takeown /f %windir%\syswow64\jscript.dll
cacls %windir%\syswow64\jscript.dll /E /P everyone:N
:END
ECHO Done. You do not need to restart your computer.
TIMEOUT 15

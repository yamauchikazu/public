@ECHO OFF
REM https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/ADV200001
ECHO Undo Fix it for ADV200001
IF not EXIST %windir%\system32\jscript.dll goto END
cacls %windir%\system32\jscript.dll /E /R everyone
IF not EXIST %windir%\syswow64\jscript.dll goto END
cacls %windir%\syswow64\jscript.dll /E /R everyone
:END
ECHO Done. You do not need to restart your computer.
TIMEOUT 15
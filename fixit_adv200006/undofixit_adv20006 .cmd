@ECHO OFF
REM https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv200006
ECHO Undo fixit for ADV200006. Type CTRLÅ{C to cancel.
PAUSE

ECHO [1/3] Undo "Disable the Preview Pane and Details Pane in Windows Explorer"
REG DELETE "HKCU\SYSTEM\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v DisableThumbnails /f
REG DELETE "HKCU\SYSTEM\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoPreviewPane /f
REG DELETE "HKCU\SYSTEM\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoReadingPane /f

ECHO [2/3] Undo "Disable the WebClient service"
SC CONFIG WebClient start= demand

ECHO [3/3] Undo Rename ATMFD.DLL

IF not EXIST %windir%\system32\x-atmfd.dll goto WINDOWS_10_NEWER
cd "%windir%\system32"
rename x-atmfd.dll atmfd.dll
icacls.exe atmfd.dll /setowner "NT SERVICE\TrustedInstaller"
icacls.exe . /restore atmfd.dll.acl

IF not EXIST %windir%\syswow64\x-atmfd.dll goto SKIP64BIT
cd "%windir%\syswow64"
rename x-atmfd.dll atmfd.dll
icacls.exe atmfd.dll /setowner "NT SERVICE\TrustedInstaller"
icacls.exe . /restore atmfd.dll.acl

:SKIP64BIT
WMIC OS GET VERSION | find "10." > nul
IF not errorlevel 1 GOTO WINDOWS_10
WMIC OS GET VERSION | find "6.3." > nul
IF not errorlevel 1 GOTO WINDOWS_81
WMIC OS GET VERSION | find "6.2." > nul
IF not errorlevel 1 GOTO WINDOWS_8
WMIC OS GET VERSION | find "6.1." > nul
IF not errorlevel 1 GOTO WINDOWS_7
WMIC OS GET VERSION | find "6." > nul
IF not errorlevel 1 GOTO WINDOWS_VISTA
WMIC OS GET VERSION | find "5." > nul
IF not errorlevel 1 GOTO WINDOWS_XP
GOTO WINDOWS_UNKOWN

:WINDOWS_10_NEWER
:WINDOWS_10
GOTO WINDOWS_REBOOT

:WINDOOWS_81
:WINDOWS_8
:WINDOWS_7
:WINDOWS_VISTA

ECHO [3/3] Undo Optional procedure for Windows 8.1 operating systems and below (disable ATMFD)
REG DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /f

:WINDOWS_REBOOT
TIMEOUT 30
ECHO Restart computer in 30 sec. Type CTRLÅ{C to cancel.
SHUTDOWN /R /T 0
GOTO END

:WINDOWS_XP
:WINDOWS_UNKOWN
ECHO Do nothing.

:END
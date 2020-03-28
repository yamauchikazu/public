@ECHO OFF
REM https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv200006
ECHO Undo fixit for ADV200006. Type CTRL{C to cancel.
PAUSE

ECHO [1/3] Undo "Disable the Preview Pane and Details Pane in Windows Explorer"
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v DisableThumbnails /f
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoPreviewPane /f
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoReadingPane /f

ECHO [2/3] Undo "Disable the WebClient service"
SC CONFIG WebClient start= demand

ECHO [3/3] Undo Rename ATMFD.DLL

IF EXIST %windir%\system32\atmfd.dll goto SKIPRENAME
IF not EXIST %windir%\system32\x-atmfd.dll goto WINDOWS_10_1709ORNEWER
pushd "%windir%\system32"
rename x-atmfd.dll atmfd.dll
icacls.exe atmfd.dll /setowner "NT SERVICE\TrustedInstaller"
icacls.exe . /restore atmfd.dll.acl
popd

IF not EXIST %windir%\syswow64\x-atmfd.dll goto SKIPRENAME
pushd "%windir%\syswow64"
rename x-atmfd.dll atmfd.dll
icacls.exe atmfd.dll /setowner "NT SERVICE\TrustedInstaller"
icacls.exe . /restore atmfd.dll.acl
popd

:SKIPRENAME
WMIC OS GET VERSION | find "10." > nul
IF not errorlevel 1 GOTO WINDOWS_10

REM ECHO [3/3+] Undo Optional procedure for Windows 8.1 operating systems and below (disable ATMFD)
ECHO [3/3+] Undo Optional procedure for Windows 7 to 8.1 and Server 2008 to 2012 R2 (disable ATMFD)
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /t REG_DWORD /d 0 /f
REG DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /f
REG QUERY "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD
GOTO WINDOWS_REBOOT

:WINDOWS_10_1709ORNEWER
:WINDOWS_10
:WINDOWS_REBOOT
REM ECHO You need to restart computer!
REM PAUSE
ECHO Restart computer in 30 sec. Type CTRL{C to cancel.
TIMEOUT 30
SHUTDOWN /R /T 0
GOTO END

:WINDOWS_UNKOWN
ECHO Do nothing.

:END

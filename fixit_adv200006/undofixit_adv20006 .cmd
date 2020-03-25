@ECHO OFF
REM https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv200006
ECHO Undo fixit for ADV200006. Type CTRL＋C to cancel.
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
cd "%windir%\system32"
rename x-atmfd.dll atmfd.dll
icacls.exe atmfd.dll /setowner "NT SERVICE\TrustedInstaller"
icacls.exe . /restore atmfd.dll.acl

IF not EXIST %windir%\syswow64\x-atmfd.dll goto SKIPRENAME
cd "%windir%\syswow64"
rename x-atmfd.dll atmfd.dll
icacls.exe atmfd.dll /setowner "NT SERVICE\TrustedInstaller"
icacls.exe . /restore atmfd.dll.acl

:SKIPRENAME
WMIC OS GET VERSION | find "10." > nul
IF not errorlevel 1 GOTO WINDOWS_10

:WINDOWS_10_1709ORNEWER
:WINDOWS_10
GOTO WINDOWS_REBOOT

ECHO [3/3+] Undo Optional procedure for Windows 8.1 operating systems and below (disable ATMFD)
REG DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /f
REG QUERY "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /f

:WINDOWS_REBOOT
TIMEOUT 30
ECHO Restart computer in 30 sec. Type CTRL＋C to cancel.
SHUTDOWN /R /T 0
GOTO END

:WINDOWS_UNKOWN
ECHO Do nothing.

:END

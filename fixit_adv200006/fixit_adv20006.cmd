@ECHO OFF
REM https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv200006
ECHO Apply fit it for ADV200006. Type CTRL+C to cannel.
PAUSE

IF not EXIST %windir%\system32\wbem\wmic.exe goto WINDOWS_UNKOWN

REM Disable the Preview Pane and Details Pane in Windows Explorer
ECHO [1/3] Disable the Preview Pane and Details Pane in Windows Explorer
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v DisableThumbnails /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoPreviewPane /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoReadingPane /t REG_DWORD /d 1 /f

REM Disable the WebClient service
ECHO [2/3] Disable the WebClient service
NET STOP WebClient
SC CONFIG WebClient start= disabled

REM Rename ATMFD.DLL (if present ATMFD.DLL)
ECHO [3/3] Rename ATMFD.DLL

IF EXIST %windir%\system32\x-atmfd.dll goto SKIPRENAME
IF not EXIST %windir%\system32\atmfd.dll goto WINDOWS_10_1709ORNEWER
cd "%windir%\system32"
takeown.exe /f atmfd.dll
icacls.exe atmfd.dll /save atmfd.dll.acl
icacls.exe atmfd.dll /grant Administrators:(F) 
rename atmfd.dll x-atmfd.dll

IF not EXIST %windir%\syswow64\atmfd.dll goto SKIPRENAME
cd "%windir%\syswow64"
takeown.exe /f atmfd.dll
icacls.exe atmfd.dll /save atmfd.dll.acl
icacls.exe atmfd.dll /grant Administrators:(F) 
rename atmfd.dll x-atmfd.dll

:SKIPRENAME
WMIC OS GET VERSION | find "10." > nul
IF not errorlevel 1 GOTO WINDOWS_10

ECHO [3/3+] Optional procedure for Windows 8.1 operating systems and below (disable ATMFD)
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /t REG_DWORD /d 1 /f
TIMEOUT /T 15 /NOBREAK > nul
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD /t REG_DWORD /d 1 /f
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v DisableATMFD
GOTO WINDOWS_REBOOT

:WINDOWS_10_1709ORNEWER
ECHO There is not exist affected dll.
:WINDOWS_10
:WINDOWS_REBOOT
ECHO Restart computer in 30 sec. Type CTRL+C to cancel.
TIMEOUT 30
SHUTDOWN /R /T 0
GOTO END

:WINDOWS_UNKOWN
ECHO Do nothing.

:END

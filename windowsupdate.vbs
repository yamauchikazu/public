Option Explicit
Dim updateSession, updateSearcher, update, searchResult, downloader, updatesToDownload, updatesToInstall, installer, installationResult, InputKey, i
Dim objWMIService, colOperatingSystems,  ObjOperatingSystem

If Right((LCase(WScript.FullName)),11) <> "cscript.exe" then
  WScript.Echo "This script should be run using CSCRIPT.EXE." & _
    vbCRLF & "Example: cscript WindowsUpdate.vbs"
  WScript.Quit(0)
End if

WScript.Echo "------------------------------"
WScript.Echo "Windows Update"
WScript.Echo "------------------------------"
WScript.Echo "Checking for updates ..."
Set updateSession = CreateObject("Microsoft.Update.Session")
Set updateSearcher = updateSession.CreateupdateSearcher()
Set searchResult = _
  updateSearcher.Search("IsInstalled=0 and Type='Software'")
'  updateSearcher.Search("IsInstalled=0 and Type='Software' and AutoSelectOnWebSites=1")
' https://docs.microsoft.com/en-us/previous-versions/windows/desktop/aa386526(v=vs.85)
For i = 0 To searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(i)
    WScript.Echo i + 1 & vbTab & update.Title & " Size: " & update.MaxDownloadSize
Next

If searchResult.Updates.Count = 0 Then
  WScript.Echo "There are no updates available. Windows is up to date."
  WScript.Quit(0)
Else
  WScript.Echo searchResult.Updates.Count & _
    " update(s) have been detected. Start downloading update(s)."
  WScript.StdOut.Write vbCRLF & "Press any key to continue (Ctrl + C to abort):"
  InputKey = WScript.StdIn.Readline
End If

WScript.StdOut.Write "Preparing for download ..."
Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")
For i = 0 to searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(i)
    WScript.StdOut.Write "."
    updatesToDownload.Add(update)
Next

WScript.Echo vbCRLF & "Downloading update(s) ..."
Set downloader = updateSession.CreateUpdateDownloader() 
downloader.Updates = updatesToDownload
downloader.Download()

WScript.Echo "Download of the following update(s) has been completed."
For i = 0 To searchResult.Updates.Count-1
  Set update = searchResult.Updates.Item(i)
  If update.IsDownloaded Then
    WScript.Echo i + 1 & vbTab & update.Title
  End If
Next

Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")
WScript.StdOut.Write "Preparing for installation ..." 
For i = 0 To searchResult.Updates.Count-1
  set update = searchResult.Updates.Item(i)
  If update.IsDownloaded = true Then
    WScript.StdOut.Write "."
    updatesToInstall.Add(update)	
  End If
Next

WScript.Echo vbCRLF & "Installing update(s) ..."
Set installer = updateSession.CreateUpdateInstaller()
installer.Updates = updatesToInstall
Set installationResult = installer.Install()

if installationResult.ResultCode = 2 then
  WScript.Echo "The installation completed successfully."
Else
  WScript.Echo "Some updates could not be installed."
End If
WScript.Echo "Details: "
For i = 0 to updatesToInstall.Count - 1
  WScript.StdOut.Write i + 1 & vbTab & _
    updatesToInstall.Item(i).Title
  If installationResult.GetUpdateResult(i).ResultCode = 2 then
    WScript.Echo ": Succeeded"
  Else
    WScript.Echo ": failed"
  End If
Next
WScript.StdOut.Write "Need to reboot: "
if installationResult.RebootRequired then
  WScript.Echo "True"
  WScript.Echo "Important! Restart the computer to complete the installation of important updates (Ctrl+C to abort the restart)."
Else
  WScript.Echo "False"
End if

WScript.StdOut.Write vbCRLF & "To continue, press any key."
InputKey = WScript.StdIn.Readline
if installationResult.RebootRequired then
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate,(Shutdown)}!\\.\root\cimv2") 
  Set colOperatingSystems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem") 
  For Each objOperatingSystem in colOperatingSystems 
    ObjOperatingSystem.Reboot() 
  Next
  WScript.Quit(-1)
Else
  WScript.Quit(0)
End If

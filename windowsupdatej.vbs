Option Explicit
Dim updateSession, updateSearcher, update, searchResult, downloader, updatesToDownload, updatesToInstall, installer, installationResult, InputKey, i
Dim objWMIService, colOperatingSystems,  ObjOperatingSystem

If Right((LCase(WScript.FullName)),11) <> "cscript.exe" then
  WScript.Echo "このスクリプトはCSCRIPT.EXEを使用して実行して下さい。" & _
    vbCRLF & "例： cscript WindowsUpdate.vbs"
  WScript.Quit(0)
End if

WScript.Echo "------------------------------"
WScript.Echo "Windows Update"
WScript.Echo "------------------------------"
WScript.Echo "更新プログラムを確認しています..."
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
  WScript.Echo "利用可能な更新プログラムはありません。Windows は最新の状態です。"
  WScript.Quit(0)
Else
  WScript.Echo searchResult.Updates.Count & _
    " 個の更新プログラムを検出しました。ダウンロードを開始します。"
  WScript.StdOut.Write vbCRLF & "続行するには何かキーを押してください（中止するには Ctrl + C）："
  InputKey = WScript.StdIn.Readline
End If

WScript.StdOut.Write "ダウンロードの準備をしています..."
Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")
For i = 0 to searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(i)
    WScript.StdOut.Write "."
    updatesToDownload.Add(update)
Next

WScript.Echo vbCRLF & "更新プログラムをダウンロードしています..."
Set downloader = updateSession.CreateUpdateDownloader() 
downloader.Updates = updatesToDownload
downloader.Download()

WScript.Echo "以下の更新プログラムのダウンロードが完了しました。"
For i = 0 To searchResult.Updates.Count-1
  Set update = searchResult.Updates.Item(i)
  If update.IsDownloaded Then
    WScript.Echo i + 1 & vbTab & update.Title
  End If
Next

Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")
WScript.StdOut.Write "インストールの準備をしています..." 
For i = 0 To searchResult.Updates.Count-1
  set update = searchResult.Updates.Item(i)
  If update.IsDownloaded = true Then
    WScript.StdOut.Write "."
    updatesToInstall.Add(update)	
  End If
Next

WScript.Echo vbCRLF & "更新プログラムをインストールしています..."
Set installer = updateSession.CreateUpdateInstaller()
installer.Updates = updatesToInstall
Set installationResult = installer.Install()

if installationResult.ResultCode = 2 then
  WScript.Echo "インストールは正常に完了しました。"
Else
  WScript.Echo "一部の更新プログラムをインストールできませんでした。"
End If
WScript.Echo "詳細："
For i = 0 to updatesToInstall.Count - 1
  WScript.StdOut.Write i + 1 & vbTab & _
    updatesToInstall.Item(i).Title
  If installationResult.GetUpdateResult(i).ResultCode = 2 then
    WScript.Echo "：成功"
  Else
    WScript.Echo "：失敗"
  End If
Next
WScript.StdOut.Write "再起動の必要性： "
if installationResult.RebootRequired then
  WScript.Echo "必要"
  WScript.Echo "！重要な更新プログラムのインストールを完了するためコンピュータを再起動します。"
Else
  WScript.Echo "不要"
End if

WScript.StdOut.Write vbCRLF & "続行するには何かキーを押してください："
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

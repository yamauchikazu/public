Option Explicit
Dim updateSession, updateSearcher, update, searchResult, downloader, updatesToDownload, updatesToInstall, installer, installationResult, InputKey, i
Dim objWMIService, colOperatingSystems,  ObjOperatingSystem

If Right((LCase(WScript.FullName)),11) <> "cscript.exe" then
  WScript.Echo "���̃X�N���v�g��CSCRIPT.EXE���g�p���Ď��s���ĉ������B" & _
    vbCRLF & "��F cscript WindowsUpdate.vbs"
  WScript.Quit(0)
End if

WScript.Echo "------------------------------"
WScript.Echo "Windows Update"
WScript.Echo "------------------------------"
WScript.Echo "�X�V�v���O�������m�F���Ă��܂�..."
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
  WScript.Echo "���p�\�ȍX�V�v���O�����͂���܂���BWindows �͍ŐV�̏�Ԃł��B"
  WScript.Quit(0)
Else
  WScript.Echo searchResult.Updates.Count & _
    " �̍X�V�v���O���������o���܂����B�_�E�����[�h���J�n���܂��B"
  WScript.StdOut.Write vbCRLF & "���s����ɂ͉����L�[�������Ă��������i���~����ɂ� Ctrl + C�j�F"
  InputKey = WScript.StdIn.Readline
End If

WScript.StdOut.Write "�_�E�����[�h�̏��������Ă��܂�..."
Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")
For i = 0 to searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(i)
    WScript.StdOut.Write "."
    updatesToDownload.Add(update)
Next

WScript.Echo vbCRLF & "�X�V�v���O�������_�E�����[�h���Ă��܂�..."
Set downloader = updateSession.CreateUpdateDownloader() 
downloader.Updates = updatesToDownload
downloader.Download()

WScript.Echo "�ȉ��̍X�V�v���O�����̃_�E�����[�h���������܂����B"
For i = 0 To searchResult.Updates.Count-1
  Set update = searchResult.Updates.Item(i)
  If update.IsDownloaded Then
    WScript.Echo i + 1 & vbTab & update.Title
  End If
Next

Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")
WScript.StdOut.Write "�C���X�g�[���̏��������Ă��܂�..." 
For i = 0 To searchResult.Updates.Count-1
  set update = searchResult.Updates.Item(i)
  If update.IsDownloaded = true Then
    WScript.StdOut.Write "."
    updatesToInstall.Add(update)	
  End If
Next

WScript.Echo vbCRLF & "�X�V�v���O�������C���X�g�[�����Ă��܂�..."
Set installer = updateSession.CreateUpdateInstaller()
installer.Updates = updatesToInstall
Set installationResult = installer.Install()

if installationResult.ResultCode = 2 then
  WScript.Echo "�C���X�g�[���͐���Ɋ������܂����B"
Else
  WScript.Echo "�ꕔ�̍X�V�v���O�������C���X�g�[���ł��܂���ł����B"
End If
WScript.Echo "�ڍׁF"
For i = 0 to updatesToInstall.Count - 1
  WScript.StdOut.Write i + 1 & vbTab & _
    updatesToInstall.Item(i).Title
  If installationResult.GetUpdateResult(i).ResultCode = 2 then
    WScript.Echo "�F����"
  Else
    WScript.Echo "�F���s"
  End If
Next
WScript.StdOut.Write "�ċN���̕K�v���F "
if installationResult.RebootRequired then
  WScript.Echo "�K�v"
  WScript.Echo "�I�d�v�ȍX�V�v���O�����̃C���X�g�[�����������邽�߃R���s���[�^���ċN�����܂��B"
Else
  WScript.Echo "�s�v"
End if

WScript.StdOut.Write vbCRLF & "���s����ɂ͉����L�[�������Ă��������F"
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

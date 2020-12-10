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
Set searchResult = updateSearcher.Search("IsInstalled=0 and Type='Software'")
For i = 0 To searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(i)
    WScript.Echo i + 1 & vbTab & update.Title & " Size�iMax�j: " & update.MaxDownloadSize
Next

InputKey = ""

If searchResult.Updates.Count = 0 Then
    WScript.Echo "���p�\�ȍX�V�v���O�����͂���܂���BWindows �͍ŐV�̏�Ԃł��B"
    WScript.Quit(0)
Else
    WScript.StdOut.Write vbCRLF & searchResult.Updates.Count & " �̍X�V�v���O���������o���܂����B���ׂĂ��C���X�g�[������ɂ� A ���ʂ̍X�V�v���O�������C���X�g�[������ɂ͔ԍ�����͂��Ă��������iEnter �Œ��~�j�F"
    InputKey = ucase(WScript.StdIn.Readline)
End If
WScript.echo ""

If InputKey = "" then
    WScript.Echo "���~����܂����B"
    WScript.Quit(0)
End if

If InputKey = "A" then
    InputKey = ""
Else
   If (InputKey < 0) or (cint(InputKey) > searchResult.Updates.Count) then
     WScript.Echo "���͒l���͈͊O�ł��B"
     WScript.Quit(0)
   End if
End If

WScript.StdOut.Write "�_�E�����[�h�̏��������Ă��܂�..."
Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")
For i = 0 to searchResult.Updates.Count-1
   WScript.StdOut.Write "."
   If InputKey = "" then
      Set update = searchResult.Updates.Item(i)
      updatesToDownload.Add(update)
   Else
      if i = cint(InputKey)-1 then
        Set update = searchResult.Updates.Item(i)
        updatesToDownload.Add(update)
      End if
   End if
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
  WScript.Echo "�I�d�v�ȍX�V�v���O�����̃C���X�g�[�����������邽�߃R���s���[�^���ċN�����܂��i�ċN���𒆎~����ɂ� Ctrl�{C�j�B"
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
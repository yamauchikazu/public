$O365UpdateCmd = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
$O365UpdateArg = "/update user displaylevel=True"
if (Test-Path -Path $O365UpdateCmd) {
  Write-Host "Check for updates to Office apps now !"
  Start-Process -FilePath $O365UpdateCmd -ArgumentList $O365UpdateArg
}
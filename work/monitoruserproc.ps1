$TargetUserName = "WIN2016SV01\localuser"
while(1) {
  Write-Host -NoNewLine (Get-Date -Format T)
  Write-Host " *********************************"
  $userprocs = (Get-Process -IncludeUserName -ErrorAction SilentlyContinue)
  $numofprocs = 0
  foreach ($userproc in $userprocs){
    if ($userproc.UserName -eq $TargetUserName) {
       $numofprocs++
       Write-Host -NoNewLine $userproc.UserName
       Write-Host -NoNewLine ", "
       Write-Host -NoNewLine $userproc.Name
       Write-Host -NoNewLine ", "
       Write-Host $userproc.Id
    }
  }
  if ($numofprocs -eq 0){
     Write-Host "There is no user process any more."
     break;
  }
  Start-Sleep -seconds 1
}
pause
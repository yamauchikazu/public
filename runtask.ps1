param($taskname,$taskpath)
#$taskname = ".NET Framework NGEN v4.0.30319 Critical"
#$taskpath = "\Microsoft\Windows\.NET Framework\"
$taskfullname = $taskpath+$taskname
$taskstate = (get-scheduledtask -taskname $taskname -taskpath $taskpath -ErrorAction SilentlyContinue).State

if ($taskstate -eq $null) {
  Write-Host "Error : $taskname is not exist."
  exit
}
if ($taskstate -eq "Disabled") {
  Write-Host "$taskname is $taskstate : nothing to do."
} elseif ($taskstate -eq "Ready") {
  Write-Host -NoNewLine "Start $taskname."
  #Start-ScheduledTask -taskname $taskname -taskpath $taskpath
  SCHTASKS /Run /I /TN $taskfullname
} elseif ($taskstate -eq "Running") {
  Write-Host -NoNewLine "$taskname is already running."
} else {
  SCHTASKS /Run /I /TN $taskfullname
  Write-Host -NoNewLine "$taskname is already in progress."
}

while(1) {
  $taskstate = (get-scheduledtask -taskname $taskname -taskpath $taskpath -ErrorAction SilentlyContinue).State
  if ($taskstate -eq "Ready") {
    Write-Host "Task completed. (Ready)"
    break
  } elseif ($taskstate -eq "Disabled") {
    Write-Host "Task completed. (Disabled)"
    break
  } else { 
    Write-Host -NoNewLine "."
  }
  Start-Sleep -seconds 1
}

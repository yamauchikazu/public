$O365CurrentVer = ""
$O365Bitness = "" 
$O365CurrentVer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue).VersionToReport
if ($O365CurrentVer.Length -eq 0) {
    Write-Host "Microsoft 365 Apps (C2R) is not installed on this PC."
    exit
} else {
  if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration").Platform -eq "x64") {
    $O365Bitness = "64-bit" 
  } else {
    $O365Bitness = "32-bit" 
  }
}
$O365VerStr = "unknown"
$O365BuildStr = "(Build "+$O365CurrentVer.Remove(1,5)+")"
$OfficeVerHisURL = "https://learn.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date"
$webcontent = (Invoke-WebRequest -uri $OfficeVerHisURL).Content
if ($webcontent.contains($O365BuildStr)) { 
  if ($webcontent.Substring($webcontent.IndexOf($O365BuildStr)-6,6).Trim() -match '[0-9]{4}'){
    $O365VerStr = $webcontent.Substring($webcontent.IndexOf($O365BuildStr)-6,6).Trim()
  }
}
Write-Host "Version" $O365VerStr $O365BuildStr $O365Bitness
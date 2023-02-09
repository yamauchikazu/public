$filename = ".\" + $env:Computername + ".txt"

#Get Windows Version and Build
$winArc = "unknown arc"
if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
  $winArc = "x64"
} elseif ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
  $winArc = "arm64"
} else {
  $winArc = "x86"
}
$winReg = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction SilentlyContinue)
#$winName = $winReg.Productname
$winName = (Get-CimInstance -Query 'Select * from Win32_OperatingSystem').Caption
$winVer = $winReg.DisplayVersion
if ($winVer.Length -eq 0) {
  $winVer = $winReg.ReleaseId
}
$winBuild = $winReg.CurrentBuild
$winRev = $winReg.UBR
#Write-Host "$WinName ($winArc), version $winVer, OS build: $winBuild.$winRev"
"$WinName ($winArc), version $winVer, OS build: $winBuild.$winRev" > $filename

#Get Microsoft Edge Version
$edgeVer = (Get-ItemProperty "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe" -ErrorAction SilentlyContinue).VersionInfo.ProductVersion
if ($edgeVer.Length -eq 0) {
  $edgeVer = (Get-ItemProperty "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe").VersionInfo.ProductVersion
}
if ($edgeVer.Length -eq 0) {
  #Write-Host "Microsoft Edge (Chromium) is not installed on this PC."
  "Microsoft Edge (Chromium) is not installed on this PC." >> $filename
} else {
  #Write-Host "Microsoft Edge (Chromium), version: $edgeVer"
  "Microsoft Edge (Chromium), version: $edgeVer" >> $filename
}

#Get Microsoft 365 Apps (C2R) Version
$m365Ver = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue).VersionToReport 
if ($m365Ver.Length -eq 0) {
  #Write-Host "Microsoft 365 Apps (C2R) is not installed on this PC."
  "Microsoft 365 Apps (C2R) is not installed on this PC." >> $filename
} else {
  #Write-Host "Microsoft 365 Apps (C2R), version: $m365Ver"
  "Microsoft 365 Apps (C2R), version: $m365Ver" >> $filename
}
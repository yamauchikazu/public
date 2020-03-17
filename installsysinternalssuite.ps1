[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$InstallTo = "$env:ProgramFiles\SysinternalsSuite"
if (Test-Path "$env:TEMP\SysinternalsSuite.zip") {
  Remove-Item -Path "$env:TEMP\SysinternalsSuite.zip"
}
if (!(Test-Path "$InstallTo")) {
  Write-Host "Start Download SysinternalsSuite.zip ..."
  Invoke-WebRequest -uri "https://live.sysinternals.com/files/sysinternalssuite.zip" -outfile "$env:TEMP\sysinternalssuite.zip" -UseBasicParsing
  Write-Host "Expand SysinternalsSuite.zip ..."
  Expand-Archive -Path "$env:TEMP\SysinternalsSuite.zip" -DestinationPath "$InstallTo"
  Write-Host "Add PATH environment variable ..."
  $path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
  $path += ";" + "$InstallTo"
  [Environment]::SetEnvironmentVariable("PATH", $path, "Machine")
  $env:PATH = $path
} else {
  Write-Host "Sysinternals Suite has already been installed in $InstallTo.`r`n"
  Write-Host "Searching https://live.sysinternals.com/ ..." 
  $webcontent = (Invoke-WebRequest -uri "https://live.sysinternals.com/files/" -UseBasicParsing).Content
  (((($webcontent.Replace("<br>","`r`n")).Replace("</A>","")).Replace("<A HREF=","")).Replace(">"," ")).split("`r`n")|Select-String "SysinternalsSuite.zip"
  Write-Host "`r`n"
  #Write-Host "Searching current latest version top 5..."
  #Get-ChildItem -Path "$InstallTo\*.exe"| Sort-Object LastWriteTime -Desc |Select-Object -first 5 | Ft LastWriteTime, Name
  [ValidateSet("y","n")] $res = Read-Host "Will you update SysinternalsSuite anyway (y/n) ?"
  if ($res -eq "y") {
    Write-Host "Start Download SysinternalsSuite.zip ..."
    Invoke-WebRequest -uri "https://live.sysinternals.com/files/sysinternalssuite.zip" -outfile "$env:TEMP\sysinternalssuite.zip" -UseBasicParsing
    Write-Host "Expand SysinternalsSuite.zip ..."
    Expand-Archive -Path "$env:TEMP\SysinternalsSuite.zip" -DestinationPath "$InstallTo" -Force
    Write-Host "SysinternalsSuite was updated to latest version."
  }
}
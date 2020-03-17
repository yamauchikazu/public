# Reference
# How to: Determine which .NET Framework versions are installed
# https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
# Lifecycle FAQ -- .NET Framework
# https://support.microsoft.com/en-us/help/17455/
# version 2.2 (2019/04/19)

$dotnet40 = $true
Write-Host "*** .NET Framework 4.5 or later *** "
if (Test-Path -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full") {
  if (((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version).Substring(0,4) -eq "4.0.") {
    Write-Host "Not installed."
  } else {
    $dotnet40 = $false
    switch ((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Release) {
      378389 { Write-Host ".NET Framework 4.5" }
      378675 { Write-Host ".NET Framework 4.5.1 installed with Windows 8.1" }
      378758 { Write-Host ".NET Framework 4.5.1 installed on Windows 8, Windows 7 SP1, or Windows Vista SP2" }
      379893 { Write-Host ".NET Framework 4.5.2" } 
      393295 { Write-Host ".NET Framework 4.6 installed with Windows 10" }
      393297 { Write-Host ".NET Framework 4.6 installed on all other Windows OS versions" }
      394254 { Write-Host ".NET Framework 4.6.1 installed on Windows 10" } 
      394271 { Write-Host ".NET Framework 4.6.1 installed on all other Windows OS versions" } 
      394802 { Write-Host ".NET Framework 4.6.2 installed on Windows 10 Anniversary Update and Windows Server 2016"Å@} 
      394806 { Write-Host ".NET Framework 4.6.2 installed on all other Windows OS versions" } 
      460798 { Write-Host ".NET Framework 4.7 installed on Windows 10 Creators Update" } 
      460805 { Write-Host ".NET Framework 4.7 installed on all other Windows OS versions" } 
      461308 { Write-Host ".NET Framework 4.7.1 installed on Windows 10 Fall Creators Update and Windows Server, version 1709" } 
      461310 { Write-Host ".NET Framework 4.7.1 installed on all other Windows OS versions" } 
      461808 { Write-Host ".NET Framework 4.7.2 installed on Windows 10 April 2018 Update and Windows Server, version 1803" } 
      461814 { Write-Host ".NET Framework 4.7.2 installed on all Windows OS versions other than Windows 10 April 2018 Update and Windows Server, version 1803" } 
      528040 { Write-Host ".NET Framework 4.8 installed on Windows 10 May 2019 Update and Windows Server, version 1903" } 
      528049 { Write-Host ".NET Framework 4.8 installed on all Windows OS versions other than Windows 10 May 2019 Update and Windows Server, version 1903" } 
      default { Write-Host ".NET Framework 4.8 or later installed on all other Windows OS versions" } 
    }
  }
} else {
  Write-Host "Not installed."
}
$dotnet35 = $false
Write-Host "*** .NET Framework 2-4 *** "
if (Test-Path -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\") {
  $dotnetvers = (Get-ChildItem "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v*" -Name)
  foreach ($dotnetver in $dotnetvers) {
    if ($dotnetver.Length -ge 4) {
      switch ($dotnetver.Substring(0,4)) {
        "v2.0" { Write-Host ".NET Framework 2 ("(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\$dotnetver" -ErrorAction SilentlyContinue).Version")";$dotnet35 = $true }
        "v3.0" { Write-Host ".NET Framework 3.0 ("(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\$dotnetver").Version")";$dotnet35 = $true }
        "v3.5" { Write-Host ".NET Framework 3.5 ("(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\$dotnetver" -ErrorAction SilentlyContinue).Version")";$dotnet35 = $true }
      }
    } elseif (($dotnetver -eq "v4") -and ($dotnet40)) {
      Write-Host ".NET Framework 4 ( Client"(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version"/Full"(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version")" 
    }
  }
  if ((!$dotnet35) -and (!$dotnet40)) {
    Write-Host "Not installed."
  }
} else {
  Write-Host "Something went wrong."
}

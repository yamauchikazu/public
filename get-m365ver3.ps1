$O365CurrentVer = ""
$O365Bitness = "" 
$O365CurrentVer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue).VersionToReport
if ($O365CurrentVer.Length -eq 0) {
    Write-Host "Microsoft 365 Apps or Microsoft Office (C2R) is not installed on this PC."
    exit
} else {
  if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration").Platform -eq "x64") {
    $O365Bitness = "64-bit" 
  } else {
    $O365Bitness = "32-bit" 
  }
}
$O365ProductName = ""
$productlists = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | ? {$_.DisplayName -ne $null })
$productlists = $productlists + (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | ? {$_.DisplayName -ne $null })

foreach ($product in $productlists) {
  if (($product.DisplayVersion -eq $O365CurrentVer) -and (($product.DisplayName -like "Microsoft 365 Apps *") -or ($product.DisplayName -like "Microsoft Office *"))) { 
    $O365ProductName = $product.DisplayName
  }
}
Write-Host $O365ProductName "(Build "$O365CurrentVer")" $O365Bitness
Import-Module WindowsUpdateProvider -ErrorAction SilentlyContinue
$checkmodule = (Get-Module WindowsUpdateProvider)
if ($checkmodule -eq $null) {
  Write-Host "This script can be run on Windows 10/Server ver 1709(RS3) or later."
  exit
}

Write-Host "Product Name: "
(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
Write-Host "OS Version: "
(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
Write-Host "Current OS Build:"
(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild + "." + (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
Write-Host "Last Check date: "
(Get-WULastScanSuccessDate).DateTime
Write-Host "Last Installation date: "
(Get-WULastInstallationDate).DateTime

# Search for all applicable updates.
# If you receive "Start-WUScan: Scan hit error: @{PSComputerName=}.ReturnValue" error on Windows 10, try to comment out the next two lines.
Write-Host "`r`nSearching for all applicable updates..."
$updates = Start-WUScan

# Search for only recommended updates
# If you receive "Start-WUScan: Scan hit error: @{PSComputerName=}.ReturnValue" error on Windows 10, try to uncomment the next two lines.
# Write-Host "`r`nSearching for recommended updates..."
# $updates = Start-WUScan -SearchCriteria "IsInstalled=0 and Type='Software' and AutoSelectOnWebsites=1"

$updatesCount = $updates.Count
if ($updatesCount -gt 0) {
    if ($updatesCount -eq 1) {
        Write-Host "One update was found.`r`n"
    } else {
        Write-Host $updates.Count "updates were found.`r`n"
    }
    $i = 1
    foreach ($update in $updates) {
        Write-Host $i")" $update.Title
        $i = $i + 1
    }
    $result = $false
    $res = Read-Host "`r`n(A)ll updates, (N)o update or Enter the number of the update to download and install? (A/N/#) "
    if (($res -eq "a") -or ($res -eq "A")) {
        $i = 1
        Write-Host "`r`nInstalling all updates...`r`n"
        foreach ($update in $updates) {
            Write-Host "Update ("$i" of "$updatesCount"):" $update.Title
            $result = (Install-WUUpdates -Updates $update -ErrorAction SilentlyContinue)
            if ($result) {
                Write-Host "Installation Result: Succeeded"
            } else {
                Write-Host "Installation Result: Failed with errors."
            }
            $i = $i + 1   
        }
    } elseif (($res -gt 0) -and ($res -lt ($updates.Count + 1))) {
        Write-Host "`r`nInstalling an update (No."$res")...`r`n"
        Write-Host "Update:" $updates.item($res - 1).Title
        $result = (Install-WUUpdates -Updates $updates.item($res - 1) -ErrorAction SilentlyContinue)
        if ($result) {
            Write-Host "Installation Result: Succeeded"
        } else {
            Write-Host "Installation Result: Failed with errors."
        }
    } else {
        Write-Host "Installation canceled."
        exit
    }
    if (Get-WUIsPendingReboot) {
        $res = Read-Host "A restart is required to complete Windows Updates. Restart now? (y/n) "
        if (($res -eq "y") -or ($res -eq "Y")) {
             Write-Host "Start rebooting..."
             Restart-Computer -Force
        } else {
            Write-Host "You need to restart later."
        }
    }
} else {
    Write-Host "There are no applicable updates."
}
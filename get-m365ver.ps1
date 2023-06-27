#https://learn.microsoft.com/en-us/mem/intune/configuration/administrative-templates-update-office
#https://learn.microsoft.com/ja-jp/mem/configmgr/sum/deploy-use/manage-office-365-proplus-updates#bkmk_channel
$O365CurrentVer = ""
$O365CurrentCdn = "" 
$O365CurrentPol = ""
$O365CurrentVer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue).VersionToReport 
$O365CurrentCdn = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue).CDNBaseUrl
$O365CurrentPol = (Get-ItemProperty -Path "HKLM:\SOFTWARE\policies\microsoft\office\16.0\common\officeupdate" -ErrorAction SilentlyContinue).updatebranch
if ($O365CurrentVer.Length -eq 0) {
    Write-Host "Microsoft 365 Apps or  or Microsoft Office (C2R) is not installed on this PC."
}
else
{
    Write-Host "Microsoft 365 Apps (C2R) Current Version: "$O365CurrentVer
    switch ($O365CurrentCdn) {
        "http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60" {$O365CurrentCdn = "Current Channel"}
        "http://officecdn.microsoft.com/pr/64256afe-f5d9-4f86-8936-8840a6a4f5be" {$O365CurrentCdn = "Current Channel (Preview)"}
        "http://officecdn.microsoft.com/pr/55336b82-a18d-4dd6-b5f6-9e5095c314a6" {$O365CurrentCdn = "Monthly Enterprise Channel"}
        "http://officecdn.microsoft.com/pr/7ffbc6bf-bc32-4f92-8982-f9dd17fd3114" {$O365CurrentCdn = "Semi-Annual Enterprise Channel"}
        "http://officecdn.microsoft.com/pr/b8f9b850-328d-4355-9145-c59439a0c4cf" {$O365CurrentCdn = "Semi-Annual Enterprise Channel (Preview)"}
        "http://officecdn.microsoft.com/pr/5440fd1f-7ecb-4221-8110-145efaa6372f" {$O365CurrentCdn = "Beta Channel"}
    }
    Write-Host  -NoNewLine "  Update Channel (Local Setting):  "$O365CurrentCdn
    if ($O365CurrentPol.length -eq 0) {
        Write-Host " *"
        $O365CurrentPol = "None"
    } else {
        Write-Host ""
        switch ($O365CurrentPol) {
            "Current" {$O365CurrentPol = "Current Channel *"}
	    "FirstReleaseCurrent" {$O365CurrentPol = "Current Channel (Preview) *"}
            "MonthlyEnterprise" {$O365CurrentPol = "Monthly Enterprise Channel *"}
            "Deferred" {$O365CurrentPol = "Semi-Annual Enterprise Channel *"}
            "FirstReleaseDeferred" {$O365CurrentPol = "Semi-Annual Enterprise Channel (Preview) *"}
            "InsiderFast" {$O365CurrentPol = "Beta Channel *"}
        }
    }
    Write-Host "  Update Channel (Policy Setting): "$O365CurrentPol
}

#
# 更新を開始する以下のコードをコメントアウト
#
#$O365UpdateCmd = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
#$O365UpdateArg = "/update user displaylevel=True"
#if (Test-Path -Path $O365UpdateCmd) {
#  Write-Host "Check Update Now!"
#  Start-Process -FilePath $O365UpdateCmd -ArgumentList $O365UpdateArg
#}


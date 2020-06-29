Write-Host ""
$WUSettingsNoAutoUpdate = ""
$WUSettingsNoAutoUpdate = (Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ErrorAction SilentlyContinue).NoAutoUpdate
$WUSettingsAUOptions = ""
$WUSettingsAUOptions = (Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ErrorAction SilentlyContinue).AUOptions
$WSUSSetting = ""
$WSUSSetting = (Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ErrorAction SilentlyContinue).UseWUServer
$WSUSSettingWUServer = ""
$WSUSSettingWUServer = (Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).WUServer
$WUfBSettingBranchLocal = ""
$WUfBSettingFULocal = ""
$WUfBSettingQULocal = ""
$WUfBSettingBranchLocal = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -ErrorAction SilentlyContinue).BranchReadinessLevel
$WUfBSettingFULocal = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -ErrorAction SilentlyContinue).DeferFeatureUpdatesPeriodInDays
$WUfBSettingQULocal = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -ErrorAction SilentlyContinue).DeferQualityUpdatesPeriodInDays
$WUfBSettingBranch = ""
$WUfBSettingFU = ""
$WUfBSettingQU = ""
$WUfBSettingFUdays = ""
$WUfBSettingQUdays = ""
$WUfBSettingBranch = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).BranchReadinessLevel
$WUfBSettingFU = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).DeferFeatureUpdates
$WUfBSettingQU = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).DeferQualityUpdates
$WUfBSettingFUdays = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).DeferFeatureUpdatesPeriodInDays
$WUfBSettingQUdays = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).DeferQualityUpdatesPeriodInDays

$WUfBSettingTargetReleaseVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).TargetReleaseVersion
$WUfBSettingTargetReleaseVersionInfo = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).TargetReleaseVersionInfo

$ConfigMgrClient = ""
$ConfigMgrClient = (Get-WmiObject -Query "Select * from __Namespace WHERE Name='CCM'" -Namespace root -ErrorAction SilentlyContinue)

if ($WSUSSetting -eq "1") {
	$EffectiveWSUS = "enabled"
} else {
	$EffectiveWSUS = "disabled"
}
if ((($WUfBSettingFULocal -eq "0") -and ($WUfBSettingQULocal -eq "0")) -or (($WUfBSettingFULocal.Length -eq 0) -and ($WUfBSettingQULocal.Length -eq 0))) {
	$EffectiveWUfBLocal = "disabled"
} else {
	$EffectiveWUfBLocal = "enabled"
}
if (($WUfBSettingFU -eq "1") -or ($WUfBSettingQU -eq "1")) {
	$EffectiveWUfBPolicy = "enabled"
} else {
	$EffectiveWUfBPolicy = "disabled"
}
if (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBLocal -eq "enabled") -and ($EffectiveWUfBPolicy -eq "enabled")) {
	$EffectiveWSUS = "* WSUS と WUfB の設定が混在しています。この設定は推奨されません。"
	$EffectiveWUfBLocal = "* この設定は無視されます。"
	$EffectiveWUfBPolicy = "* WSUS と WUfB の設定が混在しています。この設定は推奨されません。"
} elseif (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBLocal -eq "enabled")) {
	$EffectiveWSUS = "(* WSUS と WUfB の設定が混在しています。この設定は推奨されません。"
	$EffectiveWUfBLocal = "* WSUS と WUfB の設定が混在しています。この設定は推奨されません。"
	$EffectiveWUfBPolicy = ""
} elseif (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBPolicy -eq "disabled")) {
	$EffectiveWSUS = "* この設定が優先されます。"
	$EffectiveWUfBLocal = ""
	$EffectiveWUfBPolicy = ""
} elseif (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBPolicy -eq "enabled")) {
	$EffectiveWSUS = "* WSUS と WUfB の設定が混在しています。この設定は推奨されません。"
	$EffectiveWUfBLocal = ""
	$EffectiveWUfBPolicy = "* WSUS と WUfB の設定が混在しています。この設定は推奨されません。"
} elseif (($EffectiveWUfBLocal -eq "enabled") -and ($EffectiveWUfBPolicy -eq "enabled")) {
	$EffectiveWSUS = ""
	$EffectiveWUfBLocal = "* この設定は無視されます。"
	$EffectiveWUfBPolicy = "* この設定が優先されます。"
} else {
	$EffectiveWSUS = ""
	$EffectiveWUfBLocal = ""
	$EffectiveWUfBPolicy = ""
}

# Check WU Settings
if ($WUSettingsNoAutoUpdate.Length -eq 0) {
	Write-Host "Windows Update (ポリシー): 未構成 (Windows 10 の既定は自動)"
} else {
  	if ($WUSettingsNoAutoUpdate -eq "1") {
		Write-Host "Windows Update (ポリシー): 手動 (無効)"
	} elseif ($WUSettingsAuOptions -eq "3") {
		Write-Host "Windows Update (ポリシー): ダウンロードのみ"
	} elseif ($WUSettingsAuOptions -eq "4") {
		Write-Host "Windows Update (ポリシー): 自動"
	} else {
		Write-Host "Windows Update (ポリシー): カスタム"
	}
	Write-Host "  (設定場所：コンピューターの構成\管理用テンプレート\Windows コンポーネント\Windows Update\自動更新を構成する)"

}
Write-Host ""
# Check WSUS Settings
if ($WSUSSetting.Length -eq 0) {
	Write-Host "WSUS クライアント: 未構成"
} else {
	if ($WSUSSetting -eq "0") {
		Write-Host "WSUS クライアント: 無効"
	} else {
		Write-Host "WSUS クライアント: 有効"
		Write-Host "  WSUS サーバー:" $WSUSSettingWUServer
	}
	Write-Host "  ("$EffectiveWSUS"設定場所：コンピューターの構成\管理用テンプレート\Windows コンポーネント\Windows Update\イントラネットの Microsoft 更新サービスの場所を指定する)"
}
Write-Host ""
# Check Local WUfB Settings
if ((($WUfBSettingFULocal -eq "0") -and ($WUfBSettingQULocal -eq "0") -and ($WUfBSettingBranchLocal -eq "16")) -or (($WUfBSettingFULocal.Length -eq 0) -and ($WUfBSettingQULocal.Length -eq 0)) -or ($WUfBSettingBranchLocal.Length -eq 0)) {
	Write-Host "Windows Update for Business (設定アプリ): 未構成"
} else {
	Write-Host "Windows Update for Business (設定アプリ): 有効"
	if ($WUfBSettingBranchLocal -eq "16") {
		Write-Host "  更新チャネル（Windows 準備レベル）: 半期チャネル (SAC)" 
	} elseif ($WUfBSettingBranchLocal -eq "32") {
		Write-Host "  更新チャネル（Windows 準備レベル）: SAC-T (1809 以前のみ)" 
	} else {
		Write-Host "  更新チャネル（Windows 準備レベル）: Preview Build" 
	}
	Write-Host "  機能更新プログラムがリリースされた後、受信を延期する日数:" $WUfBSettingFULocal
	Write-Host "  品質更新プログラムがリリースされた後、受信を延期する日数:" $WUfBSettingQULocal
	Write-Host "  ("$EffectiveWUfBLocal"設定場所：設定アプリ > 更新とセキュリティ > Windows Update > 詳細オプション > 更新プログラムをいつインストールするかを選択する（WSUS クライアントでは非表示）)"
}
Write-Host ""
# Check WUfB Settings Policies
if (($WUfBSettingFU -eq "1") -or ($WUfBSettingQU -eq "1") -or ($WUfBSettingTargetReleaseVersion -eq "1")) {
	Write-Host "Windows Update for Business (ポリシー): 有効"
        if ($WUfBSettingBranch.Length -eq 0) {
		Write-Host "  更新チャネル（Windows 準備レベル）: 未構成"
        } else {
		if ($WUfBSettingBranch -eq "16") {
			Write-Host "  更新チャネル（Windows 準備レベル）: SAC" 
                } elseif ($WUfBSettingBranch -eq "32") {
			Write-Host "  更新チャネル（Windows 準備レベル）: SAC-T (1809 以前のみ)" 
		} else {
			Write-Host "  更新チャネル（Windows 準備レベル）: Preview Build" 
		}
        }
        if ($WUfBSettingFU.Length -eq 0){
	        Write-Host "  機能更新プログラムがリリースされた後、受信を延期する日数: 未構成"
        } else { 
	        Write-Host "  機能更新プログラムがリリースされた後、受信を延期する日数:" $WUfBSettingFUdays
        }
	if ($WUfBSettingQU.Length -eq 0){
		Write-Host "  品質更新プログラムがリリースされた後、受信を延期する日数: 未構成"
	} else {
		Write-Host "  品質更新プログラムがリリースされた後、受信を延期する日数:" $WUfBSettingQUdays
	}
	if ($WUfBSettingTargetReleaseVersionInfo.Length -eq 0){
		Write-Host "  ターゲット機能更新プログラムのバージョン (1803 以降): 未構成"
	} else {
		Write-Host "  ターゲット機能更新プログラムのバージョン (1803 以降): " $WUfBSettingTargetReleaseVersionInfo
        }
	Write-Host "  ("$EffectiveWUfBPolicy"設定場所：コンピューターの構成\管理用テンプレート\Windows コンポーネント\Windows Update\Windows Update for Business)"
} else {
	Write-Host "Windows Update for Business (ポリシー): 未構成"
}

Write-Host ""
# Check ConfigMgr Client
if (($ConfigMgrClient.Length -ne 0) -and (Test-Path "C:\Windows\CCMSETUP")) {
	Write-Host "**********************************************************************************************"
	Write-Host "* この PC は Microsoft Endpoint Configration Manager によって管理されている可能性があります。*"
	Write-Host "**********************************************************************************************"
}
Write-Host ""
$WinVer = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
$WinBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
$WinRev = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
Write-Host "現在の更新状態: バージョン"$WinVer", ビルド" $WinBuild"."$WinRev
Write-Host ""
Write-Host "(注意: このスクリプトは Microsoft Intune やその他の更新ツールで管理される PC の調査には対応していません。)"
Write-Host ""

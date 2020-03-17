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
	$EffectiveWSUS = "* WSUS �� WUfB �̐ݒ肪���݂��Ă��܂��B���̐ݒ�͐�������܂���B"
	$EffectiveWUfBLocal = "* ���̐ݒ�͖�������܂��B"
	$EffectiveWUfBPolicy = "* WSUS �� WUfB �̐ݒ肪���݂��Ă��܂��B���̐ݒ�͐�������܂���B"
} elseif (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBLocal -eq "enabled")) {
	$EffectiveWSUS = "(* WSUS �� WUfB �̐ݒ肪���݂��Ă��܂��B���̐ݒ�͐�������܂���B"
	$EffectiveWUfBLocal = "* WSUS �� WUfB �̐ݒ肪���݂��Ă��܂��B���̐ݒ�͐�������܂���B"
	$EffectiveWUfBPolicy = ""
} elseif (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBPolicy -eq "disabled")) {
	$EffectiveWSUS = "* ���̐ݒ肪�D�悳��܂��B"
	$EffectiveWUfBLocal = ""
	$EffectiveWUfBPolicy = ""
} elseif (($EffectiveWSUS -eq "enabled") -and ($EffectiveWUfBPolicy -eq "enabled")) {
	$EffectiveWSUS = "* WSUS �� WUfB �̐ݒ肪���݂��Ă��܂��B���̐ݒ�͐�������܂���B"
	$EffectiveWUfBLocal = ""
	$EffectiveWUfBPolicy = "* WSUS �� WUfB �̐ݒ肪���݂��Ă��܂��B���̐ݒ�͐�������܂���B"
} elseif (($EffectiveWUfBLocal -eq "enabled") -and ($EffectiveWUfBPolicy -eq "enabled")) {
	$EffectiveWSUS = ""
	$EffectiveWUfBLocal = "* ���̐ݒ�͖�������܂��B"
	$EffectiveWUfBPolicy = "* ���̐ݒ肪�D�悳��܂��B"
} else {
	$EffectiveWSUS = ""
	$EffectiveWUfBLocal = ""
	$EffectiveWUfBPolicy = ""
}

# Check WU Settings
if ($WUSettingsNoAutoUpdate.Length -eq 0) {
	Write-Host "Windows Update (�|���V�[): ���\�� (Windows 10 �̊���͎���)"
} else {
  	if ($WUSettingsNoAutoUpdate -eq "1") {
		Write-Host "Windows Update (�|���V�[): �蓮 (����)"
	} elseif ($WUSettingsAuOptions -eq "3") {
		Write-Host "Windows Update (�|���V�[): �_�E�����[�h�̂�"
	} elseif ($WUSettingsAuOptions -eq "4") {
		Write-Host "Windows Update (�|���V�[): ����"
	} else {
		Write-Host "Windows Update (�|���V�[): �J�X�^��"
	}
	Write-Host "  (�ݒ�ꏊ�F�R���s���[�^�[�̍\��\�Ǘ��p�e���v���[�g\Windows �R���|�[�l���g\Windows Update\�����X�V���\������)"

}
Write-Host ""
# Check WSUS Settings
if ($WSUSSetting.Length -eq 0) {
	Write-Host "WSUS �N���C�A���g: ���\��"
} else {
	if ($WSUSSetting -eq "0") {
		Write-Host "WSUS �N���C�A���g: ����"
	} else {
		Write-Host "WSUS �N���C�A���g: �L��"
		Write-Host "  WSUS �T�[�o�[:" $WSUSSettingWUServer
	}
	Write-Host "  ("$EffectiveWSUS"�ݒ�ꏊ�F�R���s���[�^�[�̍\��\�Ǘ��p�e���v���[�g\Windows �R���|�[�l���g\Windows Update\�C���g���l�b�g�� Microsoft �X�V�T�[�r�X�̏ꏊ���w�肷��)"
}
Write-Host ""
# Check Local WUfB Settings
if ((($WUfBSettingFULocal -eq "0") -and ($WUfBSettingQULocal -eq "0") -and ($WUfBSettingBranchLocal -eq "16")) -or (($WUfBSettingFULocal.Length -eq 0) -and ($WUfBSettingQULocal.Length -eq 0)) -or ($WUfBSettingBranchLocal.Length -eq 0)) {
	Write-Host "Windows Update for Business (�ݒ�A�v��): ���\��"
} else {
	Write-Host "Windows Update for Business (�ݒ�A�v��): �L��"
	if ($WUfBSettingBranchLocal -eq "16") {
		Write-Host "  �X�V�`���l���iWindows �������x���j: SAC" 
	} elseif ($WUfBSettingBranchLocal -eq "32") {
		Write-Host "  �X�V�`���l���iWindows �������x���j: SAC-T (1809 �ȑO�̂�)" 
	} else {
		Write-Host "  �X�V�`���l���iWindows �������x���j: Preview Build" 
	}
	Write-Host "  �@�\�X�V�v���O�����������[�X���ꂽ��A��M�������������:" $WUfBSettingFULocal
	Write-Host "  �i���X�V�v���O�����������[�X���ꂽ��A��M�������������:" $WUfBSettingQULocal
	Write-Host "  ("$EffectiveWUfBLocal"�ݒ�ꏊ�F�ݒ�A�v�� > �X�V�ƃZ�L�����e�B > Windows Update > �ڍ׃I�v�V���� > �X�V�v���O���������C���X�g�[�����邩��I������iWSUS �N���C�A���g�ł͔�\���j)"
}
Write-Host ""
# Check WUfB Settings Policies
if (($WUfBSettingFU -eq "1") -or ($WUfBSettingQU -eq "1")) {
	Write-Host "Windows Update for Business (�|���V�[): �L��"
        if ($WUfBSettingBranch.Lengsh -eq 0) {
		Write-Host "  �X�V�`���l���iWindows �������x���j: ���\��"
		Write-Host "  �@�\�X�V�v���O�����������[�X���ꂽ��A��M�������������: ���\��"
        } else {
		if ($WUfBSettingBranch -eq "16") {
			Write-Host "  �X�V�`���l���iWindows �������x���j: SAC" 
                } elseif ($WUfBSettingBranch -eq "32") {
			Write-Host "  �X�V�`���l���iWindows �������x���j: SAC-T (1809 �ȑO�̂�)" 
		} else {
			Write-Host "  �X�V�`���l���iWindows �������x���j: Preview Build" 
		}
		Write-Host "  �@�\�X�V�v���O�����������[�X���ꂽ��A��M�������������:" $WUfBSettingFUdays
        }
	if ($WUfBSettingQU.Length -eq 0){
		Write-Host "  �i���X�V�v���O�����������[�X���ꂽ��A��M�������������: ���\��"
	} else {
		Write-Host " �i���X�V�v���O�����������[�X���ꂽ��A��M�������������:" $WUfBSettingQUdays
	}
	Write-Host "  ("$EffectiveWUfBPolicy"�ݒ�ꏊ�F�R���s���[�^�[�̍\��\�Ǘ��p�e���v���[�g\Windows �R���|�[�l���g\Windows Update\Windows Update for Business)"
} else {
	Write-Host "Windows Update for Business (�|���V�[): ���\��"
}
Write-Host ""
# Check ConfigMgr Client
if (($ConfigMgrClient.Length -ne 0) -and (Test-Path "C:\Windows\CCMSETUP")) {
	Write-Host "**********************************************************************************************"
	Write-Host "* ���� PC �� Microsoft Endpoint Configration Manager �ɂ���ĊǗ�����Ă���\��������܂��B*"
	Write-Host "**********************************************************************************************"
}
Write-Host ""
$WinVer = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
$WinBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
$WinRev = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
Write-Host "���݂̍X�V���: �o�[�W����"$WinVer", �r���h" $WinBuild"."$WinRev
Write-Host ""
Write-Host "(����: ���̃X�N���v�g�� Microsoft Intune �₻�̑��̍X�V�c�[���ŊǗ������ PC �̒����ɂ͑Ή����Ă��܂���B)"
Write-Host ""
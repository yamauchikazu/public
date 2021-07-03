mkdir c:\buildArtifacts
echo Azure-Image-Builder-Was-Here  > c:\buildArtifacts\azureImageBuilder.txt
curl https://raw.githubusercontent.com/yamauchikazu/public/master/aibuilder/ja-jp.cab -o c:\buildArtifacts\Microsoft-Windows-Server-Language-Pack_x64_ja-jp.cab
Add-WindowsPackage -Online -PackagePath c:\buildArtifacts\Microsoft-Windows-Server-Language-Pack_x64_ja-jp.cab -ErrorAction stop | Out-Null
Add-WindowsCapability -Online -Name Language.Basic~~~ja-JP~0.0.1.0 -ErrorAction stop | Out-Null
Add-WindowsCapability -Online -Name Language.Fonts.Jpan~~~und-JPAN~0.0.1.0 -ErrorAction stop | Out-Null
Add-WindowsCapability -Online -Name Language.Handwriting~~~ja-JP~0.0.1.0 -ErrorAction stop | Out-Null
Add-WindowsCapability -Online -Name Language.OCR~~~ja-JP~0.0.1.0 -ErrorAction stop | Out-Null
Add-WindowsCapability -Online -Name Language.Speech~~~ja-JP~0.0.1.0 -ErrorAction stop | Out-Null
Add-WindowsCapability -Online -Name Language.TextToSpeech~~~ja-JP~0.0.1.0 -ErrorAction stop | Out-Null
Set-WinUILanguageOverride ja-JP -ErrorAction stop | Out-Null
Set-Culture ja-JP
$mylang = New-WinUserLanguageList ja
Set-WinUserLanguageList $mylang -Force
Set-WinDefaultInputMethodOverride '0411:{03B5835F-F03C-411B-9CE2-AA23E1171E36}{A76C93D9-5523-4E90-AAFA-4DB112F9AC76}'
Set-WinSystemLocale ja-JP

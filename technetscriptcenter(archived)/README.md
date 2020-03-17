<b>My sample scripts (include archived scripts from technet script center).</b>

---------------------------------------
Search and Install updates for Server Core by PowerShell (for RS3 or later)<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/SearchandInstallUpdates.ps1">SearchandInstallUpdates.ps1</a>
---------------------------------------
Description

This PowerShell script (SearchAndInstallUpdates.ps1) for installing updates using the WindowsUpdateProvider module cmdlets from Windows 10 ver 1709 (RS3) or later. Especially it is assumed to be used in Windows Server 2019Server Core or Windows Server Semi-Annual Channel. (Only tested on Windows Server 2019 Server Core.)

Unlike Sconfig Utility (WUA_SearchDownloadInstall.vbs),  this script shows the download and installation progress.

You can use this script for Windows Update mannually on Windows 10 ver 1709 or later, or Windows Server 2019 with Desktop Experience too.

This script also outputs product name, os version, current os build (ex 17763.194), last check datetime, and last update datetime.

Note

Searching by WindowsUpdateProvider module will not detect cumulative updates on C release (3rd week release patch) and D release (4th week release patch).

Don't use this script with Windows Update Automatic Update configuraion (sconfig 5) -> A).

On Server Core, Get-WULastScanSuccessDate and/or Get-WULastInstallationDate may return the wrong datetime (1601/01/01 00:00:00 UTC). I do not know why. For Windows Server 2019 with Desktop Experience and Windows 10, I do not deletethe relevant code portion.

2019/1/25: This script detect Preview CU for .NET framework on RS5. If you don't want detect this preview CU, comment out 2 line under "# Search all applicable updates" and uncomment 2 line under "# Search for only recommendedupdates". This behaves the same as Sconfig 6 > R (Search for Recommended updates).

2019/1/25: If you got error "Start-WUScan: Scan hit error: @{PSComputerName=}.ReturnValue" on Windows 10, try  "Search for recommended updates" change. 

Output sample

PS:\work> .\SearchAndInstallUpdate.ps1<br />
Produc Name:<br />
Windows Server 2019 Standard<br />
OS Version:<br />
1809<br />
Current OS Build:<br />
17763.107<br />
Last Check date:<br />
Sunday, December 31, 1600 4:00:00:PM<br />
Last Installation date:<br />
Sunday, December 31, 1600 4:00:00 PM<br />
Searching for all applicable udpates...<br />
2 updates were found.<br />
1) 2018-12 Cumulative Update for Windows Server 2019 (1809) for x64-based Systems (KB4471332)<br />
2) 2018-12 Cumulative Update for .NET Framework 3.5 and 4.7.2 for Windows Server 2019 for x64 (KB4470502)<br />
(A)ll update, (N)o update or Enter the number of the update to download and install? (A/N/#) : a<br />
Installing all updatres...<br />
Update ( 1 of 2): 2018-12 Cumulative Update for Windows Server 2019 (1809) for x64-based Systems (KB4471332)<br />
Installation Result: Failed with errors.<br />
Update ( 2 of 2): 2018-12 Cumulative Update for .NET Framework 3.5 and 4.7.2 for Windows Server 2019 for x64 (KB4470502)<br />
Installation Result: Succeeded<br />
A restart is required to complete Windows Updates. Restart now? (y/n) : n<br />
You need to restart later<br />
C:\Work>

---------------------------------------
PowerShell script for checking HTTP (S) response<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/checkurl.ps1">checkurl.ps1</a>
---------------------------------------
Description

This powershell script (checkurl.ps1) for checking response from specified HTTP(S) URL. 
This script uses Invoke-WebRequest available in PowerShell 3.0+.

Usage

.\checkurl.ps1 https://www.microsoft.com/

Output samples

PS C:\> .\checkurl.ps1 https://www.microsoft.com/<br />
OK: 200<br />
PS C:\> .\checkurl.ps1 https://www.microsoft.com/dummy<br />
Invoke-WebResuest Error: The remote server returned an error: (404)

---------------------------------------
Text-based Event Viewer<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/eventvcui.vbs">eventvcui.vbs</a><br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/eventvcui_en.vbs">eventvcui_en.vbs</a>  
---------------------------------------
Description

This script uses WMI class Win32_NTLogEvent. It referred to the following two sample codes.

http://blogs.technet.com/b/heyscriptingguy/archive/2006/01/31/how-can-i-retrieve-information-about-the-latest-event-added-to-an-event-log.aspx

Usage

cscript eventvcui.vbs<br />
your command prompt window size must be 80 char x 25 lines.

Example

Event Viewer CUI<br />
-----------------------------------------------------------------------------<br />
<br />
   0 Application<br />
    1 Security<br />
    2 System<br />
    3 HardwareEvents<br />
    4 Internet Explorer<br />
    5 Key Management Service<br />
    6 Media Center<br />
    7 OAlerts<br />
    8 Windows PowerShell<br />

<br />
<br />
<br />
<br />
------------------------------------------------------------------------------<br />
Enter No.(Q: Exit):<br />

Event Viewer: Application  20433 events<br />
------------------------------------------------------------------------------<br />
Record No. Level      Date       Time     Event ID Source<br />
20433      Infomation 10/21/2010 07:31:04     1003 Office Software Protectio..<br />
20432      Infomation 10/21/2010 07:31:04     1003 Office Software Protectio..<br />
20431      Infomation 10/21/2010 07:31:03     1003 Office Software Protectio..<br />
20430      Infomation 10/21/2010 07:31:03     1003 Office Software Protectio..<br />
20429      Infomation 10/21/2010 07:31:02     1003 Office Software Protectio..<br />
20428      Warning    10/21/2010 07:23:33       64 Microsoft-Windows-Certifi..<br />
20427      Success    10/21/2010 07:23:33       64 Microsoft-Windows-Certifi..<br />
20426      Success    10/21/2010 07:23:33       65 Microsoft-Windows-Certifi..<br />
20425      Success    10/21/2010 06:20:20      258 Microsoft-Windows-Defrag<br />
20424      Infomation 10/21/2010 06:07:31     8224 VSS<br />
20423      Error      10/21/2010 05:59:54       35 SideBySide<br />
20422      Error      10/21/2010 05:59:31       63 SideBySide<br />
20421      Success    10/21/2010 05:59:05      258 Microsoft-Windows-Defrag<br />
20420      Success    10/21/2010 05:58:56      258 Microsoft-Windows-Defrag<br />
20419      Success    10/21/2010 05:57:47      258 Microsoft-Windows-Defrag<br />
20418      Infomation 10/21/2010 03:11:31       38 Outlook<br />
20417      Infomation 10/21/2010 03:11:04       38 Outlook<br />
20416      Infomation 10/21/2010 03:10:55       30 Outlook<br />
------------------------------------------------------------------------------<br />
 Back(B) | Next(N) | Refresh(R) | Detail(Record No.) | Top(T) | Quit(Q) ：<br />

Limitation

Windows Server 2008 RTM and Windows Vista RTM version are not supported. Because Win32_NTLogEvent of these versions is amusing. The order of the record is reverse.

---------------------------------------
Determine which .NET Framework versions are installed by PowerShell<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/get-dotnetver.ps1">get-dotnetver.ps1</a>
---------------------------------------
Description

Based on the following document, it is a PowerShell script to obtain version information of .NET Framework installed on the local Windows PC.

Reference
 How to: Determine which .NET Framework versions are installed
 https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which- versions-are-installed



Output

PS C:\work\> .\get-dotnetver.ps1<br />
*** .NET Framework 4.5 or later ***<br />
.NET Framework 4.7.2 installed on Windows 10 April 2018 Update<br />
*** .NET Framework 2-4 ***<br />
.NET Framework 2 ( 2.0.50727.4927 )<br />
.NET Framework 3.0 ( 3.0.30729.4926 )<br />
.NET Framework 3.5 ( 3.5.30729.4926 )<br />
.NET Framework 4 ( Client 4.7.03056 /Full 4.7.03056 )<br />

---------------------------------------
Get version and update channel from local installed Office 365 (for 2016/2019)<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/get-o365ver.ps1">get-o365ver.ps1</a>
---------------------------------------
Description

Get version (build number) and update channel (monthly,semi-annual, semi-annual targeted) from local Office 365 Client (Click to Run) .

Output

PS C:\Work> .\get-o365ver.ps1<br />
Office 365 (C2R) Current Version:  16.0.8431.2153<br />
Office 365 Update Channel (Local Setting):  Semi-Annual Channel<br />
Office 365 Update Channel (Policy Setting):  Semi-Annual Channel<br />
PS C:\Work>

---------------------------------------
Show Windows Update History by PowerShell<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/get-windowsupdatehistory.ps1">get-windowsupdatehistory.ps1</a>
---------------------------------------
Description

This PowerShell sample script  (get-windowsupdatehistory.ps1) for showing Windows Update History include installation result and error code and pending reboot. This script was mainly created for Server Core install. This script uses WUA API(  https://docs.microsoft.com/en-us/windows/desktop/Wua_Sdk/portal-client ).

Output sample

PS C:\work> .\Get-WindowsUpdateHistory.ps1<br />
2019/03/12 10:24 UTC 2019-03 Coumulative update for ... (KB4489889) - Pending Reboot<br />
...<br />
2019/03/06 12:49 UTC 2019-02 Cuoumulative update for ... (KB4482887) - Successfully installed<br />
...<br />
2019/03/06 12:20 UTC 9MZ95KL8MROL-Microsoft.ScreenSketch - Failed to install (Error: 80240034 )<br />
...<br />

---------------------------------------
Get Windows Update Settings from Windows 10 registry<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/get-wusettings.ps1">get-wusettings.ps1</a><br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/get-wusettingsj.ps1">get-wusettingsj.ps1</a>
---------------------------------------
Description

This powershell script collects Windows Update related settings for Windows 10 ver 1703 or higher and Windows Server 2016 or higher from local registory. the following settings and their validity are shown.

- Automatic Update configuration
- Windows Server Update Services (WSUS) client configuration
- Windows Update for Business (WUfB) local configuration by Settings app
- Possibility of mnaged device by Microsofft Endpoint Configuration Manager (formerly System Center configuration Manager)

.\get-wusettings.ps1<br />
(get-wusettingsj.ps1 for Japanese environment.)

Output sample

C:\scripts> .\get-wusettings.ps1<br />
Windows Update (Policies): Not Configured (Windows 10 default is automatic)<br />
WSUS Client: Not Configured<br />
Windows Update for Business (Settins app): Enabled<br />
After a feature update is released, defer receiving it for this days: 30<br />
After a quality update is released, defer receiving it for this days: 7<br />
 ( These settings are in Settings > Update & Security > Windows Update > Advanced Options > Chose when updates are installed. (Hidden in WSUS client))<br />
Windows Update for Business (Policies): Not Configured<br />
(Note: This script does not support the identification of devices managed by Microsoft Intune or other update tools.)<br />
C:\scripts><br />

---------------------------------------
Install and update SysinternalsSuite by PowerShell<br />
<a href="https://github.com/yamauchikazu/public/blob/master/technetscriptcenter(archived)/installsysinternalssuite.ps1">installsysinternalssuite.ps1</a>
---------------------------------------
Description

PowerShell script to install Windows Sysinternals utilities from live.sysinternals.com.
Install Windows Sysinternals utilities from http://live.sysinternals.com/files/sysinternalssuite.zip.
If new installation, add PATH variable to System wide.
If utilities has already been installed, replace latest one or not.
Default installation path is "C:\Program Files\SysinternalsSuite". Change $InstallTo value to use another path.

You must have administrative rights to use this script. If you have not, install manually 1st in user's path and set PATH user env. Next time, you can use installsysinternalssuite.ps1 to update baninary in your user's path (set that path to $installto) 

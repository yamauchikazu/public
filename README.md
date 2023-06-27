<b>My sample scripts</b>

<a href="https://github.com/yamauchikazu/public/tree/master/technetscriptcenter(archived)">technetscriptcenter(archived)</a> - archived my sample scripts from technet script center. Microsoft plans to retire Technet Gallery (including script center) in June 2020.

<b>Get Microsoft 365 apps or Microsoft Office various version information. </b></br>
.\get-m365ver.ps1   build and channel </br>
Microsoft 365 Apps (C2R) Current Version:  16.0.16327.20324
  Update Channel (Local Setting):   Semi-Annual Enterprise Channel (Preview)
  Update Channel (Policy Setting):  Monthly Enterprise Channel *
.\get-m365ver2.ps1  productname, buil and bitness</br>
Microsoft 365 Apps for enterprise - ja-jp (Build  16.0.16327.20324) 64-bit
.\get-m365ver3.ps1 </br>
Version 2304 (Build 16327.20324) 64-bit </br>

<b>Run Scheduled Task sample scripts </b></br>
runtask.ps1 Run Ready or Queued state task and wait for complete from cmdline. If Disabled state task, do not anything.</br>
Usage:   .\runtask.ps1 "taskname" "taskpath" </br>
Example: .\runtask.ps1 "SilentCleanup" "\Microsoft\Windows\DiskCleanup\\" </br>

<b>Checking process status </b></br>
Monitor the specified process until it terminates.</br>
Usage:   .\checkproc.ps1 "proccessname" </br>
Example: .\checkproc.ps1 cleanmgr </br>

<b>Windows Update Agent API sample scripts </b></br>
windowsupdate.vbs  : search and install all available updates <b>interactively</b>.</br>
windowsupdate.ps1  : search and install available updates <b>automatically.</b>(for PowerShell）</br>
windowsupdatej.vbs : search and install all available updates interactively. (all message in japanese) </br>
windowsselectiveupdate.vbs  : search and install individual Update or all available updates interactively.</br>
windowsselectiveupdatej.vbs : search and install individual Update or all available updates interactively. (all message in japanese) </br></br>

Reference: </br>
Windows Update Agent API</br>
<a href="https://docs.microsoft.com/en-us/windows/win32/wua_sdk/portal-client">https://docs.microsoft.com/en-us/windows/win32/wua_sdk/portal-client</a>

<b>Get versions of Windows, Edge, and Microsoft 365 Apps </b></br>
See <a href="https://atmarkit.itmedia.co.jp/ait/articles/2108/17/news005.html">https://atmarkit.itmedia.co.jp/ait/articles/2108/17/news005.html</a>



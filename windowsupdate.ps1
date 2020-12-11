# Windows Update Agent API
# https://docs.microsoft.com/en-us/windows/win32/wua_sdk/portal-client

Write-Host "--- Running Windows Update ---"
Write-Host "Searching for updates..."
$updateSession = new-object -com "Microsoft.Update.Session"
$updateSearcher = $updateSession.CreateupdateSearcher()
#$searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software' and AutoSelectOnWebSites=1")
$searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software'")
Write-Host "List of applicable items on the machine:"
if ($searchResult.Updates.Count -eq 0) {
  Write-Host "There are no applicable updates."
}
else
{
  $downloadReq = $False
  $i = 0
  foreach ($update in $searchResult.Updates){
    $i++
    if ( $update.IsDownloaded ) {
      Write-Host $i">" $update.Title "(downloaded)"
    }
    else
    {
      $downloadReq = $true
      Write-Host $i">" $update.Title "(not downloaded, size" $update.MinDownloadSize "-" $update.MaxDownloadSize ")"
    }
  }
  if ( $downloadReq ) {
    Write-Host "Creating collection of updates to download..."
    $updatesToDownload = new-object -com "Microsoft.Update.UpdateColl"
    foreach ($update in $searchResult.Updates){
      $updatesToDownload.Add($update) | out-null
    }
    Write-Host "Downloading updates..."
    $downloader = $updateSession.CreateUpdateDownloader() 
    $downloader.Updates = $updatesToDownload
    $downloader.Download()
    Write-Host "List of downloaded updates:"
    $i = 0
    foreach ($update in $searchResult.Updates){
      $i++
      if ( $update.IsDownloaded ) {
        Write-Host $i">" $update.Title "(downloaded)"
      }
      else
      {
        Write-Host $i">" $update.Title "(not downloaded)"
      }
    }
  }
  else
  {
    Write-Host "All updates are already downloaded."
  }
  $updatesToInstall = new-object -com "Microsoft.Update.UpdateColl"
  Write-Host "Creating collection of downloaded updates to install..." 
  foreach ($update in $searchResult.Updates){
    if ( $update.IsDownloaded ) {
      $updatesToInstall.Add($update) | out-null
    }
  }
  if ( $updatesToInstall.Count -eq 0 ) {
    Write-Host "Not ready for installation."
  }
  else
  {
    Write-Host "Installing" $updatesToInstall.Count "updates..."
    $installer = $updateSession.CreateUpdateInstaller()
    $installer.Updates = $updatesToInstall
    $installationResult = $installer.Install()
    if ( $installationResult.ResultCode -eq 2 ) {
      Write-Host "All updates installed successfully."
    }
    else 
    {
      Write-Host "Some updates could not installed."
    }
    if ( $installationResult.RebootRequired ) {
      Write-Host "One or more updates are requiring reboot."
      Write-Host "Reboot system now !!"
      shutdown.exe /t 0 /r
    }
    else 
    {
      Write-Host "Finished. Reboot are not required."
    }
  }
}

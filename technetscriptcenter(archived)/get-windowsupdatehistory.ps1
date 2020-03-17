$objSession = new-object -com "Microsoft.Update.Session"
$objSearcher = $objSession.CreateupdateSearcher()
$intCount = $objSearcher.GetTotalHistoryCount()
$colHistory = $objSearcher.QueryHistory(0, $intCount)
foreach ($objHistory in $colHistory)
{
  if ($objHistory.HResult -eq 0) {
    Write-Host ($objHistory.Date).ToString("yyyy/MM/dd hh:mm UTC") $objHistory.Title "- Successfully installed"
  } elseif ($objHistory.HResult -eq -2145116140) {
    Write-Host ($objHistory.Date).ToString("yyyy/MM/dd hh:mm UTC") $objHistory.Title "- Pending Reboot"
  } else {
    # Report errors for the past month
    if (($objHistory.Date).AddMonths(1) -gt (Get-Date)) {
      Write-Host ($objHistory.Date).ToString("yyyy/MM/dd hh:mm UTC") $objHistory.Title "- Failed to install (Error:"$objHistory.HResult.ToString("X8")")"
    }
  }
}
param($target)
while(1) {
    $procid = (Get-Process -ProcessName $target -ErrorAction SilentlyContinue).Id
    if ($procid.Length -eq 0) {
        Write-Host $target "is not running currently"
        break
    } else {
        Write-Host $target "(PID:"$procid") is alive"
    }
    Start-Sleep -seconds 1
}


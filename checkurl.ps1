param($targeturi)
# Using TLS 1.2 only for HTTPS
# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Using TLS 1.0/1.1/1.2 for HTTPS
[Net.ServicePointManager]::SecurityProtocol = @([Net.SecurityProtocolType]::Tls,[Net.SecurityProtocolType]::Tls11,[Net.SecurityProtocolType]::Tls12)
# Check PSVersion
if ($PSVersiontable.PSVersion.Major -lt 3) {
  Write-Host "To use this script, you need Windows PowerShell 3.0 or later."
  exit
}

if ($targeturi -eq $null) {
  Write-Host "Usage: .\checkurl.ps1 http(s)://..."
  exit
}
try {
  $httpstatuscode = (Invoke-WebRequest $targeturi).StatusCode
  if ($httpstatuscode -lt 400) {
    Write-Host "OK:"$httpstatuscode
  } else {
    # This block will never be processed.
    Write-Host "HTTP Error:"$httpstatuscode
  }
}
catch [System.Net.WebException]
{
    Write-Host "Invoke-WebRequest Error:"$error[0].Exception.Message
}

Get-AppxPackage -allusers -Name Microsoft.BingNews| Remove-AppxPackage -AllUsers

$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (!(Test-Path $Search)) {
    New-Item $Search
}
If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0 
}
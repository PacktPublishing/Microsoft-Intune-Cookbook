# Install and import the Microsoft Graph Identity Directory Management module
Install-Module -Name Microsoft.Graph.Identity.DirectoryManagement -Repository PSGallery -Force -Scope CurrentUser
import-module Microsoft.Graph.Identity.DirectoryManagement

# Define the number of days to disable and remove devices
$daystodisable = 90
$daystoremove = 120

# Disable devices that have not logged on within the specified number of days
$dt = (Get-Date).AddDays(-$daystodisable)
$Devices = Get-MgDevice -All | Where-Object {$_.ApproximateLastLogonTimeStamp -le $dt}
foreach ($Device in $Devices) {
    $deviceid = $Device.Id
    Write-Host "Disabling device with ID: $deviceid"
    Update-MgDevice -DeviceId $deviceid -AccountEnabled $false
    Write-Host "Device disabled successfully"
}

# Delete disabled devices that have not logged on within the specified number of days
$dt = (Get-Date).AddDays(-$daystoremove)
$Devices = Get-MgDevice -All | Where-Object {($_.ApproximateLastLogonTimeStamp -le $dt) -and ($_.AccountEnabled -eq $false)}
foreach ($Device in $Devices) {
    $deviceid = $Device.Id
    Write-Host "Removing device with ID: $deviceid"
    Remove-MgDevice -DeviceId $deviceid
    Write-Host "Device removed successfully"
}
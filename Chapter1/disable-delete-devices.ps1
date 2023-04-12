Install-Module -Name Microsoft.Graph.Identity.DirectoryManagement -Repository PSGallery -Force -Scope CurrentUser
import-module Microsoft.Graph.Identity.DirectoryManagement

$daystodisable = 90
$daystoremove = 120

##Disable devices
$dt = (Get-Date).AddDays(-$daystodisable)
$Devices = Get-MgDevice -All | Where-Object {$_.ApproximateLastLogonTimeStamp -le $dt}
foreach ($Device in $Devices) {
    $deviceid = $Device.Id
    Update-MgDevice -DeviceId $deviceid -AccountEnabled $false
}


##Delete Disabled Devices
$dt = (Get-Date).AddDays(-$daystoremove)
$Devices = Get-MgDevice -All | Where-Object {($_.ApproximateLastLogonTimeStamp -le $dt) -and ($_.AccountEnabled -eq $false)}
foreach ($Device in $Devices) {
    $deviceid = $Device.Id
    Remove-MgDevice -DeviceId $deviceid
}


$deviceid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

$alldevices = (Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices" -OutputType PSObject).value
$selecteddevice = $alldevices | Out-GridView -PassThru -Title "Devices"
$deviceid = $selecteddevice.id

$url = "https://graph.microsoft.com/beta/deviceLocalCredentials/" + $deviceid + "?`$select=credentials"

$lapspassword = (Invoke-MgGraphRequest -Method GET -Uri $url -OutputType PSObject).credentials
$accountName = $lapspassword.accountName
$password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(($lapspassword.passwordBase64)))

write-host "Account Name: $accountName"
write-host "Account Password: $password"


$rotateurl = "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$deviceid/rotateLocalAdminPassword"
Invoke-MgGraphRequest -Method POST -Uri $rotateurl -OutputType PSObject
##Set the device ID
$deviceid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

function getallpagination () {
    <#
.SYNOPSIS
This function is used to grab all items from Graph API that are paginated
.DESCRIPTION
The function connects to the Graph API Interface and gets all items from the API that are paginated
.EXAMPLE
getallpagination -url "https://graph.microsoft.com/v1.0/groups"
 Returns all items
.NOTES
 NAME: getallpagination
#>
[cmdletbinding()]
    
param
(
    $url
)
    $response = (Invoke-MgGraphRequest -uri $url -Method Get -OutputType PSObject)
    $alloutput = $response.value
    
    $alloutputNextLink = $response."@odata.nextLink"
    
    while ($null -ne $alloutputNextLink) {
        $alloutputResponse = (Invoke-MGGraphRequest -Uri $alloutputNextLink -Method Get -outputType PSObject)
        $alloutputNextLink = $alloutputResponse."@odata.nextLink"
        $alloutput += $alloutputResponse.value
    }
    
    return $alloutput
    }

    ##Get all devices
    write-host "Getting all devices"
$alldevices = getallpagination -Url "https://graph.microsoft.com/beta/deviceManagement/managedDevices"
##Output devices
$selecteddevice = $alldevices | Out-GridView -PassThru -Title "Devices"
$deviceid = $selecteddevice.id
write-host "Device ID: $deviceid selected"

##Set the URL
$url = "https://graph.microsoft.com/beta/deviceLocalCredentials/" + $deviceid + "?`$select=credentials"

##Grab the passwords
write-host "Getting passwords"
$lapspassword = (Invoke-MgGraphRequest -Method GET -Uri $url -OutputType PSObject).credentials
$accountName = $lapspassword.accountName
$password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(($lapspassword.passwordBase64)))

write-host "Account Name: $accountName"
write-host "Account Password: $password"

##Rotate passwords
write-host "Rotating passwords"
$rotateurl = "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$deviceid/rotateLocalAdminPassword"
Invoke-MgGraphRequest -Method POST -Uri $rotateurl -OutputType PSObject
write-host "Passwords rotated"
##Set Variables
$name = "Surface Duo Config"
$description = "OEMConfig policy for Surface Duo"
$packageid = "com.microsoft.surface.config"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileAppConfigurations"

##Get App ID
write-host "Getting App ID"
$appid = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method GET -OutputType PSObject).value | Where-Object { $_.packageId -eq $packageid } | select-object -ExpandProperty id
write-host "App ID: $appid"

##Populate JSON for Wifi Config
$configjson = @"
{
    "kind": "androidenterprise#managedConfiguration",
    "productId": "app:com.microsoft.surface.config",
    "managedProperty": [
        {
            "key": "CAM",
            "valueBool": true
        },
        {
            "key": "MIC",
            "valueBool": true
        },
        {
            "key": "NFC",
            "valueBool": false
        },
        {
            "key": "WLAN",
            "valueBool": true
        },
        {
            "key": "BT",
            "valueBool": false
        }
    ]
}
"@

##Convert to Base64
$configjsonbase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($configjson))

##Populate JSON for Policy
$json = @"
{
	"@odata.type": "#microsoft.graph.androidManagedStoreAppConfiguration",
	"description": "$description",
	"displayName": "$name",
	"id": "00000000-0000-0000-0000-000000000000",
	"packageId": "com.microsoft.surface.config",
	"payloadJson": "$configjsonbase64",
	"roleScopeTagIds": [
		"0"
	],
	"targetedMobileApps": [
		"$appid"
	]
}
"@

##Create Policy
write-host "Creating Policy"
$oempolicy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy created successfully"

##Get ID
$oempolicyid= $oempolicy.id
write-host "Policy ID: $oempolicyid"

##Populate URL
$assignurl = "https://graph.microsoft.com/beta/deviceAppManagement/mobileAppConfigurations/$oempolicyid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"

##Populate JSON
$assignjson = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"
			}
		}
	]
}
"@

##Assign Policy
write-host "Assigning Policy"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Policy assigned successfully"
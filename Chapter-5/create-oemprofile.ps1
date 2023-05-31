$name = "Surface Duo Config"
$description = "OEMConfig policy for Surface Duo"
$packageid = "com.microsoft.surface.config"

$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileAppConfigurations"

$appid = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method GET -OutputType PSObject).value | Where-Object { $_.packageId -eq $packageid } | select-object -ExpandProperty id
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

$configjsonbase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($configjson))

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

$oempolicy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

$oempolicyid= $oempolicy.id

$assignurl = "https://graph.microsoft.com/beta/deviceAppManagement/mobileAppConfigurations/$oempolicyid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"

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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
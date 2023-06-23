$name = "iOS Device Restrictions"
$description = "Block App Store, iCloud and AirDrop"
$groupid = "0000000-0000-0000-0000-000000000000"

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

$json = @"
{
	"@odata.type": "#microsoft.graph.iosGeneralDeviceConfiguration",
	"airDropBlocked": true,
	"appStoreBlocked": true,
	"appsVisibilityListType": "none",
	"compliantAppListType": "none",
	"description": "$description",
	"displayName": "$name",
	"iCloudBlockBackup": true,
	"id": "00000000-0000-0000-0000-000000000000",
	"networkUsageRules": [
		{
			"cellularDataBlocked": false
		},
		{
			"cellularDataBlockWhenRoaming": false
		}
	],
	"passcodeRequiredType": "deviceDefault",
	"roleScopeTagIds": [
		"0"
	],
	"safariCookieSettings": "browserDefault"
}
"@

$newprofile = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
$profileid = $newprofile.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$profileid/assign"

$assignjson = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"
##Set Variables
$name = "iOS Device Restrictions"
$description = "Block App Store, iCloud and AirDrop"
$groupid = "0000000-0000-0000-0000-000000000000"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

##Populate JSON
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

##Create Profile
write-host "Creating Profile $name"
$newprofile = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Profile $name created"

##Get Profile ID
$profileid = $newprofile.id
write-host "Profile ID for $name is $profileid"

##Populate URL with Profile ID
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$profileid/assign"

##Populate JSON
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

##Assign Profile
write-host "Assigning $name"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"
write-host "Assigned $name"
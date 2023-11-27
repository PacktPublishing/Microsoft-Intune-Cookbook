##Set App Name
$appname = "GarageBand"

##Get App ID
write-host "Getting App ID"
$appid = ((Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method Get -ContentType "application/json" -OutputType PSObject).value | Where-Object {$_.'@odata.type' -eq '#microsoft.graph.macOSVppApp'} | Where-Object {$_.displayName -eq $appname}).id
write-host "App ID: $appid"

##Populate assignment URL
$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appid/assign"

##Set Install and Uninstall Group IDs
$installgroupid = "00000000-0000-0000-0000-000000000000"
$uninstallgroupid = "00000000-0000-0000-0000-000000000000"

##Populate assignment JSON
$json = @"
{
	"mobileAppAssignments": [
		{
			"@odata.type": "#microsoft.graph.mobileAppAssignment",
			"intent": "Required",
			"settings": {
				"@odata.type": "#microsoft.graph.macOsVppAppAssignmentSettings",
				"preventAutoAppUpdate": false,
				"preventManagedAppBackup": false,
				"uninstallOnDeviceRemoval": false,
				"useDeviceLicensing": true
			},
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$installgroupid"
			}
		},
		{
			"@odata.type": "#microsoft.graph.mobileAppAssignment",
			"intent": "Available",
			"settings": {
				"@odata.type": "#microsoft.graph.macOsVppAppAssignmentSettings",
				"preventAutoAppUpdate": false,
				"preventManagedAppBackup": false,
				"uninstallOnDeviceRemoval": false,
				"useDeviceLicensing": true
			},
			"target": {
				"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"
			}
		},
		{
			"@odata.type": "#microsoft.graph.mobileAppAssignment",
			"intent": "Uninstall",
			"settings": {
				"@odata.type": "#microsoft.graph.macOsVppAppAssignmentSettings",
				"useDeviceLicensing": true
			},
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$uninstallgroupid"
			}
		}
	]
}
"@

##Assign App
write-host "Assigning App"
Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json"
write-host "App Assigned"
$appname = "GarageBand"

$appid = ((Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method Get -ContentType "application/json" -OutputType PSObject).value | Where-Object {$_.'@odata.type' -eq '#microsoft.graph.macOSVppApp'} | Where-Object {$_.displayName -eq $appname}).id

$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appid/assign"

$installgroupid = "00000000-0000-0000-0000-000000000000"

$uninstallgroupid = "00000000-0000-0000-0000-000000000000"

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
				"groupId": "$unistallgroupid"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -Url $url -Method Post -Body $json -ContentType "application/json"
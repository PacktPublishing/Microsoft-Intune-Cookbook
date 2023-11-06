$appname = "Microsoft Authenticator"

$appid = ((Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method Get -ContentType "application/json" -OutputType PSObject).value | Where-Object {$_.'@odata.type' -eq '#microsoft.graph.iosVppApp'} | Where-Object {$_.displayName -eq $appname}).id

$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appid/assign"

$json = @"
{
	"mobileAppAssignments": [
		{
			"@odata.type": "#microsoft.graph.mobileAppAssignment",
			"intent": "Required",
			"settings": {
				"@odata.type": "#microsoft.graph.iosVppAppAssignmentSettings",
				"isRemovable": false,
				"preventAutoAppUpdate": false,
				"preventManagedAppBackup": true,
				"uninstallOnDeviceRemoval": true,
				"useDeviceLicensing": true,
				"vpnConfigurationId": null
			},
			"target": {
				"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json"
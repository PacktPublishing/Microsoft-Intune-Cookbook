##Set App Name
$appname = "Microsoft Authenticator"

##Get App ID
write-host "Getting App ID for $appname"
$appid = ((Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method Get -ContentType "application/json" -OutputType PSObject).value | Where-Object {$_.'@odata.type' -eq '#microsoft.graph.iosVppApp'} | Where-Object {$_.displayName -eq $appname}).id
write-host "App ID for $appname is $appid"

##Assign App
##Set URL
$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appid/assign"

##Set JSON
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

##Assign App
write-host "Assigning $appname"
Invoke-MgGraphRequest -Url $url -Method Post -Body $json -ContentType "application/json"
write-host "Assigned $appname"
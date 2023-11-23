# Define the name of the app
$appname = "Microsoft Authenticator"

# Fetch the app id from Microsoft Graph API
write-host "Fetching app id for $appname"
$appid = ((Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Method Get -ContentType "application/json" -OutputType PSObject).value | Where-Object {$_.'@odata.type' -eq '#microsoft.graph.iosVppApp'} | Where-Object {$_.displayName -eq $appname}).id

Write-Host "App ID: $appid"

# Construct the URL for assigning the app
$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appid/assign"

# Define the JSON body for the request
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

# Make the request to assign the app
write-host "Assigning $appname"
Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json"
write-host "App assigned successfully"
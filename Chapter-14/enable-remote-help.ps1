##Set Variables
$rolename = "Remote Help Admins"
$roledescription = "Access to Remote Help"

##Enable Remote Help
##Set URL for Enabling
$enableuri = "https://graph.microsoft.com/beta/deviceManagement/remoteAssistanceSettings"

##Populate JSON
$json = @"
{
	"allowSessionsToUnenrolledDevices": true,
	"blockChat": false,
	"remoteAssistanceState": "enabled"
}
"@

##Enable Remote Help
write-host "Enabling Remote Help"
Invoke-MgGraphRequest -Method PATCH -Uri $enableuri -Body $json
write-host "Remote Help Enabled"


##Create Role
##Set Role URL
$roleurl = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions"

##Populate Role JSON
$rolejson = @"
{
	"description": "$roledescription",
	"displayName": "$rolename",
	"id": "",
	"rolePermissions": [
		{
			"resourceActions": [
				{
					"allowedResourceActions": [
						"Microsoft.Intune_RemoteAssistanceApp_ViewScreen",
						"Microsoft.Intune_RemoteAssistanceApp_Elevation",
						"Microsoft.Intune_RemoteAssistanceApp_Unattended",
						"Microsoft.Intune_RemoteAssistanceApp_TakeFullControl"
					]
				}
			]
		}
	],
	"roleScopeTagIds": [
		"0"
	]
}
"@

##Create role
write-host "Creating role"
Invoke-MgGraphRequest -Method POST -Uri $roleurl -Body $rolejson -ContentType "application/json"
write-host "Role created"
$rolename = "Remote Help Admins"
$roledescription = "Access to Remote Help"

##Enable Remote Help

$enableuri = "https://graph.microsoft.com/beta/deviceManagement/remoteAssistanceSettings"
$json = @"
{
	"allowSessionsToUnenrolledDevices": true,
	"blockChat": false,
	"remoteAssistanceState": "enabled"
}
"@
Invoke-MgGraphRequest -Method PATCH -Uri $enableuri -Body $json


##Create Role
$roleurl = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions"
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

Invoke-MgGraphRequest -Method POST -Uri $roleurl -Body $rolejson -ContentType "application/json"
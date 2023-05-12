$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

$autopiloturl = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeploymentProfiles"

$json = @"
{
	"@odata.type": "#microsoft.graph.azureADWindowsAutopilotDeploymentProfile",
	"description": "User Driven\nNon Administrators\nSerial Device Name",
	"deviceNameTemplate": "%SERIAL%",
	"deviceType": "windowsPc",
	"displayName": "Autopilot Profile",
	"enableWhiteGlove": true,
	"extractHardwareHash": true,
	"hybridAzureADJoinSkipConnectivityCheck": false,
	"language": "en-GB",
	"outOfBoxExperienceSettings": {
		"deviceUsageType": "singleUser",
		"hideEscapeLink": true,
		"hideEULA": true,
		"hidePrivacySettings": true,
		"skipKeyboardSelectionPage": true,
		"userType": "standard"
	},
	"roleScopeTagIds": []
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $autopiloturl -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeploymentProfiles/$policyid/assignments"

$assignjson = @"
{
	"target": {
		"@odata.type": "#microsoft.graph.groupAssignmentTarget",
		"groupId": "$groupid"
	}
}
"@

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
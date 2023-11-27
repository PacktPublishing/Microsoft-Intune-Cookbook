##Set URL
$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/"

##Set Group ID
$groupid = "00000000-0000-0000-0000-000000000000"

##Set JSON

$json = @"
{
	"@odata.type": "#microsoft.graph.MacOSMicrosoftDefenderApp",
	"description": "Microsoft Defender for Endpoint is a unified platform for preventative protection, post-breach detection, automated investigation, and response. Microsoft Defender for Endpoint protects endpoints from cyber threats; detects advanced attacks and data breaches, automates security incidents and improves security posture.",
	"developer": "Microsoft",
	"displayName": "Microsoft Defender for Endpoint (macOS)",
	"informationUrl": "https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-atp/microsoft-defender-advanced-threat-protection​",
	"isFeatured": false,
	"largeIcon": {
		"type": "image/png",
		"value": "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"
	},
	"notes": "",
	"owner": "Microsoft",
	"privacyInformationUrl": "https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-atp/mac-privacy​",
	"publisher": "Microsoft",
	"roleScopeTagIds": []
}
"@

##Create Mobile App
write-host "Creating Mobile App"
$mobileapp = Invoke-MgGraphRequest -Url $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Mobile App Created"

##Get Mobile App ID
$mobileappid = $mobileapp.id
write-host "Mobile App ID: $mobileappid"

##Populate URL
$assignurl = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$mobileappid/assign"

##Populate JSON
$assignjson = @"
{
	"mobileAppAssignments": [
		{
			"@odata.type": "#microsoft.graph.mobileAppAssignment",
			"intent": "Required",
			"settings": null,
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}
"@

##Assign Mobile App
write-host "Assigning Mobile App"
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json"
write-host "Mobile App Assigned"
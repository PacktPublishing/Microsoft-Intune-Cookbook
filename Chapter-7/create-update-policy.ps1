$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

$name = "macOS Updates"

$description = "Managed updates on macOS devices"

$groupid = "000000-0000-0000-0000-000000000000"

$jsonimmediate = @"
{
	"@odata.type": "#microsoft.graph.macOSSoftwareUpdateConfiguration",
	"allOtherUpdateBehavior": "installLater",
	"configDataUpdateBehavior": "default",
	"criticalUpdateBehavior": "installASAP",
	"customUpdateTimeWindows": [],
	"description": "$description",
	"displayName": "$name",
	"firmwareUpdateBehavior": "default",
	"id": "",
	"maxUserDeferralsCount": 3,
	"priority": "low",
	"roleScopeTagIds": [
		"0"
	],
	"updateScheduleType": "alwaysUpdate",
	"updateTimeWindowUtcOffsetInMinutes": null
}
"@

$jsonwindow = @"
{
	"@odata.type": "#microsoft.graph.macOSSoftwareUpdateConfiguration",
	"allOtherUpdateBehavior": "installLater",
	"configDataUpdateBehavior": "default",
	"criticalUpdateBehavior": "installASAP",
	"customUpdateTimeWindows": [
		{
			"@odata.type": "#microsoft.graph.customUpdateTimeWindow",
			"endDay": "friday",
			"endTime": "18:00:00.0000000",
			"startDay": "monday",
			"startTime": "08:00:00.0000000"
		}
	],
	"description": "$description",
	"displayName": "$name",
	"firmwareUpdateBehavior": "default",
	"id": "",
	"maxUserDeferralsCount": 3,
	"priority": "low",
	"roleScopeTagIds": [
		"0"
	],
	"updateScheduleType": "updateDuringTimeWindows",
	"updateTimeWindowUtcOffsetInMinutes": 0
}
"@

$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $jsonimmediate -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

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

Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json"
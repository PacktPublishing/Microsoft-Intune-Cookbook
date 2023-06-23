$name = "iOS Update Policy"
$description = "Forces update to latest version on check-in"
$groupid = "00000000-0000-0000-0000-000000000000"

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

$json = @"
{
	"@odata.type": "#microsoft.graph.iosUpdateConfiguration",
	"activeHoursEnd": "00:00:00.0000000",
	"activeHoursStart": "00:00:00.0000000",
	"customUpdateTimeWindows": [],
	"description": "$description",
	"desiredOsVersion": null,
	"displayName": "$name",
	"id": "",
	"roleScopeTagIds": [
		"0"
	],
	"scheduledInstallDays": [],
	"updateScheduleType": "alwaysUpdate",
	"utcTimeOffsetInMinutes": null
}
"@

$jsonscheduled = @"
{
	"@odata.type": "#microsoft.graph.iosUpdateConfiguration",
	"activeHoursEnd": "00:00:00.0000000",
	"activeHoursStart": "00:00:00.0000000",
	"customUpdateTimeWindows": [
		{
			"@odata.type": "#microsoft.graph.customUpdateTimeWindow",
			"endDay": "friday",
			"endTime": "18:00:00.0000000",
			"startDay": "monday",
			"startTime": "07:00:00.0000000"
		}
	],
	"description": "$description",
	"desiredOsVersion": null,
	"displayName": "$name",
	"id": "",
	"roleScopeTagIds": [
		"0"
	],
	"scheduledInstallDays": [],
	"updateScheduleType": "updateDuringTimeWindows",
	"utcTimeOffsetInMinutes": 0
}
"@


$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

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

Invoke-MgGraphRequest -Uri $url -Method Post -Body $assignjson -ContentType "application/json"
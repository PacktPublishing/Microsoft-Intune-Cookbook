##Set Variables
$name = "iOS Update Policy"
$description = "Forces update to latest version on check-in"
$groupid = "00000000-0000-0000-0000-000000000000"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

##Populate JSON for policy
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

##Populate JSON for scheduled policy
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

##Create Policy
write-host "Creating Policy $name"
$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy $name created"

##Get Policy ID
$policyid = $policy.id
write-host "Policy ID for $name is $policyid"

##Populate URL with Policy ID
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

##Populate JSON
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

##Assign Policy
write-host "Assigning $name"
Invoke-MgGraphRequest -Uri $url -Method Post -Body $assignjson -ContentType "application/json"
write-host "Assigned $name"
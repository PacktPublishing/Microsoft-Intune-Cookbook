$name = "New device restriction limit"
$description = "Set to 10 devices"
$limit = 10
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations"
$json = @"
{
	"@odata.type": "#microsoft.graph.deviceEnrollmentLimitConfiguration",
	"description": "$description",
	"displayName": "$name",
	"limit": $limit,
	"roleScopeTagIds": [
		"0"
	]
}
"@

$restrictionpolicy = Invoke-MgGraphRequest -uri $url -Method POST -Body $json -ContentType "application/json" -OutputType PSObject
$policyid = $restrictionpolicy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid/assign"
$assignjson = @"
{
	"enrollmentConfigurationAssignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -uri $assignurl -Method POST -Body $assignjson -ContentType "application/json" -OutputType PSObject
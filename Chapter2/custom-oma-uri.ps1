$groupid = "00000000-0000-0000-0000-000000000000"
$name = "Skip User ESP"
$description = "Skips Enrollment Status Page Users section"
$omauri = "./Vendor/MSFT/DMClient/Provider/MS DM Server/FirstSyncStatus/SkipUserStatusPage"
$omavalue = "true"
##Value Type can be string, integer or boolean
$valuetype = "boolean"

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

##Switch on the valuetype
switch ($valuetype) {
    "boolean" {
        $policytype = "#microsoft.graph.omaSettingBoolean"
    }
    "string" {
        $policytype = "#microsoft.graph.omaSettingString"
    }
    "integer" {
        $policytype = "#microsoft.graph.omaSettingInteger"
    }
}


$json = @"
{
	"@odata.type": "#microsoft.graph.windows10CustomConfiguration",
	"description": "$description",
	"deviceManagementApplicabilityRuleOsVersion": null,
	"displayName": "$name",
	"id": "00000000-0000-0000-0000-000000000000",
	"omaSettings": [
		{
			"@odata.type": "$policytype",
			"description": "$description",
			"displayName": "$name",
			"omaUri": "$omauri",
			"value": "$omavalue"
		}
	],
	"roleScopeTagIds": [
		"0"
	]
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"
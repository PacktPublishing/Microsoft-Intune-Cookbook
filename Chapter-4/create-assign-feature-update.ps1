$groupid = "00000000-0000-0000-0000-000000000000"
$description = "Fixes machines on Windows 11 22H2"
$displayname = "Windows 11 22H2"

##List Available options
$allupdatesurl = "https://graph.microsoft.com/beta/deviceManagement/windowsUpdateCatalogItems/microsoft.graph.windowsFeatureUpdateCatalogItem"
$availablefeatures = (Invoke-MgGraphRequest -Uri $allupdatesurl -Method GET -OutputType PSObject).value
$latest = $availablefeatures | Out-GridView -PassThru

$selected = $latest.version

$createurl = "https://graph.microsoft.com/beta/deviceManagement/windowsFeatureUpdateProfiles"

$createjson = @"
{
	"description": "$description",
	"displayName": "$displayname",
	"featureUpdateVersion": "$selected",
	"roleScopeTagIds": [],
	"rolloutSettings": {
		"offerEndDateTimeInUTC": null,
		"offerIntervalInDays": null,
		"offerStartDateTimeInUTC": null
	}
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $createurl -Body $createjson -ContentType "application/json" -OutputType PSObject
$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/windowsFeatureUpdateProfiles/$policyid/assign"
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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
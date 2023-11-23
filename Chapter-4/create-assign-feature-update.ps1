##Set Variables
$groupid = "00000000-0000-0000-0000-000000000000"
$description = "Fixes machines on Windows 11 22H2"
$displayname = "Windows 11 22H2"

##List Available options
$allupdatesurl = "https://graph.microsoft.com/beta/deviceManagement/windowsUpdateCatalogItems/microsoft.graph.windowsFeatureUpdateCatalogItem"
write-host "Getting available updates, please wait..."
$availablefeatures = (Invoke-MgGraphRequest -Uri $allupdatesurl -Method GET -OutputType PSObject).value
##Output
$latest = $availablefeatures | Out-GridView -PassThru

$selected = $latest.version
write-host "Selected: $selected"

##Set URL
$createurl = "https://graph.microsoft.com/beta/deviceManagement/windowsFeatureUpdateProfiles"

##Populate JSON
write-host "Populating JSON"
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
write-host "JSON populated"

##Create Policy
write-host "Creating Policy"
$policy = Invoke-MgGraphRequest -Method POST -Uri $createurl -Body $createjson -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"
$policyid = $policy.id
write-host "Policy ID: $policyid"

##Assign Policy
write-host "Assigning Policy"
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
write-host "Policy Assigned"
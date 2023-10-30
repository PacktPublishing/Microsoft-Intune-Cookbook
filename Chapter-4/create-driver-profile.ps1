$name = "Driver Updates"
$description = "Driver Update Management"
##Driver Setting can be manual or automatic
$driversetting = "manual"
$groupid = "000000-0000-0000-0000-000000000000"
$url = "https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles"
$json = @"
{
	"approvalType": "$driversetting",
	"description": "$description",
	"displayName": "$name",
	"roleScopeTagIds": [
		"0"
	]
}
"@

$driverpolicy = Invoke-MgGraphRequest -Method POST -uri $url -body $json -ContentType "application/json" -OutputType PSObject

$policyid = $driverpolicy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles/$policyid/assign"

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

Invoke-MgGraphRequest -Method POST -uri $assignurl -body $assignjson -ContentType "application/json" -OutputType PSObject
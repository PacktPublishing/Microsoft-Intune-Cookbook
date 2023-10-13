$name = "Office-1"
$description = "Devices within Office 1"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$url = "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags"
$json = @"
{
	"description": "$description",
	"displayName": "$name"
}
"@

$scopetag = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
$scopetagid = $scopetag.id


$assignurl = "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags/$scopetagid/assign"
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
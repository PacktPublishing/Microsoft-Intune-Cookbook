$name = "ServiceDesk"
$description = "Able to view Bitlocker Keys, Rotate LAPS password, Sync and Reboot"
$admingroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$scopegroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$url = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions"

$allpermissions = (Invoke-MgGraphRequest -uri "https://graph.microsoft.com/beta/deviceManagement/resourceOperations" -Method GET -OutputType PSObject).value
$listpermissions = $allpermissions | Select-Object -Property id,resourceName,description | Out-GridView -Title "Select Permissions" -PassThru
$selectedpermissions = ($listpermissions | Select-Object -ExpandProperty id) | convertto-json
$json = @"
{
	"description": "$description",
	"displayName": "$name",
	"id": "",
	"rolePermissions": [
		{
			"resourceActions": [
				{
					"allowedResourceActions": $selectedpermissions
				}
			]
		}
	],
	"roleScopeTagIds": [
		"0"
	]
}
"@

$role = Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
$roleid = $role.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/roleAssignments"
$assignjson = @"
{
	"description": "$description",
	"displayName": "$name",
	"id": "",
	"members": [
		"$adminGroupId"
	],
	"resourceScopes": [
		"$scopeGroupId"
	],
	"roleDefinition@odata.bind": "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$roleId')"
}
"@
Invoke-MgGraphRequest -uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
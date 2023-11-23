##Set Variables
$name = "ServiceDesk"
$description = "Able to view Bitlocker Keys, Rotate LAPS password, Sync and Reboot"
$admingroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$scopegroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions"

##Get all permissions
write-host "Getting all permissions"
$allpermissions = (Invoke-MgGraphRequest -uri "https://graph.microsoft.com/beta/deviceManagement/resourceOperations" -Method GET -OutputType PSObject).value
##Select permissions
$listpermissions = $allpermissions | Select-Object -Property id,resourceName,description | Out-GridView -Title "Select Permissions" -PassThru
$selectedpermissions = ($listpermissions | Select-Object -ExpandProperty id) | convertto-json

##Populate JSON
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

##Create Role
write-host "Creating role"
$role = Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Role created"

##Get Role ID
$roleid = $role.id
write-host "Role ID: $roleid"

##Set URL for assigning role
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/roleAssignments"

##Populate JSON for assigning role
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

##Assign role
write-host "Assigning role"
Invoke-MgGraphRequest -uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Role assigned"
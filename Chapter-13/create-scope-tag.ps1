##Set Variables
$name = "Office-1"
$description = "Devices within Office 1"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags"

##Populate JSON
$json = @"
{
	"description": "$description",
	"displayName": "$name"
}
"@

##Create Scope Tag
write-host "Creating scope tag"
$scopetag = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Scope tag created"

##Get Scope Tag ID
$scopetagid = $scopetag.id
write-host "Scope Tag ID: $scopetagid"

##Set URL for assigning scope tag
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags/$scopetagid/assign"

##Populate JSON for assigning scope tag
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

##Assign Scope Tag
write-host "Assigning scope tag"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Scope tag assigned"
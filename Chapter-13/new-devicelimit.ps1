##Set Variables
$name = "New device restriction limit"
$description = "Set to 10 devices"
$limit = 10
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations"

##Populate JSON
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

##Create Restriction Policy
write-host "Creating Restriction Policy"
$restrictionpolicy = Invoke-MgGraphRequest -uri $url -Method POST -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Restriction Policy created"

##Get Restriction Policy ID
$policyid = $restrictionpolicy.id
write-host "Restriction Policy ID: $policyid"

##Set URL for assigning Restriction Policy
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid/assign"

##Populate JSON for assigning Restriction Policy
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

##Assign Restriction Policy
write-host "Assigning Restriction Policy"
Invoke-MgGraphRequest -uri $assignurl -Method POST -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Restriction Policy assigned"
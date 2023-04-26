$name = "Mozilla Firefox"
$description = "ADMX templates to configure Mozilla Firefox"
$groupid = "000000000000000000000000000"

##Create the policy
$url = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations"
$json = @"
{
	"description": "$description",
	"displayName": "$name",
	"roleScopeTagIds": [
		"0"
	]
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id
$updateuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$policyid')/updateDefinitionValues"

$updatejson = @"
{
	"added": [
		{
			"definition@odata.bind": "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('4559d627-680d-45a1-bab6-fb55e1dd29ff')",
			"enabled": true,
			"presentationValues": [
				{
					"@odata.type": "#microsoft.graph.groupPolicyPresentationValueText",
					"presentation@odata.bind": "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('4559d627-680d-45a1-bab6-fb55e1dd29ff')/presentations('33e27121-d4cb-482a-9d16-aefb1280f985')",
					"value": "homepage"
				}
			]
		},
		{
			"definition@odata.bind": "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('9ae710e1-415b-4d14-ac19-815bbd92f36b')",
			"enabled": true,
			"presentationValues": [
				{
					"@odata.type": "#microsoft.graph.groupPolicyPresentationValueText",
					"presentation@odata.bind": "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('9ae710e1-415b-4d14-ac19-815bbd92f36b')/presentations('ff95e89c-d49b-4585-8709-ff8f8a41ae67')",
					"value": "https://www.packtpub.com/"
				},
				{
					"@odata.type": "#microsoft.graph.groupPolicyPresentationValueBoolean",
					"presentation@odata.bind": "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('9ae710e1-415b-4d14-ac19-815bbd92f36b')/presentations('5bce352e-9dbe-42c7-a295-5708a45d18a9')",
					"value": true
				}
			]
		}
	],
	"deletedIds": [],
	"updated": []
}
"@

Invoke-MgGraphRequest -Method POST -Uri $updateuri -Body $updatejson -ContentType "application/json"

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$policyid')/assign"

$assignjson = @"
{
	"assignments": [
		{
			"id": "",
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}
"@

invoke-mggraphrequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"
$groupid = "00000000000000000000"

$uri = "https://graph.microsoft.com/beta/deviceManagement/templates/a8d6fa0e-1e66-455b-bb51-8ce0dde1559e/createInstance"

$json = @"

{
	"description": "Edge Baseline",
	"displayName": "Edge Baseline",
	"roleScopeTagIds": [
		"0"
	],
	"settingsDelta": [
	]
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignuri = "https://graph.microsoft.com/beta/deviceManagement/intents/$policyid/assign"

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

Invoke-MgGraphRequest -Method POST -Uri $assignuri -Body $assignjson -ContentType "application/json"
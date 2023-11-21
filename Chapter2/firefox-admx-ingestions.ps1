# Define the name, description, and group ID
$name = "Mozilla Firefox"
$description = "ADMX templates to configure Mozilla Firefox"
$groupid = "000000000000000000000000000"

Write-Host "Name, description, and group ID defined."

# Define the URL for creating the policy
$url = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations"

Write-Host "URL for creating the policy defined."

# Define the JSON body for the API request
$json = @"
{
    "description": "$description",
    "displayName": "$name",
    "roleScopeTagIds": [
        "0"
    ]
}
"@

Write-Host "JSON body for API request defined."

# Invoke the Microsoft Graph API request and store the response in the $policy variable
$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

Write-Host "API request invoked and response stored."

# Extract the policy ID from the response
$policyid = $policy.id

Write-Host "Policy ID extracted from response."

# Define the URL for updating the policy
$updateuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$policyid')/updateDefinitionValues"

Write-Host "URL for updating the policy defined."

##Update the JSON
write-host "Updating JSON"
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
write-host "JSON updated"

# Invoke the Microsoft Graph API request to update the policy
Invoke-MgGraphRequest -Method POST -Uri $updateuri -Body $updatejson -ContentType "application/json"

Write-Host "API request to update the policy invoked."

# Define the URL for assigning the policy
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$policyid')/assign"

Write-Host "Assignment URL defined."

# Define the JSON body for the assignment API request
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

Write-Host "JSON body for assignment defined."

# Invoke the assignment API request
invoke-mggraphrequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"

Write-Host "Assignment API request invoked."
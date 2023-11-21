# Define the group ID. This is likely a placeholder and should be replaced with a valid ID.
$groupid = "00000000000000000000"
Write-Output "Group ID: $groupid"

# Define the URL for the Microsoft Graph API endpoint for device management templates
$uri = "https://graph.microsoft.com/beta/deviceManagement/templates/a8d6fa0e-1e66-455b-bb51-8ce0dde1559e/createInstance"
Write-Output "URI: $uri"

# Define the JSON data for the request
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
Write-Output "JSON: $json"

# Invoke a POST request to the Microsoft Graph API with the JSON data
$policy = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $json -ContentType "application/json" -OutputType PSObject

# Extract the policy ID from the response
$policyid = $policy.id
Write-Output "Policy ID: $policyid"

# Define the URL for the assignment endpoint of the Microsoft Graph API
$assignuri = "https://graph.microsoft.com/beta/deviceManagement/intents/$policyid/assign"
Write-Output "Assignment URL: $assignuri"

# Define the JSON data for the assignment request
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
Write-Output "Assignment JSON: $assignjson"

# Invoke a POST request to the Microsoft Graph API with the assignment JSON data
Invoke-MgGraphRequest -Method POST -Uri $assignuri -Body $assignjson -ContentType "application/json"
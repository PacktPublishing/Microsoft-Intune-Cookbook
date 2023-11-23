# Define the name and description for the driver update profile
$name = "Driver Updates"
$description = "Driver Update Management"

# Define the driver setting, can be either 'manual' or 'automatic'
$driversetting = "manual"

# Define the group ID
$groupid = "000000-0000-0000-0000-000000000000"

# Define the URL for the Microsoft Graph API endpoint
$url = "https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles"

# Define the JSON payload for the API request
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

# Invoke the Microsoft Graph API request with the defined URL and JSON payload
write-host "creating policy"
$driverpolicy = Invoke-MgGraphRequest -Method POST -uri $url -body $json -ContentType "application/json" -OutputType PSObject
write-host "policy created"

# Extract the policy ID from the response
$policyid = $driverpolicy.id

# Define the URL for the assignment API endpoint
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles/$policyid/assign"

# Define the JSON payload for the assignment API request
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

# Invoke the Microsoft Graph API request with the assignment URL and JSON payload
write-host "assigning policy"
Invoke-MgGraphRequest -Method POST -uri $assignurl -body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "policy assigned"
# Define the group ID
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Define the URL for the Microsoft Graph API endpoint for Autopilot profiles
$autopiloturl = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeploymentProfiles"

# Define the JSON payload for the API request to create an Autopilot profile
$json = @"
{
    "@odata.type": "#microsoft.graph.azureADWindowsAutopilotDeploymentProfile",
    "description": "User Driven\nNon Administrators\nSerial Device Name",
    "deviceNameTemplate": "%SERIAL%",
    "deviceType": "windowsPc",
    "displayName": "Autopilot Profile",
    "enableWhiteGlove": true,
    "extractHardwareHash": true,
    "hybridAzureADJoinSkipConnectivityCheck": false,
    "language": "en-GB",
    "outOfBoxExperienceSettings": {
        "deviceUsageType": "singleUser",
        "hideEscapeLink": true,
        "hideEULA": true,
        "hidePrivacySettings": true,
        "skipKeyboardSelectionPage": true,
        "userType": "standard"
    },
    "roleScopeTagIds": []
}
"@

# Invoke the Microsoft Graph API request with the defined URL and JSON payload to create the Autopilot profile
write-host "creating policy"
$policy = Invoke-MgGraphRequest -Method POST -Uri $autopiloturl -Body $json -ContentType "application/json" -OutputType PSObject
write-host "policy created"

# Extract the policy ID from the response
$policyid = $policy.id

# Define the URL for the assignment API endpoint
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeploymentProfiles/$policyid/assignments"

# Define the JSON payload for the assignment API request
$assignjson = @"
{
    "target": {
        "@odata.type": "#microsoft.graph.groupAssignmentTarget",
        "groupId": "$groupid"
    }
}
"@

# Invoke the Microsoft Graph API request with the assignment URL and JSON payload to assign the Autopilot profile to a group
write-host "assigning policy"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "policy assigned"
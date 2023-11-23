# Define the group ID
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Define the URI for the Microsoft Graph API endpoint
$espuri = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations"

# Define the JSON payload for the API request
$espjson = @"
{
    "@odata.type": "#microsoft.graph.windows10EnrollmentCompletionPageConfiguration",
    "allowDeviceResetOnInstallFailure": true,
    "allowDeviceUseOnInstallFailure": false,
    "allowLogCollectionOnInstallFailure": true,
    "allowNonBlockingAppInstallation": true,
    "blockDeviceSetupRetryByUser": false,
    "customErrorMessage": "Please call IT support on xxx",
    "description": "120 minute time-out\nContinue on Error\nForce installation of Microsoft To Do",
    "disableUserStatusTrackingAfterFirstUser": true,
    "displayName": "Standard Enrollment",
    "id": "28aa4055-b08d-41bb-b030-8c1adef7fbed",
    "installProgressTimeoutInMinutes": 120,
    "installQualityUpdates": true,
    "roleScopeTagIds": [
        "0"
    ],
    "selectedMobileAppIds": [
        "2d7531e9-a16c-43a3-b65b-7f3c550b8a4c"
    ],
    "showInstallationProgress": true,
    "trackInstallProgressForAutopilotOnly": true
}
"@

# Output the group ID, URI, and JSON payload
Write-Host "Group ID: $groupid"
Write-Host "URI: $espuri"
Write-Host "JSON Payload: $espjson"

# Invoke the Microsoft Graph API request with the previously defined URI and JSON payload
write-host "creating policy"
$esp = Invoke-MgGraphRequest -Method POST -Uri $espuri -Body $espjson -OutputType PSObject -ContentType "application/json"
write-host "policy created"

# Extract the policy ID from the response
$policyid = $esp.id

# Define the URL for the assignment API endpoint
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid/assign"

# Define the JSON payload for the assignment API request
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

# Output the policy ID, assignment URL, and assignment JSON payload
Write-Host "Policy ID: $policyid"
Write-Host "Assignment URL: $assignurl"
Write-Host "Assignment JSON Payload: $assignjson"

# Invoke the Microsoft Graph API request with the assignment URL and JSON payload
write-host "assigning policy to group"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -OutputType PSObject -ContentType "application/json"
write-host "policy assigned to group"
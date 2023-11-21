# Define the group ID, name, description, OMA-URI, OMA value, and value type
$groupid = "00000000-0000-0000-0000-000000000000"
$name = "Skip User ESP"
$description = "Skips Enrollment Status Page Users section"
$omauri = "./Vendor/MSFT/DMClient/Provider/MS DM Server/FirstSyncStatus/SkipUserStatusPage"
$omavalue = "true"
##Value Type can be string, integer or boolean
$valuetype = "boolean"

Write-Host "Group ID, name, description, OMA-URI, OMA value, and value type defined."

# Define the URL for the Microsoft Graph API
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

Write-Host "URL defined."

# Switch on the value type to determine the policy type
switch ($valuetype) {
    "boolean" {
        $policytype = "#microsoft.graph.omaSettingBoolean"
    }
    "string" {
        $policytype = "#microsoft.graph.omaSettingString"
    }
    "integer" {
        $policytype = "#microsoft.graph.omaSettingInteger"
    }
}

Write-Host "Policy type determined based on value type."


# Define the JSON body for the API request
$json = @"
{
    "@odata.type": "#microsoft.graph.windows10CustomConfiguration",
    "description": "$description",
    "deviceManagementApplicabilityRuleOsVersion": null,
    "displayName": "$name",
    "id": "00000000-0000-0000-0000-000000000000",
    "omaSettings": [
        {
            "@odata.type": "$policytype",
            "description": "$description",
            "displayName": "$name",
            "omaUri": "$omauri",
            "value": "$omavalue"
        }
    ],
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

# Define the URL for assigning the policy
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

Write-Host "Assignment URL defined."

# Define the JSON body for the assignment API request
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

Write-Host "JSON body for assignment defined."

# Invoke the assignment API request
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"

Write-Host "Assignment API request invoked."
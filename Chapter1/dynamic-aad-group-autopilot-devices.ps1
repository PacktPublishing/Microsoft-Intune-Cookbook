# Define the group name and description
$groupname = "TestGroup123"
$groupdescription = "TestGroupDescription"

# Define the membership rule for devices with a physical ID containing "[ZTDID]"
# Note: We have single quotes around the rule because we are using double quotes in the rule
$membershiprule = '(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))'

# Define the group nickname by removing all spaces and special characters from the group name and converting to lowercase
$groupnickname = ($groupname -replace '[^a-zA-Z0-9]', '').ToLower()

# Define the URL for the Microsoft Graph API
$url = "https://graph.microsoft.com/beta/groups"

# Define the JSON for the group
$json = @"
{
    "description": "$groupdescription",
    "displayName": "$groupname",
    "groupTypes": [
        "DynamicMembership"
    ],
    "mailEnabled": false,
    "mailNickname": "$groupnickname",
    "membershipRule": $membershiprule,
    "membershipRuleProcessingState": "On",
    "securityEnabled": true
}
"@

# Send the request to the Microsoft Graph API
Write-Host "Sending request to Microsoft Graph API"
Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json"
Write-Host "Request sent successfully"
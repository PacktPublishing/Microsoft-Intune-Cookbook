# Define the group name and description
$groupname = "TestGroup123"
$groupdescription = "TestGroupDescription"

# We will use the group name as the mail nickname but remove all spaces and special characters and convert to lowercase
$groupnickname = ($groupname -replace '[^a-zA-Z0-9]', '').ToLower()

# Define the URI for creating a new group
$uri = "https://graph.microsoft.com/beta/groups/"

# Define the JSON for the new group
$json = @"
{
    "description": "$groupdescription",
    "displayName": "$groupname",
    "mailEnabled": false,
    "mailNickname": "$groupnickname",
    "securityEnabled": true
}
"@

# Send the new group details to Microsoft Graph
Write-Host "Creating new group"
Invoke-MgGraphRequest -Uri $uri -Method Post -Body $json -ContentType "application/json"
Write-Host "Group created successfully"
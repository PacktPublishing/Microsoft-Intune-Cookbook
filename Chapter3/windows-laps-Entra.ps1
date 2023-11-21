# Define the URL for the Microsoft Graph API endpoint for device registration policy
$checkuri = "https://graph.microsoft.com/beta/policies/deviceRegistrationPolicy"
Write-Output "Check URI: $checkuri"

# Invoke a GET request to the Microsoft Graph API to fetch the current policy
$currentpolicy = Invoke-MgGraphRequest -Method GET -Uri $checkuri -OutputType PSObject -ContentType "application/json"

# Enable the Local Admin Password (LAPS) feature in the policy
$currentpolicy.localAdminPassword.isEnabled = $true
Write-Output "LAPS Enabled: $($currentpolicy.localAdminPassword.isEnabled)"

# Convert the updated policy to JSON format
$policytojson = $currentpolicy | ConvertTo-Json
Write-Output "Policy JSON: $policytojson"

# Invoke a PUT request to the Microsoft Graph API to update the policy with the JSON data
Invoke-MgGraphRequest -Method PUT -Uri $checkuri -Body $policytojson -ContentType "application/json"
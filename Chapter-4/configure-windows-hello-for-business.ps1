# Get the policy ID for the Windows Hello for Business configuration
$policyid = ((Invoke-MgGraphRequest -Method GET -uri "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations" -OutputType PSObject).value | where-object '@odata.type' -eq "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration").id

# Output the policy ID
Write-Host "Policy ID: $policyid"

# Define the URL for the Microsoft Graph API endpoint for the specific policy
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid"

# Define the JSON payload for the API request to update the policy
$json = @"
{
    "@odata.type": "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration",
    "enhancedBiometricsState": "enabled",
    "pinLowercaseCharactersUsage": "allowed",
    "pinPreviousBlockCount": 3,
    "pinSpecialCharactersUsage": "allowed",
    "pinUppercaseCharactersUsage": "allowed",
    "securityDeviceRequired": true,
    "securityKeyForSignIn": "enabled",
    "state": "enabled"
}
"@

# Output the URL and JSON payload
Write-Host "URL: $url"
Write-Host "JSON Payload: $json"

# Invoke the Microsoft Graph API request with the defined URL and JSON payload to update the policy
write-host "Updating Policy"
Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Updated"
# Define the URL for the Microsoft Graph API
$url = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyMigrationReports/createMigrationReport"

Write-Host "URL defined."

# Define the file path
$filepath = ""

Write-Host "File path defined."

# Load the XML data from the file
$xml = [xml](Get-Content -Path "$filepath")

# Extract the policy name from the XML data
$policyname = $xml.gpo.name

Write-Host "XML data loaded and policy name extracted."

# Read all bytes from the file and convert to base64
$bytes = [System.IO.File]::ReadAllBytes($filepath)
$base64 = [System.Convert]::ToBase64String($bytes)

Write-Host "File contents converted to base64."

# Define the JSON body for the API request
$json = @"
{
    "groupPolicyObjectFile": {
        "content": "$base64",
        "ouDistinguishedName": "$policyname",
        "roleScopeTagIds": [
        ]
    }
}
"@

Write-Host "JSON body for API request defined."

# Invoke the Microsoft Graph API request
Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json"

Write-Host "API request invoked."
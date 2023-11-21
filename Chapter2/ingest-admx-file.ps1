# Define the paths to the ADMX and ADML files
$admxpath = "PATH TO ADMX FILE"
$admlpath = "PATH TO ADML FILE"

# Define the language
$language = "en-US"

# Define the URL for the Microsoft Graph API
$url = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyUploadedDefinitionFiles"

Write-Host "Paths, language, and URL defined."

# Get the filenames only from the path
$admxfile = Split-Path -Path $admxpath -Leaf
$admlfile = Split-Path -Path $admlpath -Leaf

Write-Host "Filenames extracted from paths."

# Get the file contents and convert to base64
$admxcontent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($admxpath))
$admlcontent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($admlpath))

Write-Host "File contents converted to base64."

# Define the JSON body for the API request
$json = @"
{
    "content": "$admxcontent",
    "defaultLanguageCode": "",
    "fileName": "$admxfile",
    "groupPolicyUploadedLanguageFiles": [
        {
            "content": "$admlcontent",
            "fileName": "$admlfile",
            "languageCode": "$language"
        }
    ]
}
"@

Write-Host "JSON body defined."

# Make the API request
invoke-mggraphrequest -Method POST -Uri $url -Body $json -ContentType "application/json"

Write-Host "API request sent."
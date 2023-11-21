##Set the Group ID
$groupid = "00000000000000000000"

# Initialize an empty array to hold the baseline objects
$baselines = @()

# Define the Edge Security Baseline object and add it to the array
$edgebaseline = [pscustomobject]@{
    id = "a8d6fa0e-1e66-455b-bb51-8ce0dde1559e"
    name = "Edge Security Baseline"
    description = "Edge Security Baseline"
}
$baselines += $edgebaseline
Write-Output "Added Edge Security Baseline to the array."

# Define the Windows Security Baseline object and add it to the array
$windowsbaseline = [pscustomobject]@{
    id = "a034ccd46-190c-4afc-adf1-ad7cc11262eb"
    name = "Windows Security Baseline"
    description = "Windows Security Baseline"
}
$baselines += $windowsbaseline
Write-Output "Added Windows Security Baseline to the array."

# Define the Windows 365 Security Baseline object and add it to the array
$windows365baseline = [pscustomobject]@{
    id = "cef15778-c3b9-4d53-a00a-042929f0aad0"
    name = "Windows 365 Security Baseline"
    description = "Windows 365 Security Baseline"
}
$baselines += $windows365baseline
Write-Output "Added Windows 365 Security Baseline to the array."

# Define the MDE Security Baseline object and add it to the array
$mdebaseline = [pscustomobject]@{
    id = "2209e067-9c8c-462e-9981-5a8c79165dcc"
    name = "MDE Security Baseline"
    description = "Microsoft Defender for Endpoint Security Baseline"
}
$baselines += $mdebaseline
Write-Output "Added MDE Security Baseline to the array."

# Iterate over each baseline in the array
foreach ($baseline in $baselines) {
    # Extract the policy name, description, and ID from the baseline
    $policyname = $baseline.name
    $policydescription = $baseline.description
    $basepolicyid = $baseline.id
    Write-Output "Processing baseline: $policyname"

    # Define the URL for the Microsoft Graph API endpoint for creating an instance of the baseline
    $uri = "https://graph.microsoft.com/beta/deviceManagement/templates/$basepolicyid/createInstance"
    Write-Output "URI: $uri"

##Populate JSON
write-host "Populating JSON"
$json = @"

{
	"description": "$policyname",
	"displayName": "$policydescription",
	"roleScopeTagIds": [
		"0"
	],
	"settingsDelta": [
	]
}
"@
write-host "JSON Populated"


##Create the policy
write-host "Creating policy"
$policy = Invoke-MgGraphRequest -Uri $url -Method POST -Body $json -OutputType PSObject -ContentType "application/json"
write-host "Policy Created"

# Extract the policy ID from the response
$policyid = $policy.id
Write-Output "Policy ID: $policyid"

# Define the URL for the assignment endpoint of the Microsoft Graph API
$assignuri = "https://graph.microsoft.com/beta/deviceManagement/intents/$policyid/assign"
Write-Output "Assignment URL: $assignurl"

# Define the JSON data for the assignment request
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
Write-Output "Assignment JSON: $assignjson"

# Invoke a POST request to the Microsoft Graph API with the assignment JSON data
Invoke-MgGraphRequest -Method POST -Uri $assignuri -Body $assignjson -ContentType "application/json"
}
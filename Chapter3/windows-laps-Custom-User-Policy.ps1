# Define the account name. This is currently empty and should be filled with a valid account name.
$accountname = ""
Write-Output "Account Name: $accountname"

# Define a function to generate a random password
function Get-RandomPassword {
    param (
        # The length of the password to generate
        [Parameter(Mandatory)]
        [int] $length,

        # The number of non-alphanumeric characters to include in the password
        [int] $amountOfNonAlphanumeric = 1
    )

    # Add the System.Web assembly to access the Membership class
    Add-Type -AssemblyName 'System.Web'

    # Generate and return a random password using the Membership class
    return [System.Web.Security.Membership]::GeneratePassword($length, $amountOfNonAlphanumeric)
}

# Generate a random password of length 20
$password = Get-RandomPassword -Length 20
Write-Output "Generated Password: $password"


##Create Custom Policy for lapsadmin user
##Set the URL
$customurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

##Set the JSON
write-host "Populating JSON"
$customjson = @"
{
	"@odata.type": "#microsoft.graph.windows10CustomConfiguration",
	"description": "Creates a new user to be used with LAPS",
	"displayName": "Windows-LAPS-User",
	"id": "00000000-0000-0000-0000-000000000000",
	"omaSettings": [
		{
			"@odata.type": "#microsoft.graph.omaSettingString",
			"description": "Create lapsadmin and set password",
			"displayName": "Create-User",
			"omaUri": "./Device/Vendor/MSFT/Accounts/Users/$accountname/Password",
			"value": "$password"
		},
		{
			"@odata.type": "#microsoft.graph.omaSettingInteger",
			"description": "Add to admins",
			"displayName": "Add-to-group",
			"omaUri": "./Device/Vendor/MSFT/Accounts/Users/$accountname/LocalUserGroup",
			"value": 2
		}
	],
	"roleScopeTagIds": [
		"0"
	]
}
"@
write-host "JSON Populated"

# Invoke a POST request to the Microsoft Graph API with the custom JSON data
$policy = Invoke-MgGraphRequest -Method POST -Uri $customurl -Body $customjson -OutputType PSObject -ContentType "application/json"

# Extract the policy ID from the response
$policyid = $policy.id
Write-Output "Policy ID: $policyid"

# Define the URL for the assignment endpoint of the Microsoft Graph API
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"
Write-Output "Assignment URL: $assignurl"

# Define the JSON data for the assignment request
$assignjson = @"
{
    "assignments": [
        {
            "target": {
                "@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"
            }
        }
    ]
}
"@
Write-Output "Assignment JSON: $assignjson"

# Invoke a POST request to the Microsoft Graph API with the assignment JSON data
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
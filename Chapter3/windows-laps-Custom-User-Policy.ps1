$accountname = ""

function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [int] $length,
        [int] $amountOfNonAlphanumeric = 1
    )
    Add-Type -AssemblyName 'System.Web'
    return [System.Web.Security.Membership]::GeneratePassword($length, $amountOfNonAlphanumeric)
}


$password = Get-RandomPassword -Length 20


##Create Custom Policy for lapsadmin user
$customurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

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

$policy = Invoke-MgGraphRequest -Method POST -Uri $customurl -Body $customjson -OutputType PSObject -ContentType "application/json"

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject


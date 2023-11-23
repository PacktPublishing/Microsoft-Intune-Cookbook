##Set URL
$url = "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies"

##Set Variables
$name = "Block Non-Compliant Devices"
$breakglassname = "Azure BreakGlass Account"

##Get Object ID for BreakGlass account
$breakglassid = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/users?`$filter=displayName eq '$breakglassname'" -Method Get -ContentType "application/json" -OutputType PSObject).value.Id
write-host "BreakGlass ID: $breakglassid"

##Set Role Name
$rolename = "Azure AD Joined Device Local Administrator"

##Get Role ID
$roleid = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/directoryRoles?`$filter=displayName eq '$rolename'" -Method Get -ContentType "application/json" -OutputType PSObject).value.Id
write-host "Role ID: $roleid"

##Populate JSON Body
$json = @"
{
	"conditions": {
		"applications": {
			"excludeApplications": [],
			"includeApplications": [
				"All"
			],
			"includeAuthenticationContextClassReferences": [],
			"includeUserActions": [],
			"networkAccess": null
		},
		"clientApplications": null,
		"clientAppTypes": [
			"all"
		],
		"clients": null,
		"devices": {
			"deviceFilter": {
				"mode": "include",
				"rule": "device.deviceOwnership -eq \"Company\""
			},
			"excludeDevices": [],
			"includeDevices": []
		},
		"locations": null,
		"platforms": null,
		"servicePrincipalRiskLevels": [],
		"signInRiskDetections": null,
		"signInRiskLevels": [],
		"times": null,
		"userRiskLevels": [],
		"users": {
			"excludeGroups": [],
			"excludeGuestsOrExternalUsers": null,
			"excludeRoles": [
				"$roleid"
			],
			"excludeUsers": [
				"$breakglassid"
			],
			"includeGroups": [],
			"includeGuestsOrExternalUsers": null,
			"includeRoles": [],
			"includeUsers": [
				"All"
			]
		}
	},
	"displayName": "$name",
	"grantControls": {
		"authenticationStrength": null,
		"builtInControls": [
			"compliantDevice"
		],
		"customAuthenticationFactors": [],
		"operator": "AND",
		"termsOfUse": []
	},
	"sessionControls": null,
	"state": "enabled"
}
"@

##Create Policy
write-host "Creating Policy"
Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"
##Set URL
$url = "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies"

##Set JSON
$json = @'
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
			"mobileAppsAndDesktopClients",
			"exchangeActiveSync",
			"other"
		],
		"clients": null,
		"devices": {
			"deviceFilter": {
				"mode": "exclude",
				"rule": "device.deviceOwnership -eq \"Company\""
			},
			"excludeDevices": [],
			"includeDevices": []
		},
		"locations": null,
		"platforms": {
			"excludePlatforms": [],
			"includePlatforms": [
				"windows"
			]
		},
		"servicePrincipalRiskLevels": [],
		"signInRiskDetections": null,
		"signInRiskLevels": [],
		"times": null,
		"userRiskLevels": [],
		"users": {
			"excludeGroups": [],
			"excludeGuestsOrExternalUsers": null,
			"excludeRoles": [],
			"excludeUsers": [],
			"includeGroups": [],
			"includeGuestsOrExternalUsers": null,
			"includeRoles": [],
			"includeUsers": [
				"All"
			]
		}
	},
	"displayName": "Windows BYOD Block Non-Compliant",
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
	"state": "disabled"
}
'@
##Create policy
write-host "Creating policy"
Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy created"


##Policy 2 - Set URL
$url = "https://graph.microsoft.com/beta/identity/conditionalAccess/policies"
##Policy 2 - Set JSON
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
			"browser"
		],
		"clients": null,
		"devices": {
			"deviceFilter": {
				"mode": "exclude",
				"rule": "device.deviceOwnership -eq \"Company\""
			},
			"excludeDevices": [],
			"includeDevices": []
		},
		"locations": null,
		"platforms": {
			"excludePlatforms": [],
			"includePlatforms": [
				"windows"
			]
		},
		"servicePrincipalRiskLevels": [],
		"signInRiskDetections": null,
		"signInRiskLevels": [],
		"times": null,
		"userRiskLevels": [],
		"users": {
			"excludeGroups": [],
			"excludeGuestsOrExternalUsers": null,
			"excludeRoles": [],
			"excludeUsers": [],
			"includeGroups": [],
			"includeGuestsOrExternalUsers": null,
			"includeRoles": [],
			"includeUsers": [
				"All"
			]
		}
	},
	"displayName": "Windows MAM - Require App Protection Policy",
	"grantControls": {
		"authenticationStrength": null,
		"builtInControls": [
			"compliantApplication"
		],
		"customAuthenticationFactors": [],
		"operator": "AND",
		"termsOfUse": []
	},
	"sessionControls": {
		"applicationEnforcedRestrictions": null,
		"cloudAppSecurity": {
			"cloudAppSecurityType": "blockDownloads",
			"isEnabled": true
		},
		"continuousAccessEvaluation": null,
		"disableResilienceDefaults": null,
		"networkAccessSecurity": null,
		"persistentBrowser": null,
		"secureSignInSession": null,
		"signInFrequency": null
	},
	"state": "disabled"
}
"@

##Policy 2 - Create policy
write-host "Creating policy"
Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy created"


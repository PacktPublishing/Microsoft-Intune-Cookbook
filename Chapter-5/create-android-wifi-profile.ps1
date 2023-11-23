##Set Variables
$name = "Android-Wi-Fi"
$description = "Android-Wi-Fi"
$groupid = "00000000-0000-0000-0000-000000000000"

##Set Wi-Fi Variables
$ssid = "mobilewifi"
$wpakey = "12345678"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

##Populate JSON
$json = @"
{
	"@odata.type": "#microsoft.graph.androidDeviceOwnerWiFiConfiguration",
	"authenticationMethod": null,
	"connectAutomatically": true,
	"connectWhenNetworkNameIsHidden": false,
	"description": "$description",
	"displayName": "$name",
	"eapType": null,
	"id": "00000000-0000-0000-0000-000000000000",
	"innerAuthenticationProtocolForEapTtls": null,
	"innerAuthenticationProtocolForPeap": "none",
	"networkName": "Android-Devices",
	"outerIdentityPrivacyTemporaryValue": null,
	"preSharedKey": "$wpakey",
	"proxyAutomaticConfigurationUrl": null,
	"proxyExclusionList": null,
	"proxyManualAddress": null,
	"proxyManualPort": null,
	"proxySettings": "none",
	"roleScopeTagIds": [
		"0"
	],
	"ssid": "$ssid",
	"trustedServerCertificateNames": [],
	"wiFiSecurityType": "wpaPersonal"
}
"@

##Create Profile
write-host "Creating Android Wi-Fi Profile"
$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Profile created successfully"

##Get ID
$policyid = $policy.id
write-host "Profile ID: $policyid"

##Populate URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

##Populate JSON
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

##Assign Profile
write-host "Assigning Profile"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Profile assigned successfully"
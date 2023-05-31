$name = "Android-Wi-Fi"
$description = "Android-Wi-Fi"
$groupid = "00000000-0000-0000-0000-000000000000"

$ssid = "mobilewifi"
$wpakey = "12345678"

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

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

$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject
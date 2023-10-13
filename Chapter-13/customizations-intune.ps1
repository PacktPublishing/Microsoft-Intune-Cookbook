

$companyname = "Test"
$contactTelephone = "1234"
$contactEmail = "help@help"
$contactname = "IT Helpdesk"
$contactWebsite = "https://microsoft.com"
$websitename = "Name"
$privacyUrl = "https://microsoft.com"
$additionalinfo = "More Here"

$imagepath = "PATH HERE"
$imagebase64 = [System.Convert]::ToBase64String((Get-Content $imagepath -Encoding Byte))

$customid = (Invoke-MgGraphRequest -uri "https://graph.microsoft.com/beta/deviceManagement/intuneBrandingProfiles?`$filter=isDefaultProfile eq true" -method GET -OutputType PSObject).value.id


$url = "https://graph.microsoft.com/beta/deviceManagement/intuneBrandingProfiles('$customid')"
$json = @"
{
	"companyPortalBlockedActions": [
		{
			"action": "remove",
			"ownerType": "company",
			"platform": "ios"
		},
		{
			"action": "reset",
			"ownerType": "company",
			"platform": "ios"
		},
		{
			"action": "remove",
			"ownerType": "company",
			"platform": "windows10andlater"
		},
		{
			"action": "reset",
			"ownerType": "company",
			"platform": "windows10andlater"
		}
	],
	"contactITEmailAddress": "$contactEmail",
	"contactITName": "$contactname",
	"contactITNotes": "$additionalinfo",
	"contactITPhoneNumber": "$contactTelephone",
	"customCanSeePrivacyMessage": "",
	"customCantSeePrivacyMessage": "",
	"disableDeviceCategorySelection": false,
	"displayName": "$companyname",
	"enrollmentAvailability": "availableWithPrompts",
	"onlineSupportSiteName": "$websitename",
	"onlineSupportSiteUrl": "$contactWebsite",
	"privacyUrl": "$privacyUrl",
	"roleScopeTagIds": [
		"0"
	],
	"showAzureADEnterpriseApps": false,
	"showConfigurationManagerApps": false,
	"showDisplayNameNextToLogo": false,
	"showLogo": true,
	"showOfficeWebApps": false,
	"themeColor": {
		"b": 32,
		"g": 31,
		"r": 35
	},
    "landingPageCustomizedImage": {
		"type": "image/png",
		"value": "$imagebase64"
	}
}
"@

Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
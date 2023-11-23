##Set Variables
$companyname = "Test"
$contactTelephone = "1234"
$contactEmail = "help@help"
$contactname = "IT Helpdesk"
$contactWebsite = "https://microsoft.com"
$websitename = "Name"
$privacyUrl = "https://microsoft.com"
$additionalinfo = "More Here"

##Set Image Path
$imagepath = "PATH HERE"

##Convert Image to Base64
$imagebase64 = [System.Convert]::ToBase64String((Get-Content $imagepath -Encoding Byte))

##Get Default Profile ID
write-host "Getting Default Profile ID"
$customid = (Invoke-MgGraphRequest -uri "https://graph.microsoft.com/beta/deviceManagement/intuneBrandingProfiles?`$filter=isDefaultProfile eq true" -method GET -OutputType PSObject).value.id

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/intuneBrandingProfiles('$customid')"

##Populate JSON
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

##Create Custom Profile
write-host "Creating Custom Profile"
Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Custom Profile Created"
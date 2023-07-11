$name = "macOS Enrollment"
$description = "Corporate Managed macOS Devices"

$settingsurl = "https://graph.microsoft.com/beta/deviceManagement/depOnboardingSettings/"

$tokenid = (Invoke-MgGraphRequest -Method GET -Uri $settingsurl -OutputType PSObject).value.id

$url = "https://graph.microsoft.com/beta/deviceManagement/depOnboardingSettings/$tokenid/enrollmentProfiles"

$json = @"
{
	"@odata.type": "#microsoft.graph.depMacOSEnrollmentProfile",
	"accessibilityScreenDisabled": true,
	"adminAccountFullName": "",
	"adminAccountUserName": "",
	"appleIdDisabled": true,
	"applePayDisabled": true,
	"autoUnlockWithWatchDisabled": true,
	"chooseYourLockScreenDisabled": true,
	"configurationEndpointUrl": "",
	"configurationWebUrl": true,
	"description": "$description",
	"diagnosticsDisabled": true,
	"displayName": "$name",
	"displayToneSetupDisabled": true,
	"dontAutoPopulatePrimaryAccountInfo": true,
	"enableAuthenticationViaCompanyPortal": false,
	"enabledSkipKeys": [
		"Location",
		"TOS",
		"Biometric",
		"Payment",
		"Siri",
		"Privacy",
		"AppleID",
		"DisplayTone",
		"ScreenTime",
		"Diagnostics",
		"Restore",
		"TermsOfAddress",
		"Registration",
		"FileVault",
		"iCloudDiagnostics",
		"iCloudStorage",
		"Appearance",
		"Accessibility",
		"UnlockWithWatch"
	],
	"enableRestrictEditing": false,
	"fileVaultDisabled": true,
	"hideAdminAccount": false,
	"iCloudDiagnosticsDisabled": true,
	"iCloudStorageDisabled": true,
	"id": "",
	"isMandatory": true,
	"locationDisabled": true,
	"primaryAccountFullName": "",
	"primaryAccountUserName": "",
	"privacyPaneDisabled": true,
	"profileRemovalDisabled": true,
	"registrationDisabled": true,
	"requireCompanyPortalOnSetupAssistantEnrolledDevices": false,
	"requiresUserAuthentication": true,
	"restoreBlocked": true,
	"screenTimeScreenDisabled": true,
	"setPrimarySetupAccountAsRegularUser": false,
	"siriDisabled": true,
	"skipPrimarySetupAccountCreation": true,
	"supervisedModeEnabled": true,
	"supportDepartment": "IT Dept",
	"supportPhoneNumber": "12345",
	"termsAndConditionsDisabled": true,
	"touchIdDisabled": true
}
"@

$macosprofile = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

$profileid = $macosprofile.id

$defaulturl = "https://graph.microsoft.com/beta/deviceManagement/depOnboardingSettings/$tokenid/enrollmentProfiles/$profileid/setDefaultProfile"

Invoke-MgGraphRequest -Method POST -Uri $defaulturl -ContentType "application/json" -OutputType PSObject
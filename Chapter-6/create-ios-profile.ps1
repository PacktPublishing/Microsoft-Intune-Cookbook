$name = "iOS Enrollment Profile"
$description = "iOS Enrollment Profile"

$settingsurl = "https://graph.microsoft.com/beta/deviceManagement/depOnboardingSettings/"

$tokenid = (Invoke-MgGraphRequest -Method GET -Uri $settingsurl -OutputType PSObject).value.id

$url = "https://graph.microsoft.com/beta/deviceManagement/depOnboardingSettings/$tokenid/enrollmentProfiles"

$json = @"
{
	"@odata.type": "#microsoft.graph.depIOSEnrollmentProfile",
	"appearanceScreenDisabled": true,
	"appleIdDisabled": true,
	"applePayDisabled": true,
	"awaitDeviceConfiguredConfirmation": true,
	"carrierActivationUrl": "",
	"companyPortalVppTokenId": "5f5a5226-27b9-45cc-8008-e4f7c9dd6c04",
	"configurationEndpointUrl": "",
	"configurationWebUrl": true,
	"description": "$description",
	"deviceNameTemplate": "{{DEVICETYPE}}-{{SERIAL}}",
	"deviceToDeviceMigrationDisabled": true,
	"diagnosticsDisabled": true,
	"displayName": "$name",
	"displayToneSetupDisabled": true,
	"enableAuthenticationViaCompanyPortal": false,
	"enabledSkipKeys": [
		"Location",
		"TOS",
		"Payment",
		"Siri",
		"Privacy",
		"AppleID",
		"DisplayTone",
		"ScreenTime",
		"Diagnostics",
		"Restore",
		"TermsOfAddress",
		"Android",
		"Zoom",
		"HomeButtonSensitivity",
		"iMessageAndFaceTime",
		"OnBoarding",
		"SIMSetup",
		"SoftwareUpdate",
		"WatchMigration",
		"Appearance",
		"Welcome",
		"DeviceToDeviceMigration",
		"RestoreCompleted",
		"UpdateCompleted"
	],
	"enableSharedIPad": false,
	"enableSingleAppEnrollmentMode": false,
	"forceTemporarySession": false,
	"homeButtonScreenDisabled": true,
	"id": "",
	"iMessageAndFaceTimeScreenDisabled": true,
	"isMandatory": true,
	"iTunesPairingMode": "disallow",
	"locationDisabled": true,
	"managementCertificates": [],
	"onBoardingScreenDisabled": true,
	"passCodeDisabled": false,
	"passcodeLockGracePeriodInSeconds": null,
	"privacyPaneDisabled": true,
	"profileRemovalDisabled": true,
	"requireCompanyPortalOnSetupAssistantEnrolledDevices": true,
	"requiresUserAuthentication": true,
	"restoreBlocked": true,
	"restoreCompletedScreenDisabled": true,
	"restoreFromAndroidDisabled": true,
	"screenTimeScreenDisabled": true,
	"sharedIPadMaximumUserCount": 0,
	"simSetupScreenDisabled": true,
	"siriDisabled": true,
	"softwareUpdateScreenDisabled": true,
	"supervisedModeEnabled": true,
	"supportDepartment": "IT Dept",
	"supportPhoneNumber": "12345",
	"temporarySessionTimeoutInSeconds": 0,
	"termsAndConditionsDisabled": true,
	"touchIdDisabled": false,
	"updateCompleteScreenDisabled": true,
	"userlessSharedAadModeEnabled": false,
	"userSessionTimeoutInSeconds": 0,
	"watchMigrationScreenDisabled": true,
	"welcomeScreenDisabled": true,
	"zoomDisabled": true
}
"@

$iosprofile = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

$profileid = $iosprofile.id


$defaulturl = "https://graph.microsoft.com/beta/deviceManagement/depOnboardingSettings/$tokenid/enrollmentProfiles/$profileid/setDefaultProfile"

Invoke-MgGraphRequest -Method POST -Uri $defaulturl -ContentType "application/json" -OutputType PSObject
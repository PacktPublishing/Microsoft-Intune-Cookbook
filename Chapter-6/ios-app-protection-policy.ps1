##Set Variables
$name = "iOS App Protection"
$description = "Protect Microsoft Apps"
$groupid = "00000000-0000-0000-0000-000000000000"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceAppManagement/iosManagedAppProtections"

##Populate JSON
$json = @"
{
	"@odata.type": "#microsoft.graph.iosManagedAppProtection",
	"allowedDataIngestionLocations": [
		"oneDriveForBusiness",
		"sharePoint",
		"camera",
		"photoLibrary"
	],
	"allowedDataStorageLocations": [
		"oneDriveForBusiness",
		"sharePoint"
	],
	"allowedInboundDataTransferSources": "managedApps",
	"allowedIosDeviceModels": "",
	"allowedOutboundClipboardSharingExceptionLength": 0,
	"allowedOutboundClipboardSharingLevel": "managedAppsWithPasteIn",
	"allowedOutboundDataTransferDestinations": "managedApps",
	"appActionIfAccountIsClockedOut": null,
	"appActionIfDeviceComplianceRequired": "block",
	"appActionIfIosDeviceModelNotAllowed": "block",
	"appActionIfMaximumPinRetriesExceeded": "block",
	"appActionIfUnableToAuthenticateUser": "block",
	"appDataEncryptionType": "whenDeviceLocked",
	"appGroupType": "allMicrosoftApps",
	"apps": [],
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"deviceAndAppManagementAssignmentFilterId": null,
				"deviceAndAppManagementAssignmentFilterType": "none",
				"groupId": "$groupid"
			}
		}
	],
	"blockAfterCompanyPortalUpdateDeferralInDays": 0,
	"blockDataIngestionIntoOrganizationDocuments": false,
	"contactSyncBlocked": true,
	"customBrowserDisplayName": "",
	"customBrowserPackageId": "",
	"customBrowserProtocol": "",
	"customDialerAppDisplayName": "",
	"customDialerAppPackageId": "",
	"customDialerAppProtocol": "",
	"dataBackupBlocked": false,
	"description": "$description",
	"deviceComplianceRequired": true,
	"dialerRestrictionLevel": "blocked",
	"disableAppPinIfDevicePinIsSet": false,
	"disableProtectionOfManagedOutboundOpenInData": false,
	"displayName": "$name",
	"exemptedAppPackages": [],
	"exemptedAppProtocols": [
		{
			"name": "Default",
			"value": "skype;app-settings;calshow;itms;itmss;itms-apps;itms-appss;itms-services;"
		}
	],
	"exemptedUniversalLinks": [
		"http://facetime.apple.com",
		"http://maps.apple.com",
		"https://facetime.apple.com",
		"https://maps.apple.com"
	],
	"faceIdBlocked": false,
	"filterOpenInToOnlyManagedApps": false,
	"fingerprintBlocked": false,
	"gracePeriodToBlockAppsDuringOffClockHours": null,
	"managedBrowser": "microsoftEdge",
	"managedBrowserToOpenLinksRequired": true,
	"managedUniversalLinks": [
		"http://*.appsplatform.us/*",
		"http://*.onedrive.com/*",
		"http://*.powerapps.cn/*",
		"http://*.powerapps.com/*",
		"http://*.powerapps.us/*",
		"http://*.powerbi.com/*",
		"http://*.service-now.com/*",
		"http://*.sharepoint-df.com/*",
		"http://*.sharepoint.com/*",
		"http://*.yammer.com/*",
		"http://*.zoom.us/*",
		"http://*collab.apps.mil/l/*",
		"http://*devspaces.skype.com/l/*",
		"http://*teams-fl.microsoft.com/l/*",
		"http://*teams.live.com/l/*",
		"http://*teams.microsoft.com/l/*",
		"http://*teams.microsoft.us/l/*",
		"http://app.powerbi.cn/*",
		"http://app.powerbi.de/*",
		"http://app.powerbigov.us/*",
		"http://msit.microsoftstream.com/video/*",
		"http://tasks.office.com/*",
		"http://to-do.microsoft.com/sharing*",
		"http://web.microsoftstream.com/video/*",
		"http://zoom.us/*",
		"https://*.appsplatform.us/*",
		"https://*.onedrive.com/*",
		"https://*.powerapps.cn/*",
		"https://*.powerapps.com/*",
		"https://*.powerapps.us/*",
		"https://*.powerbi.com/*",
		"https://*.service-now.com/*",
		"https://*.sharepoint-df.com/*",
		"https://*.sharepoint.com/*",
		"https://*.yammer.com/*",
		"https://*.zoom.us/*",
		"https://*collab.apps.mil/l/*",
		"https://*devspaces.skype.com/l/*",
		"https://*teams-fl.microsoft.com/l/*",
		"https://*teams.live.com/l/*",
		"https://*teams.microsoft.com/l/*",
		"https://*teams.microsoft.us/l/*",
		"https://app.powerbi.cn/*",
		"https://app.powerbi.de/*",
		"https://app.powerbigov.us/*",
		"https://msit.microsoftstream.com/video/*",
		"https://tasks.office.com/*",
		"https://to-do.microsoft.com/sharing*",
		"https://web.microsoftstream.com/video/*",
		"https://zoom.us/*"
	],
	"maximumAllowedDeviceThreatLevel": "notConfigured",
	"maximumPinRetries": 5,
	"maximumRequiredOsVersion": null,
	"maximumWarningOsVersion": null,
	"maximumWipeOsVersion": null,
	"minimumPinLength": 6,
	"minimumRequiredAppVersion": null,
	"minimumRequiredCompanyPortalVersion": null,
	"minimumRequiredOsVersion": null,
	"minimumRequiredSdkVersion": null,
	"minimumWarningAppVersion": null,
	"minimumWarningCompanyPortalVersion": null,
	"minimumWarningOsVersion": null,
	"minimumWarningSdkVersion": null,
	"minimumWipeAppVersion": null,
	"minimumWipeCompanyPortalVersion": null,
	"minimumWipeOsVersion": null,
	"minimumWipeSdkVersion": null,
	"mobileThreatDefensePartnerPriority": null,
	"mobileThreatDefenseRemediationAction": "block",
	"notificationRestriction": "allow",
	"organizationalCredentialsRequired": false,
	"periodBeforePinReset": "P0D",
	"periodBeforePinResetRequired": false,
	"periodOfflineBeforeAccessCheck": "PT720M",
	"periodOfflineBeforeWipeIsEnforced": "P90D",
	"periodOnlineBeforeAccessCheck": "PT30M",
	"pinCharacterSet": "numeric",
	"pinRequired": true,
	"pinRequiredInsteadOfBiometric": true,
	"pinRequiredInsteadOfBiometricTimeout": "PT30M",
	"previousPinBlockCount": 0,
	"printBlocked": true,
	"protectInboundDataFromUnknownSources": false,
	"roleScopeTagIds": [
		"0"
	],
	"saveAsBlocked": true,
	"shareWithBrowserVirtualSetting": "anyApp",
	"simplePinBlocked": true,
	"targetedAppManagementLevels": "unspecified",
	"thirdPartyKeyboardsBlocked": false,
	"warnAfterCompanyPortalUpdateDeferralInDays": 0,
	"wipeAfterCompanyPortalUpdateDeferralInDays": 0
}
"@

##Create Profile
Write-Host "Creating Profile $name"
Invoke-MgGraphRequest -Method POST -uri $url -Body $json -ContentType "application/json"
Write-Host "Profile $name created"
##Enable Connector
##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/mobileThreatDefenseConnectors"

##Set JSON
$threatjson = @"
{
	"windowsMobileApplicationManagementEnabled": true
}
"@

##Enable Connector
write-host "Enabling Connector"
Invoke-MgGraphRequest -Method POST -Uri $url -Body $threatjson -ContentType "application/json" -OutputType PSObject
write-host "Connector Enabled"

##Set Group ID
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Set URL for policy
$url = "https://graph.microsoft.com/beta/deviceAppManagement/windowsManagedAppProtections"

##Set JSON for policy
$json = @"
{
	"@odata.type": "#microsoft.graph.windowsManagedAppProtection",
	"allowedDataIngestionLocations": [
		"oneDriveForBusiness",
		"sharePoint",
		"camera",
		"photoLibrary"
	],
	"allowedDataStorageLocations": [],
	"allowedInboundDataTransferSources": "none",
	"allowedOutboundClipboardSharingExceptionLength": 0,
	"allowedOutboundClipboardSharingLevel": "none",
	"allowedOutboundDataTransferDestinations": "none",
	"appActionIfAccountIsClockedOut": null,
	"appActionIfDeviceComplianceRequired": "block",
	"appActionIfMaximumPinRetriesExceeded": "block",
	"appActionIfSamsungKnoxAttestationRequired": null,
	"appActionIfUnableToAuthenticateUser": "block",
	"apps": [
		{
			"mobileAppIdentifier": {
				"@odata.type": "#microsoft.graph.windowsAppIdentifier",
				"windowsAppId": "com.microsoft.edge"
			}
		}
	],
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
	"contactSyncBlocked": false,
	"customBrowserDisplayName": "",
	"customBrowserPackageId": "",
	"customBrowserProtocol": "",
	"customDialerAppDisplayName": "",
	"customDialerAppPackageId": "",
	"customDialerAppProtocol": "",
	"dataBackupBlocked": false,
	"description": "",
	"deviceComplianceRequired": false,
	"dialerRestrictionLevel": "allApps",
	"disableAppPinIfDevicePinIsSet": false,
	"displayName": "Windows MAM Edge Policy",
	"exemptedAppPackages": [],
	"exemptedAppProtocols": [
		{
			"name": "Default",
			"value": "skype;app-settings;calshow;itms;itmss;itms-apps;itms-appss;itms-services;"
		}
	],
	"fingerprintBlocked": false,
	"gracePeriodToBlockAppsDuringOffClockHours": null,
	"managedBrowser": "notConfigured",
	"managedBrowserToOpenLinksRequired": false,
	"maximumAllowedDeviceThreatLevel": "notConfigured",
	"maximumPinRetries": 5,
	"maximumRequiredOsVersion": null,
	"maximumWarningOsVersion": null,
	"maximumWipeOsVersion": null,
	"minimumPinLength": 4,
	"minimumRequiredAppVersion": null,
	"minimumRequiredCompanyPortalVersion": null,
	"minimumRequiredOsVersion": null,
	"minimumRequiredSdkVersion": null,
	"minimumWarningAppVersion": null,
	"minimumWarningCompanyPortalVersion": null,
	"minimumWarningOsVersion": null,
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
	"roleScopeTagIds": [
		"0"
	],
	"saveAsBlocked": false,
	"shareWithBrowserVirtualSetting": "anyApp",
	"simplePinBlocked": false,
	"targetedAppManagementLevels": "unspecified",
	"warnAfterCompanyPortalUpdateDeferralInDays": 0,
	"wipeAfterCompanyPortalUpdateDeferralInDays": 0
}
"@

##Deploy policy
write-host "Deploying policy"
Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy deployed"


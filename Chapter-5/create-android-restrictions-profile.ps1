##Set variables
$name = "Android Device Restrictions"
$description = "Android Device Restrictions"
$groupid = "00000000-0000-0000-0000-000000000000"
##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

##Populate JSON
$json = @"
{
	"@odata.type": "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration",
	"alreadySetPassword": "********",
	"appsRecommendSkippingFirstUseHints": true,
	"cellularBlockWiFiTethering": true,
	"certificateCredentialConfigurationDisabled": true,
	"crossProfilePoliciesAllowDataSharing": "notConfigured",
	"description": "$description",
	"displayName": "$name",
	"enrollmentProfile": "fullyManaged",
	"factoryResetBlocked": true,
	"googleAccountsBlocked": true,
	"id": "00000000-0000-0000-0000-000000000000",
	"kioskCustomizationStatusBar": "notConfigured",
	"kioskCustomizationSystemNavigation": "notConfigured",
	"kioskModeBluetoothConfigurationEnabled": null,
	"kioskModeDebugMenuEasyAccessEnabled": null,
	"kioskModeFlashlightConfigurationEnabled": null,
	"kioskModeFolderIcon": "notConfigured",
	"kioskModeIconSize": "notConfigured",
	"kioskModeManagedHomeScreenSignInEnabled": null,
	"kioskModeManagedSettingsEntryDisabled": null,
	"kioskModeMediaVolumeConfigurationEnabled": null,
	"kioskModeScreenOrientation": "notConfigured",
	"kioskModeScreenSaverConfigurationEnabled": null,
	"kioskModeShowAppNotificationBadge": null,
	"kioskModeShowDeviceInfo": null,
	"kioskModeUseManagedHomeScreenApp": null,
	"kioskModeVirtualHomeButtonType": "notConfigured",
	"kioskModeWallpaperUrl": null,
	"kioskModeWiFiConfigurationEnabled": null,
	"locateDeviceLostModeEnabled": true,
	"microsoftLauncherConfigurationEnabled": true,
	"microsoftLauncherDockPresenceConfiguration": "show",
	"microsoftLauncherSearchBarPlacementConfiguration": null,
	"passwordBlockKeyguardFeatures": [
		"allFeatures",
		"biometrics",
		"camera",
		"face",
		"fingerprint",
		"iris",
		"notifications",
		"remoteInput",
		"trustAgents",
		"unredactedNotifications"
	],
	"passwordExpirationDays": 365,
	"passwordMinimumLength": 8,
	"passwordMinimumLetterCharacters": null,
	"passwordMinimumLowerCaseCharacters": null,
	"passwordMinimumNonLetterCharacters": null,
	"passwordMinimumNumericCharacters": null,
	"passwordMinimumSymbolCharacters": null,
	"passwordMinimumUpperCaseCharacters": null,
	"passwordPreviousPasswordCountToBlock": 1,
	"passwordRequiredType": "numericComplex",
	"passwordRequireUnlock": "deviceDefault",
	"passwordSignInFailureCountBeforeFactoryReset": 8,
	"personalProfilePlayStoreMode": "notConfigured",
	"roleScopeTagIds": [
		"0"
	],
	"securityRequireVerifyApps": true,
	"storageBlockExternalMedia": true,
	"storageBlockUsbFileTransfer": true,
	"systemUpdateFreezePeriods": [],
	"systemWindowsBlocked": true,
	"usersBlockAdd": true,
	"usersBlockRemove": true,
	"vpnAlwaysOnLockdownMode": false,
	"vpnAlwaysOnPackageIdentifier": "",
	"wifiBlockEditConfigurations": true,
	"workProfilePasswordRequiredType": "deviceDefault",
	"workProfilePasswordRequireUnlock": "deviceDefault"
}
"@

##Create Profile
write-host "Creating Android Enrollment Profile"
$androidprofile = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Profile created successfully"

##Get ID
$androidprofileid = $androidprofile.id
write-host "Profile ID: $androidprofileid"

##Populate URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$androidprofileid/assign"

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

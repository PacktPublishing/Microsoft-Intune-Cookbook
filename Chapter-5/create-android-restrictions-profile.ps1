$name = "Android Device Restrictions"
$description = "Android Device Restrictions"
$groupid = "00000000-0000-0000-0000-000000000000"

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

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

$androidprofile = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

$androidprofileid = $androidprofile.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$androidprofileid/assign"

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

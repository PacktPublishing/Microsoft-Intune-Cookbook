$groupid = "00000000000000000000"

$uri = "https://graph.microsoft.com/beta/deviceManagement/templates/d1174162-1dd2-4976-affc-6667049ab0ae/createInstance"

$json = @"

{
	"description": "Encrypts drives to 256bit",
	"displayName": "BitLocker Encryption",
	"roleScopeTagIds": [
		"0"
	],
	"settingsDelta": [
		{
			"@odata.type": "#microsoft.graph.deviceManagementComplexSettingInstance",
			"definitionId": "deviceConfiguration--windows10EndpointProtectionConfiguration_bitLockerSystemDrivePolicy",
			"id": "7913db8e-8358-458a-b025-d45857dbe16b",
			"valueJson": "{\"startupAuthenticationRequired\":false,\"startupAuthenticationTpmUsage\":null,\"startupAuthenticationTpmPinUsage\":null,\"startupAuthenticationTpmKeyUsage\":null,\"startupAuthenticationTpmPinAndKeyUsage\":null,\"startupAuthenticationBlockWithoutTpmChip\":false,\"prebootRecoveryEnableMessageAndUrl\":false,\"prebootRecoveryMessage\":null,\"prebootRecoveryUrl\":null,\"recoveryOptions\":null,\"encryptionMethod\":\"xtsAes256\",\"minimumPinLength\":null}"
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementComplexSettingInstance",
			"definitionId": "deviceConfiguration--windows10EndpointProtectionConfiguration_bitLockerFixedDrivePolicy",
			"id": "d172cbcc-030f-4b78-af35-c0791f584b1d",
			"valueJson": "{\"recoveryOptions\":{\"recoveryKeyUsage\":\"allowed\",\"recoveryInformationToStore\":\"passwordAndKey\",\"enableRecoveryInformationSaveToStore\":true,\"recoveryPasswordUsage\":\"required\",\"hideRecoveryOptions\":false,\"enableBitLockerAfterRecoveryInformationToStore\":false,\"blockDataRecoveryAgent\":false},\"requireEncryptionForWriteAccess\":true,\"encryptionMethod\":\"xtsAes256\"}"
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementComplexSettingInstance",
			"definitionId": "deviceConfiguration--windows10EndpointProtectionConfiguration_bitLockerRemovableDrivePolicy",
			"id": "ed70ea1b-7f30-4a78-995e-8b4282d5d11b",
			"valueJson": "{\"encryptionMethod\":\"aesCbc256\",\"requireEncryptionForWriteAccess\":true,\"blockCrossOrganizationWriteAccess\":false}"
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementBooleanSettingInstance",
			"definitionId": "deviceConfiguration--windows10EndpointProtectionConfiguration_bitLockerDisableWarningForOtherDiskEncryption",
			"id": "f4e6b4ea-579a-45e0-9aa0-5705ca646b0c",
			"value": true
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementBooleanSettingInstance",
			"definitionId": "deviceConfiguration--windows10EndpointProtectionConfiguration_bitLockerAllowStandardUserEncryption",
			"id": "5282a74a-1e48-4b34-a4e5-4ab2e0f7049b",
			"value": true
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementStringSettingInstance",
			"definitionId": "deviceConfiguration--windows10EndpointProtectionConfiguration_bitLockerRecoveryPasswordRotation",
			"id": "9e9775ea-bbf0-47a4-bf8a-c27f63b983ef",
			"value": "enabledForAzureAd"
		}
	]
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignuri = "https://graph.microsoft.com/beta/deviceManagement/intents/$policyid/assign"

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

Invoke-MgGraphRequest -Method POST -Uri $assignuri -Body $assignjson -ContentType "application/json"
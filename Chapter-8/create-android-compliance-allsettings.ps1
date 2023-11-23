##Set Variables
$name = "Android-Compliance-FullyManaged"
$description = "Android Compliance Policy for Fully Managed Devices"
$groupid = "000000-0000-0000-0000-000000000000"

##Set Graph API URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"

##Populate JSON Body
$json = @"
    {
        "@odata.type": "#microsoft.graph.androidDeviceOwnerCompliancePolicy",
        "advancedThreatProtectionRequiredSecurityLevel": "secured",
        "description": "$description",
        "deviceThreatProtectionEnabled": true,
        "deviceThreatProtectionRequiredSecurityLevel": "secured",
        "displayName": "$name",
        "id": "00000000-0000-0000-0000-000000000000",
        "localActions": [],
        "osMaximumVersion": "13.1",
        "osMinimumVersion": "8.1",
        "passwordExpirationDays": 365,
        "passwordMinimumLength": 8,
        "passwordMinimumLetterCharacters": 8,
        "passwordMinimumLowerCaseCharacters": 1,
        "passwordMinimumNonLetterCharacters": 1,
        "passwordMinimumNumericCharacters": 1,
        "passwordMinimumSymbolCharacters": 1,
        "passwordMinimumUpperCaseCharacters": 1,
        "passwordMinutesOfInactivityBeforeLock": 5,
        "passwordPreviousPasswordCountToBlock": 24,
        "passwordRequired": true,
        "passwordRequiredType": "alphanumericWithSymbols",
        "roleScopeTagIds": [
            "0"
        ],
        "scheduledActionsForRule": [
            {
                "ruleName": "PasswordRequired",
                "scheduledActionConfigurations": [
                    {
                        "actionType": "block",
                        "gracePeriodHours": 0,
                        "notificationMessageCCList": [],
                        "notificationTemplateId": ""
                    },
                    {
                        "actionType": "notification",
                        "gracePeriodHours": 120,
                        "notificationMessageCCList": [],
                        "notificationTemplateId": "6790e94e-ccb9-4936-bbcc-017958b54210"
                    },
                    {
                        "actionType": "pushNotification",
                        "gracePeriodHours": 120,
                        "notificationMessageCCList": [],
                        "notificationTemplateId": ""
                    },
                    {
                        "actionType": "remoteLock",
                        "gracePeriodHours": 240,
                        "notificationMessageCCList": [],
                        "notificationTemplateId": ""
                    },
                    {
                        "actionType": "retire",
                        "gracePeriodHours": 2160,
                        "notificationMessageCCList": [],
                        "notificationTemplateId": ""
                    }
                ]
            }
        ],
        "securityRequireIntuneAppIntegrity": true,
        "securityRequireSafetyNetAttestationBasicIntegrity": true,
        "securityRequireSafetyNetAttestationCertifiedDevice": true,
        "storageRequireEncryption": true
    }
"@

##Create Policy
write-host "Creating Policy"
$androidpolicy = Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"

##Get Policy ID
$androidpolicyid = $androidpolicy.id
write-host "Policy ID: $androidpolicyid"

##Populate assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$androidpolicyid/assign"

##Populate assignment JSON
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

##Assign Policy
write-host "Assigning Policy"
Invoke-MgGraphRequest -uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Policy Assigned"
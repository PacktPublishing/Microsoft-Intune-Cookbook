##Set Variables
$name = "iOS Compliance"
$description = "iOS Compliance Policy"
$groupid = "00000-00000-00000-00000"

##Set Graph API URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"

##Populate JSON Body
$json = @"
{
	"@odata.type": "#microsoft.graph.iosCompliancePolicy",
	"advancedThreatProtectionRequiredSecurityLevel": "unavailable",
	"description": "$description",
	"deviceThreatProtectionEnabled": false,
	"deviceThreatProtectionRequiredSecurityLevel": "unavailable",
	"displayName": "$name",
	"id": "00000000-0000-0000-0000-000000000000",
	"managedEmailProfileRequired": true,
	"passcodeBlockSimple": true,
	"passcodeExpirationDays": 30,
	"passcodeMinimumCharacterSetCount": 1,
	"passcodeMinimumLength": 6,
	"passcodeMinutesOfInactivityBeforeLock": 0,
	"passcodeMinutesOfInactivityBeforeScreenTimeout": 2,
	"passcodePreviousPasscodeBlockCount": 3,
	"passcodeRequired": true,
	"passcodeRequiredType": "alphanumeric",
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
					"actionType": "pushNotification",
					"gracePeriodHours": 48,
					"notificationMessageCCList": [],
					"notificationTemplateId": ""
				},
				{
					"actionType": "remoteLock",
					"gracePeriodHours": 120,
					"notificationMessageCCList": [],
					"notificationTemplateId": ""
				},
				{
					"actionType": "retire",
					"gracePeriodHours": 720,
					"notificationMessageCCList": [],
					"notificationTemplateId": ""
				}
			]
		}
	],
	"securityBlockJailbrokenDevices": true
}
"@

##Create Policy
write-host "Creating Policy"
$iospolicy = Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"

##Get Policy ID
$policyid = $iospolicy.id
write-host "Policy ID: $policyid"

##Populate ID into assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$policyid/assign"

##Populate JSON Body
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
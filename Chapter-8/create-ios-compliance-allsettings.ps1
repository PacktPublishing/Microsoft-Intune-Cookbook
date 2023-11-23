##Set Variables
$name = "iOS Compliance"
$description = "iOS Compliance Policy"
$groupid = "00000-00000-00000-00000"
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"

##Populate JSON Body
$json = @"
{
	"@odata.type": "#microsoft.graph.iosCompliancePolicy",
	"advancedThreatProtectionRequiredSecurityLevel": "secured",
	"deviceThreatProtectionEnabled": true,
	"deviceThreatProtectionRequiredSecurityLevel": "secured",
    "description": "$description",
	"displayName": "$name",
	"id": "00000000-0000-0000-0000-000000000000",
	"managedEmailProfileRequired": true,
	"osMaximumBuildVersion": "16G1114",
	"osMaximumVersion": "16.0",
	"osMinimumBuildVersion": "18A291",
	"osMinimumVersion": "14.0",
	"passcodeBlockSimple": true,
	"passcodeExpirationDays": 60,
	"passcodeMinimumCharacterSetCount": 1,
	"passcodeMinimumLength": 6,
	"passcodeMinutesOfInactivityBeforeLock": 0,
	"passcodeMinutesOfInactivityBeforeScreenTimeout": 0,
	"passcodePreviousPasscodeBlockCount": 4,
	"passcodeRequired": true,
	"passcodeRequiredType": "alphanumeric",
	"restrictedApps": [
		{
			"appId": "com.apple.clips",
			"name": "Clips"
		}
	],
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
					"gracePeriodHours": 240,
					"notificationMessageCCList": [],
					"notificationTemplateId": ""
				},
				{
					"actionType": "remoteLock",
					"gracePeriodHours": 360,
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

##Populate Assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$policyid/assign"

##Populate Assignment JSON
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
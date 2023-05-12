$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

$espuri = "	https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations"

$espjson = @"
{
	"@odata.type": "#microsoft.graph.windows10EnrollmentCompletionPageConfiguration",
	"allowDeviceResetOnInstallFailure": true,
	"allowDeviceUseOnInstallFailure": false,
	"allowLogCollectionOnInstallFailure": true,
	"allowNonBlockingAppInstallation": true,
	"blockDeviceSetupRetryByUser": false,
	"customErrorMessage": "Please call IT support on xxx",
	"description": "120 minute time-out\nContinue on Error\nForce installation of Microsoft To Do",
	"disableUserStatusTrackingAfterFirstUser": true,
	"displayName": "Standard Enrollment",
	"id": "28aa4055-b08d-41bb-b030-8c1adef7fbed",
	"installProgressTimeoutInMinutes": 120,
	"installQualityUpdates": true,
	"roleScopeTagIds": [
		"0"
	],
	"selectedMobileAppIds": [
		"2d7531e9-a16c-43a3-b65b-7f3c550b8a4c"
	],
	"showInstallationProgress": true,
	"trackInstallProgressForAutopilotOnly": true
}
"@

$esp = Invoke-MgGraphRequest -Method POST -Uri $espuri -Body $espjson -OutputType PSObject -ContentType "application/json"

$policyid = $esp.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid/assign"

$assignjson = @"
{
	"enrollmentConfigurationAssignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "48efa53f-466b-41ea-b734-a0aa72a73f89"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -OutputType PSObject -ContentType "application/json"
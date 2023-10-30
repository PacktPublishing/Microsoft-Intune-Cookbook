$pilotgroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$previewgroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$broadgroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$vipgroupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"


$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

$pilotjson = @"
{
	"@odata.type": "#microsoft.graph.windowsUpdateForBusinessConfiguration",
	"allowWindows11Upgrade": true,
	"automaticUpdateMode": "windowsDefault",
	"autoRestartNotificationDismissal": "notConfigured",
	"businessReadyUpdatesOnly": "windowsInsiderBuildSlow",
	"deadlineForFeatureUpdatesInDays": 5,
	"deadlineForQualityUpdatesInDays": 5,
	"deadlineGracePeriodInDays": 2,
	"description": "Pilot Update Ring\nVery first test group\nBeta servicing channel",
	"displayName": "Windows Updates - Pilot Ring",
	"driversExcluded": false,
	"engagedRestartDeadlineInDays": null,
	"engagedRestartSnoozeScheduleForFeatureUpdatesInDays": null,
	"engagedRestartSnoozeScheduleInDays": null,
	"engagedRestartTransitionScheduleForFeatureUpdatesInDays": null,
	"engagedRestartTransitionScheduleInDays": null,
	"featureUpdatesDeferralPeriodInDays": 0,
	"featureUpdatesPaused": false,
	"featureUpdatesRollbackWindowInDays": 10,
	"id": "",
	"installationSchedule": null,
	"microsoftUpdateServiceAllowed": true,
	"postponeRebootUntilAfterDeadline": false,
	"qualityUpdatesDeferralPeriodInDays": 0,
	"qualityUpdatesPaused": false,
	"roleScopeTagIds": [],
	"scheduleImminentRestartWarningInMinutes": null,
	"scheduleRestartWarningInHours": null,
	"skipChecksBeforeRestart": false,
	"updateNotificationLevel": "restartWarningsOnly",
	"updateWeeks": null,
	"userPauseAccess": "disabled",
	"userWindowsUpdateScanAccess": "enabled"
}
"@


$previewjson = @"
{
	"@odata.type": "#microsoft.graph.windowsUpdateForBusinessConfiguration",
	"allowWindows11Upgrade": true,
	"automaticUpdateMode": "windowsDefault",
	"autoRestartNotificationDismissal": "notConfigured",
	"businessReadyUpdatesOnly": "windowsInsiderBuildRelease",
	"deadlineForFeatureUpdatesInDays": 5,
	"deadlineForQualityUpdatesInDays": 5,
	"deadlineGracePeriodInDays": 3,
	"description": "",
	"displayName": "Windows Updates - Preview Ring",
	"driversExcluded": false,
	"engagedRestartDeadlineInDays": null,
	"engagedRestartSnoozeScheduleForFeatureUpdatesInDays": null,
	"engagedRestartSnoozeScheduleInDays": null,
	"engagedRestartTransitionScheduleForFeatureUpdatesInDays": null,
	"engagedRestartTransitionScheduleInDays": null,
	"featureUpdatesDeferralPeriodInDays": 0,
	"featureUpdatesPaused": false,
	"featureUpdatesRollbackWindowInDays": 10,
	"id": "",
	"installationSchedule": null,
	"microsoftUpdateServiceAllowed": true,
	"postponeRebootUntilAfterDeadline": false,
	"qualityUpdatesDeferralPeriodInDays": 7,
	"qualityUpdatesPaused": false,
	"roleScopeTagIds": [],
	"scheduleImminentRestartWarningInMinutes": null,
	"scheduleRestartWarningInHours": null,
	"skipChecksBeforeRestart": false,
	"updateNotificationLevel": "restartWarningsOnly",
	"updateWeeks": null,
	"userPauseAccess": "enabled",
	"userWindowsUpdateScanAccess": "enabled"
}
"@

$broadjson = @"
{
	"@odata.type": "#microsoft.graph.windowsUpdateForBusinessConfiguration",
	"allowWindows11Upgrade": true,
	"automaticUpdateMode": "autoInstallAtMaintenanceTime",
	"autoRestartNotificationDismissal": "notConfigured",
	"businessReadyUpdatesOnly": "userDefined",
	"deadlineForFeatureUpdatesInDays": 5,
	"deadlineForQualityUpdatesInDays": 5,
	"deadlineGracePeriodInDays": 3,
	"description": "",
	"displayName": "Windows Updates - Broad Ring",
	"driversExcluded": false,
	"engagedRestartDeadlineInDays": null,
	"engagedRestartSnoozeScheduleForFeatureUpdatesInDays": null,
	"engagedRestartSnoozeScheduleInDays": null,
	"engagedRestartTransitionScheduleForFeatureUpdatesInDays": null,
	"engagedRestartTransitionScheduleInDays": null,
	"featureUpdatesDeferralPeriodInDays": 0,
	"featureUpdatesPaused": false,
	"featureUpdatesRollbackWindowInDays": 10,
	"id": "",
	"installationSchedule": {
		"@odata.type": "#microsoft.graph.windowsUpdateActiveHoursInstall",
		"activeHoursEnd": "17:00:00.0000000",
		"activeHoursStart": "08:00:00.0000000"
	},
	"microsoftUpdateServiceAllowed": true,
	"postponeRebootUntilAfterDeadline": false,
	"qualityUpdatesDeferralPeriodInDays": 10,
	"qualityUpdatesPaused": false,
	"roleScopeTagIds": [],
	"scheduleImminentRestartWarningInMinutes": null,
	"scheduleRestartWarningInHours": null,
	"skipChecksBeforeRestart": false,
	"updateNotificationLevel": "restartWarningsOnly",
	"updateWeeks": null,
	"userPauseAccess": "enabled",
	"userWindowsUpdateScanAccess": "enabled"
}
"@

$vipjson = @"
{
	"@odata.type": "#microsoft.graph.windowsUpdateForBusinessConfiguration",
	"allowWindows11Upgrade": true,
	"automaticUpdateMode": "autoInstallAndRebootAtScheduledTime",
	"autoRestartNotificationDismissal": "notConfigured",
	"businessReadyUpdatesOnly": "userDefined",
	"deadlineForFeatureUpdatesInDays": null,
	"deadlineForQualityUpdatesInDays": null,
	"deadlineGracePeriodInDays": null,
	"description": "",
	"displayName": "Windows Updates - VIP Ring",
	"driversExcluded": false,
	"engagedRestartDeadlineInDays": null,
	"engagedRestartSnoozeScheduleForFeatureUpdatesInDays": null,
	"engagedRestartSnoozeScheduleInDays": null,
	"engagedRestartTransitionScheduleForFeatureUpdatesInDays": null,
	"engagedRestartTransitionScheduleInDays": null,
	"featureUpdatesDeferralPeriodInDays": 0,
	"featureUpdatesPaused": false,
	"featureUpdatesRollbackWindowInDays": 60,
	"id": "",
	"installationSchedule": {
		"@odata.type": "#microsoft.graph.windowsUpdateScheduledInstall",
		"scheduledInstallDay": "wednesday",
		"scheduledInstallTime": "12:00:00.0000000"
	},
	"microsoftUpdateServiceAllowed": true,
	"postponeRebootUntilAfterDeadline": null,
	"qualityUpdatesDeferralPeriodInDays": 30,
	"qualityUpdatesPaused": false,
	"roleScopeTagIds": [],
	"scheduleImminentRestartWarningInMinutes": null,
	"scheduleRestartWarningInHours": null,
	"skipChecksBeforeRestart": false,
	"updateNotificationLevel": "restartWarningsOnly",
	"updateWeeks": "everyWeek",
	"userPauseAccess": "disabled",
	"userWindowsUpdateScanAccess": "disabled"
}
"@


$previewpolicy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $previewjson -ContentType "application/json" -OutputType PSObject
$broadpolicy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $broadjson -ContentType "application/json" -OutputType PSObject
$vippolicy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $vipjson -ContentType "application/json" -OutputType PSObject
$pilotpolicy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $pilotjson -ContentType "application/json" -OutputType PSObject

$previewpolicyid = $previewpolicy.id
$broadpolicyid = $broadpolicy.id
$vippolicyid = $vippolicy.id
$pilotpolicyid = $pilotpolicy.id



$broadassignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$broadpolicyid/assign"
$vipassignurl = "https://graph.microsoft.com//beta/deviceManagement/deviceConfigurations/$vippolicyid/assign"
$pilotassignurl = "https://graph.microsoft.com//beta/deviceManagement/deviceConfigurations/$pilotpolicyid/assign"
$previewassignurl = "https://graph.microsoft.com//beta/deviceManagement/deviceConfigurations/$previewpolicyid/assign"


$previewassignjson = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$previewgroupid"
			}
		}
	]
}
"@

$pilotassignjson = @"
{
    "assignments": [
        {
            "target": {
                "@odata.type": "#microsoft.graph.groupAssignmentTarget",
                "groupId": "$pilotgroupid"
            }
        }
    ]
}

"@

$vipassignjson = @"
{
    "assignments": [
        {
            "target": {
                "@odata.type": "#microsoft.graph.groupAssignmentTarget",
                "groupId": "$vipgroupid"
            }
        }
    ]
}

"@

$broadjsonassign = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$broadgroupid"
			}
		},
		{
			"target": {
				"@odata.type": "#microsoft.graph.exclusionGroupAssignmentTarget",
				"groupId": "$pilotgroupid"
			}
		},
		{
			"target": {
				"@odata.type": "#microsoft.graph.exclusionGroupAssignmentTarget",
				"groupId": "$previewgroupid"
			}
		},
		{
			"target": {
				"@odata.type": "#microsoft.graph.exclusionGroupAssignmentTarget",
				"groupId": "$vipgroupid"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -Method POST -Uri $previewassignurl -Body $previewassignjson -ContentType "application/json"
Invoke-MgGraphRequest -Method POST -Uri $pilotassignurl -Body $pilotassignjson -ContentType "application/json"
Invoke-MgGraphRequest -Method POST -Uri $vipassignurl -Body $vipassignjson -ContentType "application/json"
Invoke-MgGraphRequest -Method POST -Uri $broadassignurl -Body $broadjsonassign -ContentType "application/json"
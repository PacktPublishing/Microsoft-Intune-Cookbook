##Set Variables
$name = "Update Ring"
$description = "Office Updates for Monthly Enterprise"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Channel options are (case sensitive):
##Current = current
##Semi Annual = deferred
##Monthly = monthlyenterprise
##Semi Annual (Preview) = firstreleasedeferred
##Current Preview = firstreleasecurrent
##Beta = insiderfast
$channel = "monthlyenterprise"

##Set URL
$url  = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

##Set JSON
$json = @"
{
	"description": "$description",
	"name": "$name",
	"platforms": "windows10",
	"roleScopeTagIds": [
		"0"
	],
	"settings": [
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "device_vendor_msft_policy_config_office16v2~policy~l_microsoftofficemachine~l_updates_l_enableautomaticupdates_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_office16v2~policy~l_microsoftofficemachine~l_updates_l_enableautomaticupdates"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "pdates~policy~l_microsoftofficemachine~l_updates_l_updatebranch_l_updatebranchid_$channel"
							},
							"settingDefinitionId": "pdates~policy~l_microsoftofficemachine~l_updates_l_updatebranch_l_updatebranchid"
						}
					],
					"value": "pdates~policy~l_microsoftofficemachine~l_updates_l_updatebranch_1"
				},
				"settingDefinitionId": "pdates~policy~l_microsoftofficemachine~l_updates_l_updatebranch"
			}
		}
	],
	"technologies": "mdm"
}
"@

##Create Profile
write-host "Creating Profile"
$updateprofile = Invoke-MgGraphRequest -Uri $url -Method POST -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Profile Created"

##Get Profile ID
$profileid = $updateprofile.id
write-host "Profile ID: $profileid"

##Populate Assignment URL with ID
$updateurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileid/assign"

##Populate Assignment JSON
$updatejson = @"
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
Invoke-MgGraphRequest -Method POST -Uri $updateurl -ContentType "application/json" -Body $updatejson
write-host "Profile Assigned"
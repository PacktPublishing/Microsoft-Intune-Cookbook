$name = "iOS Settings Catalog"
$description = "Blocks iCloud, App Store and AirDrop"
$groupid = "00000000-0000-0000-0000-000000000000"


$url = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

$json = @"
{
	"description": "$description",
	"name": "$name",
	"platforms": "iOS",
	"roleScopeTagIds": [
		"0"
	],
	"settings": [
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
				"groupSettingCollectionValue": [
					{
						"children": [
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowaccountmodification_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowaccountmodification"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowairdrop_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowairdrop"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowappinstallation_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowappinstallation"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowcloudbackup_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowcloudbackup"
							}
						]
					}
				],
				"settingDefinitionId": "com.apple.applicationaccess_com.apple.applicationaccess"
			}
		}
	],
	"technologies": "mdm,appleRemoteManagement"
}
"@

$createprofile = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
$profileid = $createprofile.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$profileid/assign"
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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"

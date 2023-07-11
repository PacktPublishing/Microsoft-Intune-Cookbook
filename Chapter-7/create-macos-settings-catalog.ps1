$name = "macOS Settings"
$description = "Baseline settings for macOS devices"

$url = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"


$json = @"
{
	"description": "$description",
	"name": "$name",
	"platforms": "macOS",
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
									"value": "com.apple.mcx.filevault2_enable_0"
								},
								"settingDefinitionId": "com.apple.mcx.filevault2_enable"
							}
						]
					}
				],
				"settingDefinitionId": "com.apple.mcx.filevault2_com.apple.mcx.filevault2"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "com.apple.managedclient.preferences_kfmsilentoptin",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
					"value": "123456789"
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "com.apple.managedclient.preferences_filesondemandenabled_true"
				},
				"settingDefinitionId": "com.apple.managedclient.preferences_filesondemandenabled"
			}
		},
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
									"value": "com.apple.applicationaccess_allowerasecontentandsettings_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowerasecontentandsettings"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowfindmydevice_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowfindmydevice"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowfindmyfriends_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowfindmyfriends"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowgamecenter_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowgamecenter"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowitunesfilesharing_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowitunesfilesharing"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "com.apple.applicationaccess_allowusbrestrictedmode_false"
								},
								"settingDefinitionId": "com.apple.applicationaccess_allowusbrestrictedmode"
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

$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -OutputType PSObject -ContentType "application/json"

$policyid = $policy.id


$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyid/assign"

$json = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"
			}
		}
	]
}
"@

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $json -OutputType PSObject -ContentType "application/json"

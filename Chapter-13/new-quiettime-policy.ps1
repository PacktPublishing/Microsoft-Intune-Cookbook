$name = "Quiet Time - Evenings Weekends"
$description = "Turn off notifications evenings and weekends"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$url = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
$json = @"
{
	"description": "$description",
	"name": "$name",
	"platforms": "android,iOS",
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
					"children": [
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance",
							"choiceSettingCollectionValue": [
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsallday_daysoftheweek_0"
								},
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsallday_daysoftheweek_6"
								}
							],
							"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_mutenotificationsallday_daysoftheweek"
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "4f48386d-2faa-4f1b-bd23-a75b0f513e42"
					},
					"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsallday_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_mutenotificationsallday",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "c19aaaf1-afe1-4c49-a6b1-80b51ccdf5ec"
				}
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
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_starttime",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "18:00:00"
							}
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance",
							"choiceSettingCollectionValue": [
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_daysoftheweek_1"
								},
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_daysoftheweek_2"
								},
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_daysoftheweek_3"
								},
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_daysoftheweek_4"
								},
								{
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_daysoftheweek_5"
								}
							],
							"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_daysoftheweek"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_endtime",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "07:00:00"
							}
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "ce97e111-08b3-4fa2-bf1e-837771a6aa61"
					},
					"value": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_mutenotificationsdaily",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "a9c35a12-ed79-40f9-89bb-7b5bc3718d9b"
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
					"settingValueTemplateReference": {
						"settingValueTemplateId": "c018501f-5efb-49ee-8da0-b472c212d9f4"
					},
					"value": "device_vendor_msft_policy_config_quiettime_allowusertochangesetting_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_quiettime_allowusertochangesetting",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "3c68cbb1-bf32-405b-92d8-65070f55b8c5"
				}
			}
		}
	],
	"technologies": "exchangeOnline",
	"templateReference": {
		"templateDisplayName": "Days of the week",
		"templateId": "2479e1bb-612c-4b98-96b0-157f334143dd_1"
	}
}
"@

$quiettime = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
$quiettimeid = $quiettime.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$quiettimeid')/assign"

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
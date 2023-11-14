$accountname = ""

##Create LAPS policy to use new user account
$lapsurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
$lapsjson = @"
{
	"description": "Uses lapsadmin created via custom OMA-URI policy",
	"name": "LAPS Config",
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
					"children": [
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "device_vendor_msft_laps_policies_passwordagedays_aad",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
								"value": 30
							}
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "4d90f03d-e14c-43c4-86da-681da96a2f92"
					},
					"value": "device_vendor_msft_laps_policies_backupdirectory_1"
				},
				"settingDefinitionId": "device_vendor_msft_laps_policies_backupdirectory",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "a3270f64-e493-499d-8900-90290f61ed8a"
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_laps_policies_administratoraccountname",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "d3d7d492-0019-4f56-96f8-1967f7deabeb"
				},
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
					"settingValueTemplateReference": {
						"settingValueTemplateId": "992c7fce-f9e4-46ab-ac11-e167398859ea"
					},
					"value": "$accountname"
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
						"settingValueTemplateId": "aa883ab5-625e-4e3b-b830-a37a4bb8ce01"
					},
					"value": "device_vendor_msft_laps_policies_passwordcomplexity_4"
				},
				"settingDefinitionId": "device_vendor_msft_laps_policies_passwordcomplexity",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "8a7459e8-1d1c-458a-8906-7b27d216de52"
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_laps_policies_passwordlength",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "da7a1dbd-caf7-4341-ab63-ece6f994ff02"
				},
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"settingValueTemplateReference": {
						"settingValueTemplateId": "d08f1266-5345-4f53-8ae1-4c20e6cb5ec9"
					},
					"value": 20
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
						"settingValueTemplateId": "68ff4f78-baa8-4b32-bf3d-5ad5566d8142"
					},
					"value": "device_vendor_msft_laps_policies_postauthenticationactions_1"
				},
				"settingDefinitionId": "device_vendor_msft_laps_policies_postauthenticationactions",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "d9282eb1-d187-42ae-b366-7081f32dcfff"
				}
			}
		}
	],
	"technologies": "mdm",
	"templateReference": {
		"templateId": "adc46e5a-f4aa-4ff6-aeff-4f27bc525796_1"
	}
}
"@

$lapspolicy = Invoke-MgGraphRequest -Method POST -Uri $lapsurl -Body $lapsjson -ContentType "application/json" -OutputType PSObject

$lapspolicyid = $lapspolicy.id

$lapsassignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$lapspolicyid/assign"

$lapsassignjson = @"
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

Invoke-MgGraphRequest -Method POST -Uri $lapsassignurl -Body $lapsassignjson -ContentType "application/json"
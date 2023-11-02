$groupid = "0000000000000000000000000"

$policyurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

$name = "Windows Security Experience"

$description = "UI Settings"

$policyjson = @"
{
	"description": $description,
	"name": $name,
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
					"settingValueTemplateReference": {
						"settingValueTemplateId": "fc365da9-2c1b-4f79-aa4b-dedca69e728f"
					},
					"value": "vendor_msft_defender_configuration_tamperprotection_options_0"
				},
				"settingDefinitionId": "vendor_msft_defender_configuration_tamperprotection_options",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "5655cab2-7e6b-4c49-9ce2-3865da05f7e6"
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
						"settingValueTemplateId": "3c9b8f91-de2d-4722-8eb5-df9a8a2e8830"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disableaccountprotectionui_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disableaccountprotectionui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "ac41827d-76a1-47fc-a457-d399b5f73181"
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
						"settingValueTemplateId": "1e13433f-873d-4887-bb7f-3ee3da08b23d"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disableappbrowserui_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disableappbrowserui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "66e00605-0812-4071-8ebd-25c59e21da53"
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
						"settingValueTemplateId": "a87e6581-4959-4c05-962c-ebfff40bf7a0"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablecleartpmbutton_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablecleartpmbutton",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "b74cf007-28b9-472d-908c-943963a8e933"
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
						"settingValueTemplateId": "5015408c-9b54-4fe2-8901-049893a887b9"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disabledevicesecurityui_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disabledevicesecurityui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "2d94cb1f-cbd6-4c9e-8117-1e3b0f3538d8"
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
						"settingValueTemplateId": "6add170a-7868-41d1-82a9-1038d2b3ce2b"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablefamilyui_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablefamilyui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "afcadc31-118d-4a5f-8a70-9f214389aa11"
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
						"settingValueTemplateId": "ebff67f1-8ca3-4450-a58e-ca4a7fa30e17"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablehealthui_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablehealthui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "b5b6359e-b835-420d-a341-9ed4e1340b82"
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
						"settingValueTemplateId": "46da9ebb-fe6a-4a70-8e2d-6a3359ddb655"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablenetworkui_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablenetworkui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "5f789df1-df7d-446e-bac4-f00bde46d9f2"
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
						"settingValueTemplateId": "aeb811f1-7980-4c19-a6b9-959aa84582c8"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disableenhancednotifications_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disableenhancednotifications",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "90d71ec1-eace-4cf1-a2da-023962fac6c5"
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
						"settingValueTemplateId": "355986f7-fe53-4d4b-957c-babcf6d3cd75"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disabletpmfirmwareupdatewarning_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disabletpmfirmwareupdatewarning",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "97f189ba-bcf6-4cd4-9b28-84866e982486"
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
						"settingValueTemplateId": "c7d8d335-5b76-464b-bb16-76cbe8abfa34"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablevirusui_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablevirusui",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "0a794014-5f4b-48ac-bcc1-c01c520036ad"
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
						"settingValueTemplateId": "251963db-3981-4ca3-8df1-b92f0a661c75"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_hideransomwaredatarecovery_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_hideransomwaredatarecovery",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "af974717-e1f1-475b-83f6-548c70e97028"
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
						"settingValueTemplateId": "e0ce0a98-40e4-47ac-82e2-9de0616c6760"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_enablecustomizedtoasts_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_enablecustomizedtoasts",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "bcf504b2-0285-4ec5-8d3c-cf135d98d925"
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
						"settingValueTemplateId": "0a59e152-c250-43a6-88bb-72b6a48f48dd"
					},
					"value": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_enableinappcustomization_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_enableinappcustomization",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "71b7efe5-c134-40d4-9d88-463592e367a7"
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_policy_config_windowsdefendersecuritycenter_companyname",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "86d04a37-6b64-40a2-b6bf-cab433e68950"
				},
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
					"settingValueTemplateReference": {
						"settingValueTemplateId": "d9b4a5a8-1ffb-4f01-9438-992db2988eec"
					},
					"value": "Intune Cookbook"
				}
			}
		}
	],
	"technologies": "mdm,microsoftSense",
	"templateReference": {
		"templateId": "d948ff9b-99cb-4ee0-8012-1fbc09685377_1"
	}
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $policyurl -Body $policyjson -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyid/assign"
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

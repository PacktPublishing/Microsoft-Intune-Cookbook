$name = "Linux Compliance"
$description = "Linux Compliance, non-custom"
$url = "https://graph.microsoft.com/beta/deviceManagement/compliancePolicies"
$groupid = "00000000-0000-0000-0000-000000000000"
$jsonscriptpath = "C:\temp\linuxjsonscript.json"

##convert to base64
$bytes = [System.Text.Encoding]::UTF8.GetBytes($jsonscriptpath)

$json = @"
{
	"description": "$description",
	"name": "$name",
	"platforms": "linux",
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
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "linux_distribution_alloweddistros_item_maximumversion",
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"value": "23.04"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "linux_distribution_alloweddistros_item_minimumversion",
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"value": "17.04"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "linux_distribution_alloweddistros_item_`$type_ubuntu"
								},
								"settingDefinitionId": "linux_distribution_alloweddistros_item_`$type"
							}
						]
					}
				],
				"settingDefinitionId": "linux_distribution_alloweddistros"
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
							"settingDefinitionId": "linux_customcompliance_discoveryscript",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationReferenceSettingValue",
								"value": "d5ce302b-125e-4602-8dd0-b4a73afcf1a7"
							}
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "linux_customcompliance_rules",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "$bytes"
							}
						}
					],
					"value": "linux_customcompliance_required_true"
				},
				"settingDefinitionId": "linux_customcompliance_required"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "linux_deviceencryption_required_true"
				},
				"settingDefinitionId": "linux_deviceencryption_required"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "linux_passwordpolicy_minimumdigits",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"value": 1
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "linux_passwordpolicy_minimumlength",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"value": 1
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "linux_passwordpolicy_minimumlowercase",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"value": 1
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "linux_passwordpolicy_minimumsymbols",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"value": 1
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "linux_passwordpolicy_minimumuppercase",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"value": 1
				}
			}
		}
	],
	"technologies": "linuxMdm"
}
"@

$linuxpolicy = Invoke-MgGraphRequest -uri $url -Method POST -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $linuxpolicy.id

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

Invoke-MgGraphRequest -uri $assignurl -Method POST -Body $assignjson -ContentType "application/json" -OutputType PSObject
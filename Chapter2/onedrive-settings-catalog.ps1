$url = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

$policyname = "Onedrive Configuration"
$policydescription = "Configures Onedrive"
$tenantid = "TENANT ID HERE"
$AADGroupID = "AAD GROUP ID HERE"

$json = @"

{
	"description": "$policydescription",
	"name": "$policyname",
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
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_kfmoptinnowizard_kfmoptinnowizard_dropdown_0"
							},
							"settingDefinitionId": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_kfmoptinnowizard_kfmoptinnowizard_dropdown"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_kfmoptinnowizard_kfmoptinnowizard_textbox",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "$tenantid"
							}
						}
					],
					"value": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_kfmoptinnowizard_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_kfmoptinnowizard"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_silentaccountconfig_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_silentaccountconfig"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_filesondemandenabled_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_onedrivengscv2~policy~onedrivengsc_filesondemandenabled"
			}
		}
	],
	"technologies": "mdm"
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject



$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyid')/assign"

$assignjson = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$AADGroupID"
			}
		}
	]
}
"@

$assign = Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"
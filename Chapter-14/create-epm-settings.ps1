$name = "Elevation Settings Policy"
$description = "Elevation Settings Policy"
$policyuri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

$policyjson = @"
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
					"children": [
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [
									{
										"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
										"choiceSettingValue": {
											"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
											"children": [],
											"value": "device_vendor_msft_policy_elevationclientsettings_reportingscope_2"
										},
										"settingDefinitionId": "device_vendor_msft_policy_elevationclientsettings_reportingscope"
									}
								],
								"value": "device_vendor_msft_policy_elevationclientsettings_senddata_1"
							},
							"settingDefinitionId": "device_vendor_msft_policy_elevationclientsettings_senddata"
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "a13cc55c-307a-4962-aaec-20b832bf75c7"
					},
					"value": "device_vendor_msft_policy_elevationclientsettings_enableepm_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_elevationclientsettings_enableepm",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "58a79a4b-ba9b-4923-a7a5-6dc1a9f638a4"
				}
			}
		}
	],
	"technologies": "mdm,endpointPrivilegeManagement",
	"templateReference": {
		"templateId": "e7dcaba4-959b-46ed-88f0-16ba39b14fd8_1"
	}
}
"@

$addpolicy = Invoke-MgGraphRequest -method POST -Uri $policyuri -Body $policyjson -ContentType "application/json" -OutputType PSObject

$policyid = $addpolicy.id

$policyassignuri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyid/assign"
$policyassignjson = @"
{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"
			}
		}
	]
}
"@
Invoke-MgGraphRequest -Method POST -Uri $policyassignuri -Body $policyassignjson -ContentType "application/json"
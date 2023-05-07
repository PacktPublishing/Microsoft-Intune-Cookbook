

$settingsurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
$json = @"
{
	"description": "",
	"name": "Windows Hello for Business",
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
					"value": "device_vendor_msft_passportforwork_biometrics_usebiometrics_true"
				},
				"settingDefinitionId": "device_vendor_msft_passportforwork_biometrics_usebiometrics"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "device_vendor_msft_passportforwork_biometrics_enableesswithsupportedperipherals_1"
				},
				"settingDefinitionId": "device_vendor_msft_passportforwork_biometrics_enableesswithsupportedperipherals"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "device_vendor_msft_passportforwork_biometrics_facialfeaturesuseenhancedantispoofing_true"
				},
				"settingDefinitionId": "device_vendor_msft_passportforwork_biometrics_facialfeaturesuseenhancedantispoofing"
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
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_digits_0"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_digits"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_enablepinrecovery_true"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_enablepinrecovery"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_expiration",
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
									"value": 21
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_lowercaseletters_0"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_lowercaseletters"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_maximumpinlength",
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
									"value": 127
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_minimumpinlength",
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
									"value": 6
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_history",
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
									"value": 3
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_requiresecuritydevice_true"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_requiresecuritydevice"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_excludesecuritydevices_tpm12_true"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_excludesecuritydevices_tpm12"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_specialcharacters_0"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_specialcharacters"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_uppercaseletters_0"
								},
								"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}_policies_pincomplexity_uppercaseletters"
							}
						]
					}
				],
				"settingDefinitionId": "device_vendor_msft_passportforwork_{tenantid}"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
				"choiceSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
					"children": [],
					"value": "device_vendor_msft_passportforwork_securitykey_usesecuritykeyforsignin_1"
				},
				"settingDefinitionId": "device_vendor_msft_passportforwork_securitykey_usesecuritykeyforsignin"
			}
		}
	],
	"technologies": "mdm"
}
"@

$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $body -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
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

Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
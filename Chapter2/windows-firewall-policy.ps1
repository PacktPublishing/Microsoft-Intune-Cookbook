$groupid = "00000000000000000000"

$uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

$json = @"
{
	"description": "Baseline Firewall Settings",
	"name": "Windows Firewall Settings",
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
								"value": "vendor_msft_firewall_mdmstore_domainprofile_defaultinboundaction_1"
							},
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_domainprofile_defaultinboundaction"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "vendor_msft_firewall_mdmstore_domainprofile_defaultoutboundaction_0"
							},
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_domainprofile_defaultoutboundaction"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_domainprofile_logfilepath",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "%systemroot%\\system32\\LogFiles\\Firewall\\pfirewall.log"
							}
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_domainprofile_logmaxfilesize",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
								"value": 1024
							}
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "120c5dbe-0c88-46f0-b897-2c996d3e5277"
					},
					"value": "vendor_msft_firewall_mdmstore_domainprofile_enablefirewall_true"
				},
				"settingDefinitionId": "vendor_msft_firewall_mdmstore_domainprofile_enablefirewall",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "7714c373-a19a-4b64-ba6d-2e9db04a7684"
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
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "vendor_msft_firewall_mdmstore_privateprofile_defaultoutboundaction_0"
							},
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_privateprofile_defaultoutboundaction"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_privateprofile_logmaxfilesize",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
								"value": 1024
							}
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "vendor_msft_firewall_mdmstore_privateprofile_defaultinboundaction_1"
							},
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_privateprofile_defaultinboundaction"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_privateprofile_logfilepath",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "%systemroot%\\system32\\LogFiles\\Firewall\\pfirewall.log"
							}
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "9d55dfae-d55f-4f2a-af03-9a9524f61e76"
					},
					"value": "vendor_msft_firewall_mdmstore_privateprofile_enablefirewall_true"
				},
				"settingDefinitionId": "vendor_msft_firewall_mdmstore_privateprofile_enablefirewall",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "1c14f914-69bb-49f8-af5b-e29173a6ee95"
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
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_publicprofile_logmaxfilesize",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
								"value": 1024
							}
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "vendor_msft_firewall_mdmstore_publicprofile_defaultoutboundaction_0"
							},
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_publicprofile_defaultoutboundaction"
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_publicprofile_logfilepath",
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"value": "%systemroot%\\system32\\LogFiles\\Firewall\\pfirewall.log"
							}
						},
						{
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
							"choiceSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
								"children": [],
								"value": "vendor_msft_firewall_mdmstore_publicprofile_defaultinboundaction_1"
							},
							"settingDefinitionId": "vendor_msft_firewall_mdmstore_publicprofile_defaultinboundaction"
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "c38694c7-51a4-4a35-8f64-b10866a04776"
					},
					"value": "vendor_msft_firewall_mdmstore_publicprofile_enablefirewall_true"
				},
				"settingDefinitionId": "vendor_msft_firewall_mdmstore_publicprofile_enablefirewall",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "e2714734-708e-4286-8ae9-d56821e306a3"
				}
			}
		}
	],
	"technologies": "mdm,microsoftSense",
	"templateReference": {
		"templateId": "6078910e-d808-4a9f-a51d-1b8a7bacb7c0_1"
	}
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignuri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyid/assign"

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

Invoke-MgGraphRequest -Method POST -Uri $assignuri -Body $assignjson -ContentType "application/json"
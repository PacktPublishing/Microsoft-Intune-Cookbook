##Set Group ID
$groupid = "0000000000000000000000000"

##Set URL
$policyurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

##Populate JSON
write-host "Populating JSON"
$policyjson = @"
{
	"description": "Default Anti-Virus Policy",
	"name": "Anti-Virus Policy",
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
						"settingValueTemplateId": "9ead75d4-6f30-4bc5-8cc5-ab0f999d79f0"
					},
					"value": "device_vendor_msft_policy_config_defender_allowarchivescanning_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowarchivescanning",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "7c5c9cde-f74d-4d11-904f-de4c27f72d89"
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
						"settingValueTemplateId": "905921da-95e2-4a10-9e30-fe5540002ce1"
					},
					"value": "device_vendor_msft_policy_config_defender_allowbehaviormonitoring_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowbehaviormonitoring",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "8eef615a-1aa0-46f4-a25a-12cbe65de5ab"
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
						"settingValueTemplateId": "16fe8afd-67be-4c50-8619-d535451a500c"
					},
					"value": "device_vendor_msft_policy_config_defender_allowcloudprotection_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowcloudprotection",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "7da139f1-9b7e-407d-853a-c2e5037cdc70"
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
						"settingValueTemplateId": "fdf107fd-e13b-4507-9d8f-db4d93476af9"
					},
					"value": "device_vendor_msft_policy_config_defender_allowemailscanning_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowemailscanning",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "b0d9ee81-de6a-4750-86d7-9397961c9852"
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
						"settingValueTemplateId": "3e920b10-3773-4ac5-957e-e5573aec6d04"
					},
					"value": "device_vendor_msft_policy_config_defender_allowfullscanonmappednetworkdrives_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowfullscanonmappednetworkdrives",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "dac47505-f072-48d6-9f23-8d93262d58ed"
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
						"settingValueTemplateId": "366c5727-629b-4a81-b50b-52f90282fa2c"
					},
					"value": "device_vendor_msft_policy_config_defender_allowfullscanremovabledrivescanning_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowfullscanremovabledrivescanning",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "fb36e70b-5bc9-488a-a949-8ea3ac1634d5"
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
						"settingValueTemplateId": "df4e6cbd-f7ff-41c8-88cd-fa25264a237e"
					},
					"value": "device_vendor_msft_policy_config_defender_allowioavprotection_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowioavprotection",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "fa06231d-aed4-4601-b631-3a37e85b62a0"
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
						"settingValueTemplateId": "0492c452-1069-4b91-9363-93b8e006ab12"
					},
					"value": "device_vendor_msft_policy_config_defender_allowrealtimemonitoring_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowrealtimemonitoring",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "f0790e28-9231-4d37-8f44-84bb47ca1b3e"
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
						"settingValueTemplateId": "7b8c858c-a17d-4623-9e20-f34b851670ce"
					},
					"value": "device_vendor_msft_policy_config_defender_allowscanningnetworkfiles_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowscanningnetworkfiles",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "f8f28442-0a6b-4b52-b42c-d31d9687c1cf"
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
						"settingValueTemplateId": "ab9e4320-c953-4067-ac9a-be2becd06b4a"
					},
					"value": "device_vendor_msft_policy_config_defender_allowscriptscanning_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowscriptscanning",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "000cf176-949c-4c08-a5d4-90ed43718db7"
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
						"settingValueTemplateId": "4b6c9739-4449-4006-8e5f-3049136470ea"
					},
					"value": "device_vendor_msft_policy_config_defender_allowuseruiaccess_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowuseruiaccess",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "0170a900-b0bc-4ccc-b7ce-dda9be49189b"
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_avgcpuloadfactor",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "816cc03e-8f96-4cba-b14f-2658d031a79a"
				},
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"settingValueTemplateReference": {
						"settingValueTemplateId": "37195fb1-3743-4c8e-a0ce-b6fae6fa3acd"
					},
					"value": 50
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
						"settingValueTemplateId": "010779d1-edd4-441d-8034-89ad57a863fe"
					},
					"value": "device_vendor_msft_policy_config_defender_checkforsignaturesbeforerunningscan_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_checkforsignaturesbeforerunningscan",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "4fea56e3-7bb6-4ad3-88c6-e364dd2f97b9"
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
						"settingValueTemplateId": "517b4e84-e933-42b9-b92f-00e640b1a82d"
					},
					"value": "device_vendor_msft_policy_config_defender_cloudblocklevel_2"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_cloudblocklevel",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "c7a37009-c16e-4145-84c8-89a8c121fb15"
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
						"settingValueTemplateId": "045a4a13-deee-4e24-9fe4-985c9357680d"
					},
					"value": "device_vendor_msft_policy_config_defender_enablelowcpupriority_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_enablelowcpupriority",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "cdeb96cf-18f5-4477-a710-0ea9ecc618af"
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
						"settingValueTemplateId": "ee58fb51-9ae5-408b-9406-b92b643f388a"
					},
					"value": "device_vendor_msft_policy_config_defender_enablenetworkprotection_2"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_enablenetworkprotection",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "f53ab20e-8af6-48f5-9fa1-46863e1e517e"
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
						"settingValueTemplateId": "2d790211-18cb-4e32-b8cc-97407e2c0b45"
					},
					"value": "device_vendor_msft_policy_config_defender_puaprotection_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_puaprotection",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "c0135c2a-f802-44f4-9b71-b0b976411b8c"
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
						"settingValueTemplateId": "6b4e3497-cfbb-4761-a152-de935bbf3f07"
					},
					"value": "device_vendor_msft_policy_config_defender_realtimescandirection_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_realtimescandirection",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "f5ff00a4-e5c7-44cf-a650-9c7619ff1561"
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
						"settingValueTemplateId": "70c8f42e-ee6a-4ef1-a070-cb0e9d472581"
					},
					"value": "device_vendor_msft_policy_config_defender_scanparameter_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_scanparameter",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "27ca2652-46f3-4cc7-83f2-bf85ff722d84"
				}
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_schedulequickscantime",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "784a4af1-33fa-45f2-b945-138b7ff3bcb6"
				},
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue",
					"settingValueTemplateReference": {
						"settingValueTemplateId": "5d5c55c8-1a4e-4272-830d-8dc64cd3ac03"
					},
					"value": 120
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
						"settingValueTemplateId": "7f4d9dda-6d48-4353-90ca-9fa7164c7215"
					},
					"value": "device_vendor_msft_policy_config_defender_schedulescanday_0"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_schedulescanday",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "087d3362-7e78-4983-96bc-1f4ea183f0e4"
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
						"settingValueTemplateId": "826ed4b6-e04f-4975-9d23-6f0904b0d87e"
					},
					"value": "device_vendor_msft_policy_config_defender_submitsamplesconsent_3"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_submitsamplesconsent",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "bc47ce7d-a251-4cae-a8a2-6e8384904ab7"
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
						"settingValueTemplateId": "3a9774b2-3143-47eb-bbca-d73c0ace2b7e"
					},
					"value": "device_vendor_msft_defender_configuration_disablelocaladminmerge_0"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_disablelocaladminmerge",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "5f9a9c65-dea7-4987-a5f5-b28cfd9762ba"
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
						"settingValueTemplateId": "ed077fee-9803-44f3-b045-aab34d8e6d52"
					},
					"value": "device_vendor_msft_policy_config_defender_allowonaccessprotection_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_allowonaccessprotection",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "afbc322b-083c-4281-8242-ebbb91398b41"
				}
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
									"value": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_severethreats_remove"
								},
								"settingDefinitionId": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_severethreats"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_moderateseveritythreats_quarantine"
								},
								"settingDefinitionId": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_moderateseveritythreats"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_lowseveritythreats_clean"
								},
								"settingDefinitionId": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_lowseveritythreats"
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_highseveritythreats_remove"
								},
								"settingDefinitionId": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction_highseveritythreats"
							}
						]
					}
				],
				"settingDefinitionId": "device_vendor_msft_policy_config_defender_threatseveritydefaultaction",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "f6394bc5-6486-4728-b510-555f5c161f2b"
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
						"settingValueTemplateId": "248fdbe0-e0c9-4b47-bce1-95c8058736fb"
					},
					"value": "device_vendor_msft_defender_configuration_allownetworkprotectiondownlevel_1"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_allownetworkprotectiondownlevel",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "d7342aaf-833d-4afc-92d6-e9621256a3cc"
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
						"settingValueTemplateId": "0333679d-3b8a-4b51-9f8e-bba39b263712"
					},
					"value": "device_vendor_msft_defender_configuration_allowdatagramprocessingonwinserver_1"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_allowdatagramprocessingonwinserver",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "69fa7ce4-6cd8-4699-aff7-024a889c25ce"
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
						"settingValueTemplateId": "90b8ab4a-58fb-4b0a-9639-4c9a9a9efab8"
					},
					"value": "device_vendor_msft_defender_configuration_engineupdateschannel_5"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_engineupdateschannel",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "0d762a6b-9301-457c-b47b-47466280e681"
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
						"settingValueTemplateId": "20cf972c-be3f-4bc1-93d3-781829d55233"
					},
					"value": "device_vendor_msft_defender_configuration_meteredconnectionupdates_1"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_meteredconnectionupdates",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "7e3aaffb-309f-46de-8cd7-25c1a3b19e5b"
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
						"settingValueTemplateId": "43b48d15-4149-4982-9086-4f9ccb0190fd"
					},
					"value": "device_vendor_msft_defender_configuration_platformupdateschannel_5"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_platformupdateschannel",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "737b828d-17ee-4c6a-ac43-206faea94220"
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
						"settingValueTemplateId": "1de23cd5-23f3-4600-88d7-570e8ebbbf39"
					},
					"value": "device_vendor_msft_defender_configuration_securityintelligenceupdateschannel_5"
				},
				"settingDefinitionId": "device_vendor_msft_defender_configuration_securityintelligenceupdateschannel",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "368be8ef-11aa-4c0d-919f-d6ed16bc6950"
				}
			}
		}
	],
	"technologies": "mdm,microsoftSense",
	"templateReference": {
		"templateId": "804339ad-1553-4478-a742-138fb5807418_1"
	}
}
"@
write-host "JSON Populated"

##Create policy
write-host "Creating Policy"
$policy = Invoke-MgGraphRequest -Method POST -Uri $policyurl -Body $policyjson -ContentType "application/json" -OutputType PSObject
write-host "Policy created"

##Grab ID
$policyid = $policy.id
write-host "Policy ID is $policyid"
##Set assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyid/assign"

##Populate JSON
write-host "Populating assignment JSON"
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
write-host "JSON Populated"

##Assign policy
write-host "Assigning Policy"
Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"
write-host "Policy Assigned"

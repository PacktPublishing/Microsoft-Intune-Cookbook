
$groupid = "xxxxx-xxxxx-xxxxx-xxxx"
##Elevationtype can be "Auto" or "User"
$elevationtype = "Auto"
##Description is free text - for file rule
$typedescription = "Automatically approved"
##Authtype can be cert or hash
$authtype = "hash"
$filepath = "C:\windows\System32\cmd.exe"




##Get the Filename
$filename = $filepath | Split-Path -Leaf

##Get the Path only
$pathonly = ($filepath | Split-Path) -replace '\\','\\'
if ($authtype -eq "hash") {
##Get the Filehash
$hash = Get-FileHash -Path $filepath
$hash = $hash.Hash
}
if ($authtype -eq "cert") {
	$cerpath = "$env:temp\$filename.cer"
	Get-AuthenticodeSignature -FilePath $filepath | Select-Object -ExpandProperty SignerCertificate | Export-Certificate -Type CERT -FilePath $cerpath
	##Convert to $cerpath to base64
	$bytes = Get-Content -Path $cerpath -Encoding Byte
$base64 = [System.Convert]::ToBase64String($bytes)
##Delete cert
remove-item $cerpath
}




$addurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

$json = @"
{
	"description": "EPM Policy for $filename in $pathonly",
	"name": "$filename EPM Policy",
	"platforms": "windows10",
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
									"settingValueTemplateReference": {
										"settingValueTemplateId": "2ec26569-c08f-434c-af3d-a50ac4a1ce26"
									},
									"value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_allusers"
								},
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_appliesto",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "0cde1c42-c701-44b1-94b7-438dd4536128"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_description",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "b3714f3a-ead8-4682-a16f-ffa264c9d58f"
								},
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"settingValueTemplateReference": {
										"settingValueTemplateId": "5e82a1e9-ef4f-43ea-8031-93aace2ad14d"
									},
									"value": "$typedescription for $filename"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
								"choiceSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
									"children": [],
									"value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_allowrunelevatedrulerequired"
								},
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_childprocessbehavior"
							},
"@
$jsonhash = @"
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_filehash",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "e4436e2c-1584-4fba-8e38-78737cbbbfdf"
								},
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"settingValueTemplateReference": {
										"settingValueTemplateId": "1adcc6f7-9fa4-4ce3-8941-2ce22cf5e404"
									},
									"value": "$hash"
								}
							},
"@
$jsoncert = @"
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
					"value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_issuingauthority"
				},
				"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_certificatetype"
			},
			{
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_certificatefileupload",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
					"value": "$base64"
				}
			}
		],
		"value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_signaturesource_1"
	},
	"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_signaturesource"
},
"@
$json2user = @"
							{
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
													"value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_ruletype_validation_1"
												}
											],
											"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_ruletype_validation"
										}
									],
									"settingValueTemplateReference": {
										"settingValueTemplateId": "cb2ea689-ebc3-42ea-a7a4-c704bb13e3ad"
									},
									"value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_self"
								},
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_ruletype",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "bc5a31ac-95b5-4ec6-be1f-50a384bb165f"
								}
							},
"@
$json2auto = @"
{
    "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
    "choiceSettingValue": {
        "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
        "children": [],
        "settingValueTemplateReference": {
            "settingValueTemplateId": "cb2ea689-ebc3-42ea-a7a4-c704bb13e3ad"
        },
        "value": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_automatic"
    },
    "settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_ruletype",
    "settingInstanceTemplateReference": {
        "settingInstanceTemplateId": "bc5a31ac-95b5-4ec6-be1f-50a384bb165f"
    }
},
"@
$json3 = @"
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_filedescription",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "5e10c5a9-d3ca-4684-b425-e52238cf3c8b"
								},
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"settingValueTemplateReference": {
										"settingValueTemplateId": "df3081ea-4ea7-4f34-ac87-49b2e84d4c4b"
									},
									"value": "$filename"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_name",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "fdabfcf9-afa4-4dbf-a4ef-d5c1549065e1"
								},
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"settingValueTemplateReference": {
										"settingValueTemplateId": "03f003e5-43ef-4e7e-bf30-57f00781fdcc"
									},
									"value": "$filename Rule"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_filename",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "0c1ceb2b-bbd4-46d4-9ba5-9ee7abe1f094"
								},
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"settingValueTemplateReference": {
										"settingValueTemplateId": "a165327c-f0e5-4c7d-9af1-d856b02191f7"
									},
									"value": "$filename"
								}
							},
							{
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
								"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}_filepath",
								"settingInstanceTemplateReference": {
									"settingInstanceTemplateId": "c3b7fda4-db6a-421d-bf04-d485e9d0cfb1"
								},
								"simpleSettingValue": {
									"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
									"settingValueTemplateReference": {
										"settingValueTemplateId": "f011bcfc-03cd-4b28-a1f4-305278d7a030"
									},
									"value": "$pathonly"
								}
							}
						]
					}
				],
				"settingDefinitionId": "device_vendor_msft_policy_privilegemanagement_elevationrules_{elevationrulename}",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "ee3d2e5f-6b3d-4cb1-af9b-37b02d3dbae2"
				}
			}
		}
	],
	"technologies": "endpointPrivilegeManagement",
	"templateReference": {
		"templateId": "cff02aad-51b1-498d-83ad-81161a393f56_1"
	}
}
"@

if ($authtype -eq "hash") {
	$json1 = $jsonhash
}
else {
	$json1 = $jsoncert
}
if ($elevationtype -eq "Auto") {
   $finaljson = $json + $json1 + $json2auto + $json3
}
else {
    $finaljson = $json + $json1 + $json2user + $json3
}
$addpolicy = Invoke-MgGraphRequest -method POST -Uri $addurl -Body $finaljson -ContentType "application/json"



##Assign
$policyid = $addpolicy.id
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyid')/assign"



$jsonassign = @"

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

Invoke-MgGraphRequest -method POST -Uri $assignurl -Body $jsonassign -ContentType "application/json"

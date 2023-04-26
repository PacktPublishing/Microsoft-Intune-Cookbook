$accountname = ""

function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [int] $length,
        [int] $amountOfNonAlphanumeric = 1
    )
    Add-Type -AssemblyName 'System.Web'
    return [System.Web.Security.Membership]::GeneratePassword($length, $amountOfNonAlphanumeric)
}


$password = Get-RandomPassword -Length 20


##Enable LAPS in AAD
$checkuri = "https://graph.microsoft.com/beta/policies/deviceRegistrationPolicy"
$currentpolicy = Invoke-MgGraphRequest -Method GET -Uri $checkuri -OutputType PSObject -ContentType "application/json"
$currentpolicy.localAdminPassword.isEnabled = $true
$policytojson = $currentpolicy | ConvertTo-Json
Invoke-MgGraphRequest -Method PUT -Uri $checkuri -Body $policytojson -ContentType "application/json"


##Enable Local Admin Account
$createurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
$createjson = @"
{
	"description": "Enable and Rename account",
	"name": "Enable Administrator Account",
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
					"value": "device_vendor_msft_policy_config_localpoliciessecurityoptions_accounts_enableadministratoraccountstatus_1"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_localpoliciessecurityoptions_accounts_enableadministratoraccountstatus"
			}
		},
		{
			"@odata.type": "#microsoft.graph.deviceManagementConfigurationSetting",
			"settingInstance": {
				"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
				"settingDefinitionId": "device_vendor_msft_policy_config_localpoliciessecurityoptions_accounts_renameadministratoraccount",
				"simpleSettingValue": {
					"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
					"value": "$accountname"
				}
			}
		}
	],
	"technologies": "mdm"
}
"@
$createpolicy = Invoke-MgGraphRequest -Method POST -Uri $createurl -Body $createjson -OutputType PSObject -ContentType "application/json"
$createpolicyid = $createpolicy.id

$createassignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$createpolicyid/assign"
$createassignjson = @"
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
Invoke-MgGraphRequest -Method POST -Uri $createassignurl -Body $createassignjson -ContentType "application/json" -OutputType PSObject



##Create Custom Policy for lapsadmin user
$customurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

$customjson = @"
{
	"@odata.type": "#microsoft.graph.windows10CustomConfiguration",
	"description": "Creates a new user to be used with LAPS",
	"displayName": "Windows-LAPS-User",
	"id": "00000000-0000-0000-0000-000000000000",
	"omaSettings": [
		{
			"@odata.type": "#microsoft.graph.omaSettingString",
			"description": "Create lapsadmin and set password",
			"displayName": "Create-User",
			"omaUri": "./Device/Vendor/MSFT/Accounts/Users/$accountname/Password",
			"value": "$password"
		},
		{
			"@odata.type": "#microsoft.graph.omaSettingInteger",
			"description": "Add to admins",
			"displayName": "Add-to-group",
			"omaUri": "./Device/Vendor/MSFT/Accounts/Users/$accountname/LocalUserGroup",
			"value": 2
		}
	],
	"roleScopeTagIds": [
		"0"
	]
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $customurl -Body $customjson -OutputType PSObject -ContentType "application/json"

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

$assignjson = @"
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

Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json" -OutputType PSObject



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
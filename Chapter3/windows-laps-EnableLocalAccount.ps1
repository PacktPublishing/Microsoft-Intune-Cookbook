$accountname = ""

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


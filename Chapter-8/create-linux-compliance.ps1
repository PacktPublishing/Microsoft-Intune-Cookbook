##Set Variables
$name = "Linux Compliance"
$description = "Linux Compliance, non-custom"
$groupid = "00000000-0000-0000-0000-000000000000"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/compliancePolicies"

##Populate JSON Body
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
					"value": 6
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

##Create Policy
write-host "Creating Policy"
$linuxpolicy = Invoke-MgGraphRequest -uri $url -Method POST -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"

##Get Policy ID
$policyid = $linuxpolicy.id
write-host "Policy ID: $policyid"

##Populate ID into assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyid/assign"

##Populate JSON Body
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

##Assign Policy
write-host "Assigning Policy"
Invoke-MgGraphRequest -uri $assignurl -Method POST -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Policy Assigned"
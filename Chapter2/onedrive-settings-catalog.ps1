# Define the URL for the Microsoft Graph API
$url = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

Write-Host "URL defined."

# Define the policy name and description
$policyname = "Onedrive Configuration"
$policydescription = "Configures Onedrive"

Write-Host "Policy name and description defined."

# Define the tenant ID and AAD group ID
$tenantid = "TENANT ID HERE"
$AADGroupID = "AAD GROUP ID HERE"

Write-Host "Tenant ID and AAD Group ID defined."

##Set the JSON
write-host "Setting JSON"
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
write-host "JSON set."

# Invoke the Microsoft Graph API request and store the response in the $policy variable
$policy = Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject

Write-Host "API request invoked and response stored."

# Extract the policy ID from the response
$policyid = $policy.id

Write-Host "Policy ID extracted from response."

# Define the URL for assigning the policy
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyid')/assign"

Write-Host "Assignment URL defined."

# Define the JSON body for the assignment API request
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

Write-Host "JSON body for assignment defined."

# Invoke the assignment API request
$assign = Invoke-MgGraphRequest -Method POST -Uri $assignurl -Body $assignjson -ContentType "application/json"

Write-Host "Assignment API request invoked."
##Set the account name
$accountname = ""

##Enable Local Admin Account
$createurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

##Populate the JSON
write-host "Populating JSON"
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
write-host "JSON Populated"

##Create the policy
write-host "Creating Policy"
$createpolicy = Invoke-MgGraphRequest -Method POST -Uri $createurl -Body $createjson -OutputType PSObject -ContentType "application/json"
write-host "Policy Created"

# Extract the policy ID from the created policy
$createpolicyid = $createpolicy.id
Write-Output "Created Policy ID: $createpolicyid"

# Define the URL for the assignment endpoint of the Microsoft Graph API for the created policy
$createassignurl = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$createpolicyid/assign"
Write-Output "Created Assignment URL: $createassignurl"

# Define the JSON data for the created policy assignment request
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
Write-Output "Created Assignment JSON: $createassignjson"

# Invoke a POST request to the Microsoft Graph API with the created assignment JSON data
Invoke-MgGraphRequest -Method POST -Uri $createassignurl -Body $createassignjson -ContentType "application/json" -OutputType PSObject
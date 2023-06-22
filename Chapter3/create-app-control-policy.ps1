##Add Managed Installer

$posturl = "https://graph.microsoft.com/beta/deviceAppManagement/windowsManagementApp/setAsManagedInstaller"

$geturl = "https://graph.microsoft.com/beta/deviceAppManagement/windowsManagementApp/"

##Check if aleady enabled

$checkmanagedinstaller = Invoke-MgGraphRequest -Method GET -Uri $geturl -OutputType PSObject

if ($checkmanagedinstaller.managedInstaller -eq "enabled") {
    write-host "Managed Installer Configured, nothing more to do"
}
else {
    ##Enable Managed Installer
    Invoke-MgGraphRequest -Method POST -Uri $posturl -Body $body -OutputType PSObject
    write-host "Managed Installer Enabled"
}

##Add Profile
$url = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
$name = "Application Control"
$description = "Application Control Policy"
$groupid = "00000000000"
$wdacxml = ""

if ($wdacxml -eq "") {
##Only for GUI configured
##Allow Managed installers?
$managedinstallers = "false"
##Allow Trusted Installers?
$trustedinstallers = "false"
##Enable Store or Audit only?
$windowsappcontrol = "enable"
}

if ($windowsappcontrol -eq "enable") {
    $windowsappcontrol = "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control_0"
}
else {
    $windowsappcontrol = "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control_1"
}

##This uses just the built-in controls
$jsonpart1 = @"
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
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
							"groupSettingCollectionValue": [
								{
									"children": [
										{
											"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
											"choiceSettingValue": {
												"@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
												"children": [],
												"value": "$windowsappcontrol"
											},
											"settingDefinitionId": "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control"
										}
"@

$jsonpart2a = @"
,{
    "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance",
    "choiceSettingCollectionValue": [
"@
$jsonmanagedyes = @"
        {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
            "children": [],
            "value": "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps_1"
        }
"@
$jsontrustedyes = @"
        {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
            "children": [],
            "value": "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps_0"
        }
"@
$jsonpart2b = @"
    ],
    "settingDefinitionId": "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps"
}
"@
$jsonpart3 = @"
]
}
],
"settingDefinitionId": "device_vendor_msft_policy_config_applicationcontrol_built_in_controls"
}
],
"settingValueTemplateReference": {
"settingValueTemplateId": "b28c7dc4-c7b2-4ce2-8f51-6ebfd3ea69d3"
},
"value": "device_vendor_msft_policy_config_applicationcontrol_built_in_controls_selected"
},
"settingDefinitionId": "device_vendor_msft_policy_config_applicationcontrol_policies_{policyguid}_policiesoptions",
"settingInstanceTemplateReference": {
"settingInstanceTemplateId": "1de98212-6949-42dc-a89c-e0ff6e5da04b"
}
}
}
],
"technologies": "mdm",
"templateReference": {
"templateId": "4321b946-b76b-4450-8afd-769c08b16ffc_1"
}
}
"@


if ($wdacxml -eq "") {

    ##Check if either are set
if ($managedinstallers -eq "true" -or $trustedinstallers -eq "true") {
    $json = $jsonpart1 + $jsonpart2a
    if ($managedinstallers -eq "true" -and $trustedinstallers -eq "true") {
        $json += $jsonmanagedyes + "," + $jsontrustedyes
        }
    else {
    if ($managedinstallers -eq "true") {
    $json += $jsonmanagedyes
    }
    if ($trustedinstallers -eq "true") {
    $json += $jsontrustedyes
    }
    }
    $json += $jsonpart2b + $jsonpart3
}
else {
    $json = $jsonpart1 + $jsonpart3
}


}
else {

##Get the raw data
$rawdata = Get-Content $wdacxml -Raw

##Replace \ with \\
$rawdata = $rawdata -replace '\\', '\\'

##Escape the quotes
$rawdata = $rawdata -replace '"', '\"'

##Replace newlines with \r\n
$rawdata = $rawdata -replace "`r`n", "\r\n"

$json = @"
{
	"creationSource": null,
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
							"@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
							"settingDefinitionId": "device_vendor_msft_policy_config_applicationcontrol_policies_{policyguid}_xml",
							"settingInstanceTemplateReference": {
								"settingInstanceTemplateId": "4d709667-63d7-42f2-8e1b-b780f6c3c9c7"
							},
							"simpleSettingValue": {
								"@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
								"settingValueTemplateReference": {
									"settingValueTemplateId": "88f6f096-dedb-4cf1-ac2f-4b41e303adb5"
								},
								"value": "$rawdata"
							}
						}
					],
					"settingValueTemplateReference": {
						"settingValueTemplateId": "b28c7dc4-c7b2-4ce2-8f51-6ebfd3ea69d3"
					},
					"value": "device_vendor_msft_policy_config_applicationcontrol_configure_xml_selected"
				},
				"settingDefinitionId": "device_vendor_msft_policy_config_applicationcontrol_policies_{policyguid}_policiesoptions",
				"settingInstanceTemplateReference": {
					"settingInstanceTemplateId": "1de98212-6949-42dc-a89c-e0ff6e5da04b"
				}
			}
		}
	],
	"technologies": "mdm",
	"templateReference": {
		"templateDisplayName": "Application Control",
		"templateDisplayVersion": "Version 1",
		"templateFamily": "endpointSecurityApplicationControl",
		"templateId": "4321b946-b76b-4450-8afd-769c08b16ffc_1"
	}
}
"@
}


##Create the policy

$policy = Invoke-MgGraphRequest -Uri $url -Method POST -Body $json -OutputType PSObject -ContentType "application/json"

$policyid = $policy.id

##Assign the policy
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

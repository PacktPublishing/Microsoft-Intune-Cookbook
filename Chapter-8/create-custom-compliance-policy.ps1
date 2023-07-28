$name = "Windows Custom Compliance"
$description = "Checks Manufacturer, Firewall, Malware and Bitlocker"
$publisher = "Publisher"
$loggedonuser = "system"
$runas32 = $false
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceComplianceScripts"

$psscript = @'
$biosinfo = Get-CimInstance -ClassName Win32_ComputerSystem
$manufacturer = $biosinfo.Manufacturer

$domainfirewall= ((Get-NetFirewallProfile | select Name, Enabled | where-object Name -eq Domain | select Enabled).Enabled).ToString()

$noactivemalware = Get-MpThreatDetection
if ($null -eq $noactivemalware) {
    $noactivemalware = "True"
}
else {
    $noactivemalware = "False"
}

$bitlockerprotected = (get-bitlockervolume).ProtectionStatus
$bitlockerencryption = (get-bitlockervolume).VolumeStatus

if (($bitlockerprotected -eq "On") -and ($bitlockerencryption -eq "FullyEncrypted")) {
    $bitlocker = "True"
}
else {
    $bitlocker = "False"
}

$hash = @{ 
    Manufacturer = $manufacturer
    DomainFirewall = $domainfirewall
    NoActiveMalware = $noactivemalware

    Bitlocker = $bitlocker
}

return $hash | ConvertTo-Json -Compress
'@

##Convert to base64

$scriptcontent = [System.Text.Encoding]::UTF8.GetBytes($psscript)
$scriptcontent = [System.Convert]::ToBase64String($scriptcontent)

$json = @"
{
	"description": "$description",
	"detectionScriptContent": "$scriptcontent",
	"displayName": "$name",
	"enforceSignatureCheck": false,
	"id": "",
	"publisher": "$publisher",
	"runAs32Bit": $runas32,
	"runAsAccount": "$loggedonuser"
}
"@

$psscript = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject

$scriptid = $psscript.id

$policyname = "Windows Custom Compliance"

$policydescription = "Custom Compliance ONLY"

$groupid = "000000-0000-0000-0000-000000000000"

$compliancejson = @'
{
    "Rules":[ 
        { 
           "SettingName":"Manufacturer",
           "Operator":"IsEquals",
           "DataType":"String",
           "Operand":"Dell",
           "MoreInfoUrl":"https://www.google.com",
           "RemediationStrings":[ 
              { 
                 "Language":"en_US",
                 "Title":"This machine is not a Dell.",
                 "Description": "We only support Dell devices, please contact us for more information.  You are on an {ActualValue}"
              }
           ]
        },
        { 
          "SettingName":"DomainFirewall",
          "Operator":"IsEquals",
          "DataType":"String",
          "Operand":"True",
          "MoreInfoUrl":"https://support.microsoft.com/en-us/windows/turn-microsoft-defender-firewall-on-or-off-ec0844f7-aebd-0583-67fe-601ecf5d774f",
          "RemediationStrings":[ 
             { 
                "Language": "en_US",
                "Title": "Domain Firewall is Off",
                "Description": "Your domain firewall is switched off, please re-enable."
             }
          ]
       },
       { 
          "SettingName":"NoActiveMalware",
          "Operator":"IsEquals",
          "DataType":"String",
          "Operand":"True",
          "MoreInfoUrl":"https://support.microsoft.com/en-us/windows/stay-protected-with-windows-security-2ae0363d-0ada-c064-8b56-6a39afb6a963",
          "RemediationStrings":[ 
             { 
                "Language": "en_US",
                "Title": "Active Malware Detected",
                "Description": "Active Malware detected, please remediate."
             }
          ]
       },
       { 
          "SettingName":"Bitlocker",
          "Operator":"IsEquals",
          "DataType":"String",
          "Operand":"True",
          "MoreInfoUrl":"https://support.microsoft.com/en-us/windows/turn-on-device-encryption-0c453637-bc88-5f74-5105-741561aae838",
          "RemediationStrings":[ 
             { 
                "Language": "en_US",
                "Title": "Unencrypted",
                "Description": "Your device is not fully encrypted, please encrypt."
             }
          ]
       }
     ]
    }
'@

##Convert to base64

$jsoncontent = [System.Text.Encoding]::UTF8.GetBytes($compliancejson)
$jsoncontent = [System.Convert]::ToBase64String($jsoncontent)


$policyurl = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"

$policyjson = @"
{
	"@odata.type": "#microsoft.graph.windows10CompliancePolicy",
	"description": "$policydescription",
	"deviceCompliancePolicyScript": {
		"deviceComplianceScriptId": "$scriptid",
		"rulesContent": "$jsoncontent",
	},
	"deviceThreatProtectionEnabled": false,
	"deviceThreatProtectionRequiredSecurityLevel": "unavailable",
	"displayName": "$policyname",
	"id": "00000000-0000-0000-0000-000000000000",
	"passwordRequiredType": "deviceDefault",
	"roleScopeTagIds": [
		"0"
	],
	"scheduledActionsForRule": [
		{
			"ruleName": "PasswordRequired",
			"scheduledActionConfigurations": [
				{
					"actionType": "block",
					"gracePeriodHours": 0,
					"notificationMessageCCList": [],
					"notificationTemplateId": ""
				}
			]
		}
	]
}
"@

$compliancepolicy = Invoke-MgGraphRequest -Uri $policyurl -Method Post -Body $policyjson -ContentType "application/json" -OutputType PSObject

$policyid = $compliancepolicy.id

$assignmenturl = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$policyid/assign"

$assignmentjson = @"
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

Invoke-MgGraphRequest -Uri $assignmenturl -Method Post -Body $assignmentjson -ContentType "application/json" -OutputType PSObject

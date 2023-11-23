##Set Variables
$name = "PowerShell Device Script"
$description = "Removes Bing News AppX package and stops Cortana running in search box"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts"

##Set Script Content
$scriptcontent = @'
Get-AppxPackage -allusers -Name Microsoft.BingNews| Remove-AppxPackage -AllUsers

$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (!(Test-Path $Search)) {
    New-Item $Search
}
If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0 
}
'@

##Convert to Base64
$base64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($scriptcontent))


##Populate JSON
$json = @"
{
	"description": "$name",
	"displayName": "$description",
	"enforceSignatureCheck": true,
	"fileName": "platform-script.ps1",
	"roleScopeTagIds": [
		"0"
	],
	"runAs32Bit": false,
	"runAsAccount": "system",
	"scriptContent": "$base64encoded"
}
"@

##Add Script
write-host "Adding Script"
$addscript = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Script Added"

##Get Script ID
$scriptid = $addscript.id
write-host "Script ID is $scriptid"

##Populate ID into Assign JSON
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts/$scriptid/assign"

##Populate JSON
$assignjson = @"
{
	"deviceManagementScriptAssignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}
"@

##Assign Script
write-host "Assigning Script"
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Script Assigned"
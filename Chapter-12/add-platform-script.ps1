$name = "PowerShell Device Script"
$description = "Removes Bing News AppX package and stops Cortana running in search box"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts"


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

$base64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($scriptcontent))

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

$addscript = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
$scriptid = $addscript.id


$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts/$scriptid/assign"
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
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
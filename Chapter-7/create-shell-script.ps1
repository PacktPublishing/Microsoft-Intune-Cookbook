##Set Variables
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceShellScripts"
$name = "Download Wallpaper Background"
$description = "Downloads the wallpaper background to be used with Custom Profile"
$groupid = "000000-0000-0000-0000-000000000000"

##Set Script Path
$scriptpath = "c:\temp\downloadwallpaper.sh"
##Convert the script to base64
write-host "Converting Script to Base64"
$shellscript = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText($scriptpath)))

##Get Filename from path
$filename = [System.IO.Path]::GetFileName($scriptpath)
write-host "Filename: $filename"

##Populate JSON
$json = @"
{
	"blockExecutionNotifications": true,
	"description": "$description",
	"displayName": "$name",
	"executionFrequency": "P1D",
	"fileName": "$filename",
	"retryCount": 3,
	"roleScopeTagIds": [
		"0"
	],
	"runAsAccount": "system",
	"scriptContent": "$shellscript"
}
"@

##Create Policy
write-host "Creating Policy"
$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"

##Get Policy ID
$policyid = $policy.id
write-host "Policy ID: $policyid"

##Populate assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/DeviceShellScripts/$policyid/assign"

##Populate assignment JSON
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

##Assign Policy
write-host "Assigning Policy"
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json"
write-host "Policy Assigned"
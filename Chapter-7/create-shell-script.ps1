$url = "https://graph.microsoft.com/beta/deviceManagement/deviceShellScripts"
$name = "Download Wallpaper Background"
$description = "Downloads the wallpaper background to be used with Custom Profile"

$groupid = "000000-0000-0000-0000-000000000000"

$scriptpath = "c:\temp\downloadwallpaper.sh"
##Convert the script to base64
$shellscript = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText($scriptpath)))

##Get Filename from path
$filename = [System.IO.Path]::GetFileName($scriptpath)


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

$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/DeviceShellScripts/$policyid/assign"

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

Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json"
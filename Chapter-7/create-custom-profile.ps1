$url = "	https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"
$name = "Configure Desktop Wallpaper"
$description = "Forces wallpaper to /Library/Desktop/Wallpaper.jpg\nAs downloaded in Shell Script"
$settingname = "DesktopWallpaper"
$groupid = "000000-0000-0000-0000-000000000000"

$configpath = "c:\temp\wallpaper.mobileconfig"
##Convert the script to base64
$configscript = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText($configpath)))

##Get Filename from path
$filename = [System.IO.Path]::GetFileName($scriptpath)


$json = @"
{
	"@odata.type": "#microsoft.graph.macOSCustomConfiguration",
	"deploymentChannel": "deviceChannel",
	"description": "$description",
	"displayName": "$name",
	"id": "00000000-0000-0000-0000-000000000000",
	"payload": "$configscript",
	"payloadFileName": "$filename",
	"payloadName": "$settingname",
	"roleScopeTagIds": [
		"0"
	]
}
"@

$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

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
##Set Variables
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"
$name = "Configure Desktop Wallpaper"
$description = "Forces wallpaper to /Library/Desktop/Wallpaper.jpg\nAs downloaded in Shell Script"
$settingname = "DesktopWallpaper"
$groupid = "000000-0000-0000-0000-000000000000"

##Set Script Path
$configpath = "c:\temp\wallpaper.mobileconfig"
##Convert the script to base64
write-host "Converting Script to Base64"
$configscript = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText($configpath)))

##Get Filename from path
write-host "Getting Filename"
$filename = [System.IO.Path]::GetFileName($configpath)

##Populate JSON
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

##Create Policy
write-host "Creating Policy"
$policy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Policy Created"

##Get Policy ID
$policyid = $policy.id
write-host "Policy ID: $policyid"

##Populate assignment URL
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$policyid/assign"

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
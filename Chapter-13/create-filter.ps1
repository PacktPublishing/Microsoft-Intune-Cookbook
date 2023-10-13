$name = "ACME Only"
$description = "ACME Only Devices"
$rule = @"
(device.deviceOwnership -eq \"Corporate\")
"@

##Platform Options
## Windows10AndLater
## iOS (iOS Device)
## Android (Android Device Administrator)
## AndroidForWork (Android Enterprise)
## AndroidAOSP
## MacOS
## AndroidMobileApplicationManagement
## iOSMobileApplicationManagement

$platform = "Windows10AndLater"
$url = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters"
$json = @"
{
	"description": "$description",
	"displayName": "$name",
	"platform": "$platform",
	"roleScopeTags": [
		"0"
	],
	"rule": "$rule"
}
"@

Invoke-MgGraphRequest -Uri $url -Method Post -Json $json -ContentType "application/json"
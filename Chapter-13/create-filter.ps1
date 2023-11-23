
##Set Variables
$name = "ACME Only"
$description = "ACME Only Devices"

##Set Rule
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

##Set Platform
$platform = "Windows10AndLater"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters"

##Populate JSON
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

##Send request
write-host "Creating filter"
Invoke-MgGraphRequest -Uri $url -Method Post -body $json -ContentType "application/json"
write-host "Filter created"
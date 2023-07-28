$subject = "First Warning"
$message = "Your device is now showing as non-compliant.  Please contact IT to resolve the issue.\nYour access will be blocked in xx days"
$displayname = "First Alert"

$createnotificationurl = "https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates"

$createnotificationjson = @"
{
	"brandingOptions": "includeCompanyLogo,includeCompanyName,includeContactInformation",
	"displayName": "$displayname",
	"roleScopeTagIds": [
		"0"
	]
}
"@

$createnotification = invoke-mggraphrequest -uri $createnotificationurl -json $createnotificationjson -method post -contenttype "application/json" -outputtype PSObject

$createnotificationid = $createnotification.id

$createnotificationmessageurl = "https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates/$createnotificationid/localizedNotificationMessages"

$createnotificationmessagejson = @"
{
	"isDefault": true,
	"locale": "en-GB",
	"messageTemplate": "$message",
	"subject": "$subject"
}
"@

$createnotificationmessage = invoke-mggraphrequest -uri $createnotificationmessageurl -json $createnotificationmessagejson -method post -contenttype "application/json" -outputtype PSObject